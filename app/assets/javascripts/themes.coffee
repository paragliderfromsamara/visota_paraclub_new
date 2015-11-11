# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

switchThemeWatcher = (el, th_id)->
    $.ajax {
            type: "POST"
            url: "/theme_notifications.json"
            data: ({theme_notifications:({type: 'single', theme_id: th_id})})
            success: (but)-> 
                $(el).html('<li><div style = "padding-right: 5px;" class = "li-float-left"><i style = "padding-right: 5px; "  class = "fi-'+but.type+' fi-blue fi-medium"></i><span>'+but.name+'</span></div></li>')
           }
    true

r = ()->
    $("#watchTheme").click ()-> 
        if $(this).attr("data-value") isnt undefined then switchThemeWatcher(this, $(this).attr("data-value"))
$(document).ready r
$(document).on "page:load", r