/**
 * Created by denganimax on 3/14/15.
 */

$(document).ready(function() {
    $("#sidebarArea").html("<div id=\"sidebar\" class=\"animation\"><div class=\"title\">MENU</div></div><div id=\"sidebar_menu\" class=\"animation\">");
    addMenuItem("Home", "index.html");
    addMenuItem("Network", "network_example.html");
    addMenuItem("Animation", "animation_example.html");
    addMenuItem("Data Model", "network_example.html");


    $("#sidebar").click(function() {
        if (parseInt($("#sidebar").css("right")) > 0) {
            closeMenu();
        } else {
            showMenu();
        }
    });

    $(".wrapper").click(function() {
        if (parseInt($("#sidebar").css("right")) > 0) {
            closeMenu();
        }
    });
});

var addMenuItem = function(title,url) {
    $("#sidebar_menu").append("<p> <a href=\""+url+"\">&bull; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "+ title +"</a> </p>");
}
var closeMenu = function() {
    $("#sidebar").css("right","0px");
    $("#sidebar_menu").css("width","0px");
    $(".wrapper").stop().animate({ "opacity": "1.0" }, 300 );
};
var showMenu = function() {
    $("#sidebar").css("right","260px");
    $("#sidebar_menu").css("width","260px");
    $(".wrapper").stop().animate({ "opacity": "0.3" }, 300 );
};