var documentWidth = document.documentElement.clientWidth;
var documentHeight = document.documentElement.clientHeight;
var hiiri = document.getElementById("hiiri");
var hiirix = documentWidth / 2;
var hiiriy = documentHeight / 2;

function PaivitaHiiri() {
    hiiri.style.left = hiirix;
    hiiri.style.top = hiiriy;
}

function Click(x, y) {
    var element = $(document.elementFromPoint(x, y));
    element.focus().click();
}

$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            hiiri.style.display = event.data.enable ? "block" : "none";
            document.body.style.display = event.data.enable ? "block" : "none";
        } else if (event.data.type == "click") {
            Click(hiirix - 1, hiiriy - 1);
        }
    });

    $(document).mousemove(function(event) {
        hiirix = event.pageX;
        hiiriy = event.pageY;
        PaivitaHiiri();
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { 
            $.post('http://TapsuTunnus/tapsu', JSON.stringify({}));
        }
    };
	
    $("#Luodaantunnus").submit(function(e) {
        e.preventDefault(); 
        $.post('http://TapsuTunnus/Luodaantunnus', JSON.stringify({
            tunnus: $("#tunnus").val()
        }));
    });
});