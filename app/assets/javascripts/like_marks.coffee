# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

switchLikeMark = (el)->
    id = $(el).attr("lm-entity-id")
    type = $(el).attr("lm-entity-type")
    $.ajax {
            type: "POST"
            url: "/switch_mark.json"
            data: ({mark:({type: type, id: id})})
            success: (v)->
                el = $(el)
                toRemoveClass = if v.img is "fi-blue" then "fi-grey" else "fi-blue"
                toAddClass = if v.img is "fi-blue" then "fi-blue" else "fi-grey"
                el.find('#mark_link').text(v.linkName)
                el.find('#mark_count').text(v.mCount)
                el.find('#mark_img').removeClass(toRemoveClass)
                el.find('#mark_img').addClass(toAddClass)
            error: (d)-> console.log d
           }

r = ()->
    lMarks = $(".like_marks")
    if lMarks.length > 0 then lMarks.click ()-> switchLikeMark(this)

$(document).ready r
$(document).on "page:load", r