var clamp = function(val, min, max) { return Math.min(Math.max(min, val), max); }

var is_playing = function(media) {
    return media.currentTime > 0 && !media.paused && !media.ended && media.readyState > 2;
}

function AudioEngine() {
    this.c = new AudioContext();
    //choose processor buffer size (2^(8-14))
    this.processor_buffer_size = Math.pow(2, clamp(Math.floor(Math.log(this.c.sampleRate * 0.1) / Math.log(2)), 8, 14));
    this.c.createScriptProcessor(this.processor_buffer_size, 1, 1);

    this.sources = {};
    this.listener = this.c.listener;
    this.listener.upX.setTargetAtTime(0, this.c.currentTime, 0.1);
    this.listener.upY.setTargetAtTime(0, this.c.currentTime, 0.1);
    this.listener.upZ.setTargetAtTime(1, this.c.currentTime, 0.1);

    this.last_check = new Date().getTime();
}

AudioEngine.prototype.setListenerData = function(data) {
    var l = this.listener;
    l.positionX.setTargetAtTime(data.x, this.c.currentTime, 0.1);
    l.positionY.setTargetAtTime(data.y, this.c.currentTime, 0.1);
    l.positionZ.setTargetAtTime(data.z, this.c.currentTime, 0.1);
    l.forwardX.setTargetAtTime(data.fx, this.c.currentTime, 0.1);
    l.forwardY.setTargetAtTime(data.fy, this.c.currentTime, 0.1);
    l.forwardZ.setTargetAtTime(data.fz, this.c.currentTime, 0.1);

    l.l_coords = []
    l.l_coords.x = data.x
    l.l_coords.y = data.y
    l.l_coords.z = data.z

    var time = new Date().getTime();
    if (time - this.last_check >= 2000) { // every 2s
        this.last_check = time;

        // pause too far away sources and unpause nearest sources paused
        for (var name in this.sources) {
            var source = this.sources[name];

            if (source[3]) { //spatialized
                var dx = data.x - source[2].panner_coords.x;
                var dy = data.y - source[2].panner_coords.y;
                var dz = data.z - source[2].panner_coords.z;
                var dist = Math.sqrt(dx * dx + dy * dy + dz * dz);
                var active_dist = source[2].maxDistance * 2;

                if (!is_playing(source[0]) && dist <= active_dist) {
                    source[0].play();
                } else if (is_playing(source[0]) && dist > active_dist) {
                    source[0].pause();
                }
            }
        }
    }
}

// return [audio, node, panner]
AudioEngine.prototype.setupAudioSource = function(data) {
    var audio = new Audio();
    audio.src = data.url;
    audio.volume = data.volume;
    audio.crossOrigin = "anonymous";

    var spatialized = (data.x != null && data.y != null && data.z != null && data.max_dist != null);
    var node = null;
    var panner = null;

    if (spatialized) {
        node = this.c.createMediaElementSource(audio);

        panner = this.c.createPanner();
        //    panner.panningModel = "HRTF";
        panner.distanceModel = "inverse";
        panner.refDistance = 1;
        panner.maxDistance = data.max_dist;
        panner.rolloffFactor = 1;
        panner.coneInnerAngle = 360;
        panner.coneOuterAngle = 0;
        panner.coneOuterGain = 0;

        panner.panner_coords = []
        panner.panner_coords.x = data.x
        panner.panner_coords.y = data.y
        panner.panner_coords.z = data.z

        panner.positionX.setValueAtTime(data.x, this.c.currentTime);
        panner.positionY.setValueAtTime(data.y, this.c.currentTime);
        panner.positionZ.setValueAtTime(data.z, this.c.currentTime);

        node.connect(panner);
        panner.connect(this.c.destination);
    }

    return [audio, node, panner, spatialized];
}

AudioEngine.prototype.playAudioSource = function(data) {
    var _this = this;

    var spatialized = (data.x != null && data.y != null && data.z != null && data.max_dist != null);
    var dist = 10;
    var active_dist = 0;

    if (spatialized) {
        var dx = this.listener.l_coords.x - data.x;
        var dy = this.listener.l_coords.y - data.y;
        var dz = this.listener.l_coords.z - data.z;
        dist = Math.sqrt(dx * dx + dy * dy + dz * dz);
        active_dist = data.max_dist * 2;
    }

    if (!spatialized || dist <= active_dist) {
        var source = this.setupAudioSource(data);

        // bind deleter
        if (spatialized) {
            source[0].onended = function() {
                source[2].disconnect(_this.c.destination);
            }
        }

        // play
        source[0].play();
    }
}

AudioEngine.prototype.setAudioSource = function(data) {
    this.removeAudioSource(data);

    var source = this.setupAudioSource(data);
    source[0].loop = false;
    this.sources[data.name] = source;

    // play
    var dist = 10;
    var active_dist = 0;
    if (source[3]) { // spatialized
        var dx = this.listener.l_coords.x - source[2].panner_coords.x;
        var dy = this.listener.l_coords.y - source[2].panner_coords.y;
        var dz = this.listener.l_coords.z - source[2].panner_coords.z;
        dist = Math.sqrt(dx * dx + dy * dy + dz * dz);
        active_dist = source[2].maxDistance * 2;
    }

    if (!source[3] || dist <= active_dist)
        source[0].play();
}

AudioEngine.prototype.removeAudioSource = function(data) {
    var source = this.sources[data.name];
    if (source) {
        delete this.sources[data.name];
        source[0].src = "";
        source[0].loop = false;
        if (is_playing(source[0]))
            source[0].pause();
        if (source[3]) //spatialized
            source[2].disconnect(this.c.destination);
    }
}