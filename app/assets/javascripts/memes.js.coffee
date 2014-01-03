# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
    target = $("ul#tweets li.tweet:nth-of-type(3)");
    moveme = $("ul#tweets li.tweet:nth-child(1)");
    target.after(moveme).animate({
        backgroundColor: "#bce4b4"
    }, "slow")

$(document).ready(ready)
$(document).on('page:load', ready)
