window.addEventListener("load", function() {
    aengine = new AudioEngine();
})
window.addEventListener("message", function(event) {
    data = event.data;
    if (data.act == "play_audio_source") {
        aengine.playAudioSource(data);
    } else if (data.act == "set_audio_source") {
        aengine.setAudioSource(data);
    } else if (data.act == "remove_audio_source") {
        aengine.removeAudioSource(data);
    } else if (data.act == "audio_listener") {
        aengine.setListenerData(data);
    }
});