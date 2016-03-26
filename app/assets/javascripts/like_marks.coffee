# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
lmUsrListId = "lm-usrs-list"
lmListId = '#lm-list'
lmHoveredClassName = 'lm-hover'
e = null

switchLikeMark = (el)->
    el = $(el).parent('.like_marks')
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

showUsrsLikeMarkList = (el)-> 
    el = $(el)
    p = el.parent('.like_marks')
    v = p.find('#lm-list').clone()
    v.dialog({modal: true, closeOnEscape: true, draggable: false, title: 'Оценки', resizable: false, closeText: "Закрыть" })
    $('.ui-front').click ()-> v.dialog('destroy')

     

r = ()->
    lMarks = $(".like_marks")
    if lMarks.length > 0 
        $('span#give-mark').click ()-> switchLikeMark(this)
        $("span#mark_count").click ()-> 
            showUsrsLikeMarkList(this)

            

$(document).ready r
$(document).on "page:load", r