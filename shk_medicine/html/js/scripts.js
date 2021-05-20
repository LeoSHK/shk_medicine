function hiddenDivs() {
    $("#xray").css("display", "none");
    $("#bloodcount").css("display", "none");
    $("#drugscount").css("display", "none");
    $("#xray-menu").css("display", "none");
    $("#xray-act").css("display", "none");
    $("#reception-menu").css("display", "none");
}

window.addEventListener("message", function(event) {
    data = event.data;

    if (data.act === "xray-menu") {
        $("#xray-menu").css("display", "block");

        $(".act_menu").click(function(event) {
            event.preventDefault();
            var type = $(this).data("exame");

            if (type) $("#xray-menu").css("display", "none");
            var pasc = data.pasc;
            var doctor = data.doctor;
            $("#actbc_username").html(pasc.name);
            $("#actbc_age").html(pasc.age);
            $("#actbc_rg").html(pasc.rg);
            $("#actbc_passp").html(pasc.passp);

            $("#actbc_doctorname").html(doctor.name);
            $("#actbc_doctorjob").html(doctor.job);

            switch (type) {
                case "all":
                    $("#xray").css("display", "block");
                    if (data.body["head"] === true) {
                        $("#head").attr("src", "./images/raiox/head_a.png");
                    } else {
                        $("#head").attr("src", "./images/raiox/head.png");
                    }
                    if (data.body["neck"] === true) {
                        $("#neck").attr("src", "./images/raiox/neck_a.png");
                    } else {
                        $("#neck").attr("src", "./images/raiox/neck.png");
                    }
                    if (data.body["spine"] === true) {
                        $("#spine").attr("src", "./images/raiox/spine_a.png");
                    } else {
                        $("#spine").attr("src", "./images/raiox/spine.png");
                    }
                    if (data.body["upper_body"] === true) {
                        $("#upper_body01").attr("src", "./images/raiox/upper_body01_a.png");
                        $("#upper_body02").attr("src", "./images/raiox/upper_body02_a.png");
                    } else {
                        $("#upper_body01").attr("src", "./images/raiox/upper_body01.png");
                        $("#upper_body02").attr("src", "./images/raiox/upper_body02.png");
                    }
                    if (data.body["lower_body"] === true) {
                        $("#lower_body").attr("src", "./images/raiox/lower_body_a.png");
                    } else {
                        $("#lower_body").attr("src", "./images/raiox/lower_body.png");
                    }
                    if (data.body["larm"] === true) {
                        $("#larm").attr("src", "./images/raiox/larm_a.png");
                    } else {
                        $("#larm").attr("src", "./images/raiox/larm.png");
                    }
                    if (data.body["lhand"] === true) {
                        $("#lhand").attr("src", "./images/raiox/lhand_a.png");
                    } else {
                        $("#lhand").attr("src", "./images/raiox/lhand.png");
                    }
                    if (data.body["lfinger"] === true) {
                        $("#lfinger").attr("src", "./images/raiox/lfinger_a.png");
                    } else {
                        $("#lfinger").attr("src", "./images/raiox/lfinger.png");
                    }
                    if (data.body["lleg"] === true) {
                        $("#lleg").attr("src", "./images/raiox/lleg_a.png");
                    } else {
                        $("#lleg").attr("src", "./images/raiox/lleg.png");
                    }
                    if (data.body["lfoot"] === true) {
                        $("#lfoot").attr("src", "./images/raiox/lfoot_a.png");
                    } else {
                        $("#lfoot").attr("src", "./images/raiox/lfoot.png");
                    }
                    if (data.body["rarm"] === true) {
                        $("#rarm").attr("src", "./images/raiox/rarm_a.png");
                    } else {
                        $("#rarm").attr("src", "./images/raiox/rarm.png");
                    }
                    if (data.body["rhand"] === true) {
                        $("#rhand").attr("src", "./images/raiox/rhand_a.png");
                    } else {
                        $("#rhand").attr("src", "./images/raiox/rhand.png");
                    }
                    if (data.body["rfinger"] === true) {
                        $("#rfinger").attr("src", "./images/raiox/rfinger_a.png");
                    } else {
                        $("#rfinger").attr("src", "./images/raiox/rfinger.png");
                    }
                    if (data.body["rleg"] === true) {
                        $("#rleg").attr("src", "./images/raiox/rleg_a.png");
                    } else {
                        $("#rleg").attr("src", "./images/raiox/rleg.png");
                    }
                    if (data.body["rfoot"] === true) {
                        $("#rfoot").attr("src", "./images/raiox/rfoot_a.png");
                    } else {
                        $("#rfoot").attr("src", "./images/raiox/rfoot.png");
                    }
                    break;
                case "head":
                    $("#xray-act").css("display", "block");

                    if (data.body["head_sh"] === true) {
                        $("#xray-act-image").css(
                            "background-image",
                            "url('./images/raiox/head_x.png')"
                        );
                    } else {
                        $("#xray-act-image").css(
                            "background-image",
                            "url('./images/raiox/head_u.png')"
                        );
                    }
                    break;
                case "upper_body":
                    $("#xray-act").css("display", "block");
                    if (data.body["upper_body_sh"] === true) {
                        $("#xray-act-image").css(
                            "background-image",
                            "url('./images/raiox/upper_body_x.png')"
                        );
                    } else {
                        $("#xray-act-image").css(
                            "background-image",
                            "url('./images/raiox/upper_body_u.png')"
                        );
                    }
                    break;
                case "lower_body":
                    $("#xray-act").css("display", "block");
                    if (data.body["lower_body_sh"] === true) {
                        $("#xray-act-image").css(
                            "background-image",
                            "url('./images/raiox/lower_body_x.png')"
                        );
                    } else {
                        $("#xray-act-image").css(
                            "background-image",
                            "url('./images/raiox/lower_body_u.png')"
                        );
                    }
                    break;
                case "larm":
                    $("#xray-act").css("display", "block");
                    if (data.body["larm_sh"] === true) {
                        $("#xray-act-image").css(
                            "background-image",
                            "url('./images/raiox/larm_x.png')"
                        );
                    } else {
                        $("#xray-act-image").css(
                            "background-image",
                            "url('./images/raiox/larm_u.png')"
                        );
                    }
                    break;
                case "rarm":
                    $("#xray-act").css("display", "block");
                    if (data.body["rarm_sh"] === true) {
                        $("#xray-act-image").css(
                            "background-image",
                            "url('./images/raiox/rarm_x.png')"
                        );
                    } else {
                        $("#xray-act-image").css(
                            "background-image",
                            "url('./images/raiox/rarm_u.png')"
                        );
                    }
                    break;
                case "lleg":
                    $("#xray-act").css("display", "block");
                    if (data.body["lleg_sh"] === true) {
                        $("#xray-act-image").css(
                            "background-image",
                            "url('./images/raiox/lleg_x.png')"
                        );
                    } else {
                        $("#xray-act-image").css(
                            "background-image",
                            "url('./images/raiox/lleg_u.png')"
                        );
                    }
                    break;
                case "rleg":
                    $("#xray-act").css("display", "block");
                    if (data.body["rleg_sh"] === true) {
                        $("#xray-act-image").css(
                            "background-image",
                            "url('./images/raiox/rleg_x.png')"
                        );
                    } else {
                        $("#xray-act-image").css(
                            "background-image",
                            "url('./images/raiox/rleg_u.png')"
                        );
                    }
                    break;
            }

            $("a#act_menu_back").on("click", function(event) {
                $("#xray-menu").css("display", "block");
                $("#xray-act").css("display", "none");
                $("#xray").css("display", "none");
            });
        });
    } else if (data.act === "display") {
        $("#xray").slideDown({ duration: 20000 });
    } else if (data.act === "close") {
        hiddenDivs()
    } else if (data.act === "blood_bag_display") {
        $("#blood_bag").css("height", "0px");
        $("#bag_blood").css("display", "block");
        $("#blood_bag").animate({ height: "253px" }, 60000, function() {
            $("#bag_blood").css("display", "none");
        });
    } else if (data.act === "soro_bag_display" && data.time !== "undefined") {
        $("#soro_bag").css("height", "253px");
        $("#bag_soro").css("display", "block");
        $("#soro_bag").animate({ height: "0px" }, data.time * 1000, function() {
            $("#bag_soro").css("display", "none");
        });
    } else if (data.act === "soro_leoerd_bag_display" && data.time !== "undefined") {
        $("#soro_bag_leoerd").css("height", "253px");
        $("#bag_soro_leoerd").css("display", "block");
        $("#soro_bag_leoerd").animate({ height: "0px" }, data.time * 1000, function() {
            $("#bag_soro_leoerd").css("display", "none");
        });
    } else if (data.act === "trans_blood_bag_display" && data.time !== "undefined") {
        $(".blood_bag_trans").css("height", "253px");
        $("#bag_blood_trans").css("display", "block");
        $(".blood_bag_trans").animate({ height: "0px" }, data.time * 1000, function() {
            $("#bag_blood_trans").css("display", "none");
        });
    } else if (data.act === "trans_blood_bag_cancel") {
        $("#bag_blood_trans").css("display", "none");
    } else if (data.act === "blood_bottle_display") {
        $("#blood_bottle").css("height", "0px");
        $("#bottle_blood").css("display", "block");
        $("#blood_bottle").animate({ height: "203px" }, 20000, function() {
            $("#bottle_blood").css("display", "none");
        });
    } else if (data.act === "info_blood_count") {
        $("#bloodcount").css("display", "block");
        var pasc = data.pasc;
        var doctor = data.doctor;
        $("#bc_username").html(pasc.name);
        $("#bc_age").html(pasc.age);
        $("#bc_rg").html(pasc.rg);
        $("#bc_passp").html(pasc.passp);
        $("#bc_sugar").html(pasc.sugar);
        $("#bc_fat").html(pasc.fat);
        $("#bc_anemia").html(pasc.protein);
        $("#bc_immu").html(pasc.immu);
        $("#bc_doctorname").html(doctor.name);
        $("#bc_doctorjob").html(doctor.job);
    } else if (data.act === "info_toxic_count") {
        $("#drugscount").css("display", "block");
        var pasc = data.pasc;
        var doctor = data.doctor;
        $("#bct_username").html(pasc.name);
        $("#bct_age").html(pasc.age);
        $("#bct_rg").html(pasc.rg);
        $("#bct_passp").html(pasc.passp);
        $("#bct_drugs").html(pasc.drug);
        $("#bct_alcool").html(pasc.alcool);

        $("#bct_doctorname").html(doctor.name);
        $("#bct_doctorjob").html(doctor.job);
    } else if (data.act === "reception_list") {
        $("#reception-menu").css("display", "block");
        $("#reception-list").html("")

        var receptions = data.receptions
        var td = ""

        td = td + '<table class="table display" id="table-reception">';
        td = td + '<thead>';
        td = td + '<tr>';
        td = td + '<th>Fila</th>';
        td = td + '<th>Passaporte</th>';
        td = td + '<th>Nome</th>';
        td = td + '<th>Doutor</th>';
        td = td + '<th>Ações</th>';
        td = td + '</tr>';
        td = td + '</thead>';
        td = td + '<tbody>';

        $.each(receptions, function(index, item) {
            if (item) {
                td = td + '<tr>';
                td = td + '<td class="fila">' + item["fila"] + '</td>';
                td = td + '<td>' + item["passaport"] + '</td>';
                td = td + '<td>' + item["name"] + '</td>';
                if (item["doctor"]) {
                    td = td + '<td class="text-success">' + item["doctorname"] + '</td>';
                } else {
                    td = td + '<td>Sem atendimento</td>';
                }

                td = td + '<td>';
                td = td + '<a href="#" class="act_accept btn-success btn-xs show-cause">?</a> ';
                if (item["active"] !== true) {
                    td = td + '<a href="#" class="act_accept btn-success btn-xs" data-user="' + (index + 1) + '"> Aceitar</a> ';

                } else {
                    td = td + '<a href="#" class="act_bip btn-success btn-xs" data-user="' + (index + 1) + '"> Chamar</a> ';
                }
                td = td + '<a href="#" class="act_end btn-warning btn-xs" data-user="' + (index + 1) + '"> Finalizar</a> ';
                td = td + '</td>';
                td = td + '</tr>';
                td = td + '<tr style="display:none; background-color:#CCCCCC;">';
                td = td + '<td colspan="5"><strong>Causa Informada: </strong>' + item.cause + '</td>';
                td = td + '</tr>';
            }
        })
        td = td + '</tbody>';
        td = td + '</table>';

        $("#reception-list").append(td)
        $(".show-cause").on("click", function(event) {
            $(this).closest('tr').next('tr').toggle();
        })
        $(".act_accept").on("click", function(event) {
            event.stopPropagation();
            event.stopImmediatePropagation();
            //(... rest of your JS code)
            var id = $(this).data("user");
            if (id) {
                $.post(
                    "http://shk_medicine/recepctionAccept",
                    JSON.stringify({
                        user: id
                    })
                );
            }
        })

        $(".act_bip").on("click", function(event) {
            event.stopPropagation();
            event.stopImmediatePropagation();
            //(... rest of your JS code)
            var id = $(this).data("user");
            if (id) {
                $.post(
                    "http://shk_medicine/recepctionAcceptBip",
                    JSON.stringify({
                        user: id
                    })
                );
            }
        })

        $(".act_end").on("click", function(event) {
            event.stopPropagation();
            event.stopImmediatePropagation();
            //(... rest of your JS code)
            var id = $(this).data("user");
            if (id) {
                $.post(
                    "http://shk_medicine/recepctionExit",
                    JSON.stringify({
                        user: id
                    })
                );
            }
        })
    }
});

$(document).ready(function() {

    $(".act_menu_close").click(function(event) {
        $.post("http://shk_medicine/close", JSON.stringify({}));
    });

    $("body").on("keyup", function(key) {
        if (key.which === 27) {
            $.post("http://shk_medicine/close", JSON.stringify({}));
        }
    });
});