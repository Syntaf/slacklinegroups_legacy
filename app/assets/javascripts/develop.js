var screenWidth = $(window).width();
var width = 500;

$('document').ready(function() {

    if (screenWidth < 1300) {
        width = screenWidth - 40;
        $('#nojsSLG').css('width', width);
    }

    $('#slgmap').slacklinegroups({
        width: width,
        height: 500
    });
});