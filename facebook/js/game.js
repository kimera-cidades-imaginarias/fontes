var boxopened = "";
var imgopened = "";

var found =  0;
var pecas = 0;

function randomFromTo(from, to){
    return Math.floor(Math.random() * (to - from + 1) + from);
}

function shuffle() {
    var array_a   = new Array();
    var array_img = new Array();
    var array_alt = new Array();

    //read
    var children = $("#boxcard").children();
    var child = $("#boxcard div:first-child");

    for (i=0; i<children.length; i++) {
        array_a[i]   = $("#"+child.attr("id")+" a").attr("href");
        array_img[i] = $("#"+child.attr("id")+" img").attr("src");
        array_alt[i] = $("#"+child.attr("id")+" img").attr("alt");

        child = child.next();
    }

    //set
    var children = $("#boxcard").children();
    var child = $("#boxcard div:first-child");

    for (z=0; z<children.length; z++) {
        randIndex = randomFromTo(0, array_img.length - 1);

        $("#"+child.attr("id")+" a").attr("href", array_a[randIndex]);
        $("#"+child.attr("id")+" img").attr("src", array_img[randIndex]);
        $("#"+child.attr("id")+" img").attr("alt", array_alt[randIndex]);

        array_a.splice(randIndex, 1);
        array_img.splice(randIndex, 1);
        array_alt.splice(randIndex, 1);

        child = child.next();
    }
}

function resetGame() {
    shuffle();

    $("img").hide();
    $("img").removeClass("opacity");

    $("#msg").remove();

    boxopened = "";
    imgopened = "";

    found = 0;

    return false;
}

function definirPecas(npecas){
    pecas = npecas;
}

function openCard() {
    id = $(this).attr("id");

    if ($("#"+id+" img").is(":hidden")) {
        $("#boxcard div").unbind("click", openCard);

        $("#"+id+" img").fadeIn('fast');

        if (imgopened == "") {
            boxopened = id;
            imgopened = $("#"+id+" img").attr("alt");
           
            setTimeout(function() {
                $("#boxcard div").bind("click", openCard)
            }, 300);
        } else {
            currentopened = $("#"+id+" img").attr("alt");

            if (imgopened != currentopened) {
                // close again
                $("div.alert").show();

                setTimeout(function() {
                    $("div.alert").hide();
                    $("#"+id+" img").fadeOut('fast');
                    $("#"+boxopened+" img").fadeOut('fast');
                    boxopened = "";
                    imgopened = "";
                }, 600);
            } else {
                // found
                $("#"+id+" img").addClass("opacity");
                $("#"+boxopened+" img").addClass("opacity");
                found++;
                boxopened = "";
                imgopened = "";
            }
            
            setTimeout(function() {
                $("#boxcard div").bind("click", openCard)
            }, 400);
        }


        if ( found == pecas /*1==1*/ ) {
            msg =   "<h2>Parabéns, você provou ter boa memória, agora embarque nessa nova aventura para ajudar a salvar o Reino de Kimera!</h2>"
            msg +=  '<p class="codigo">TENHOBOAMEMORIA</p>';
            msg +=  "<hr />";
            msg +=  "<p>Insira este código no campo fornecido na tela continuar no jogo Kimera Cidades Imaginárias, para ter acesso a uma fase especial.</p>";
            
            $("#window").html(msg);
        }
    }
}