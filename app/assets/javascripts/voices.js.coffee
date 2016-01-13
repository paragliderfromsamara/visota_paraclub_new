# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

initVoiceGiver = (el)->
    vote_id = $(el).attr("vote-id")
    val_id = $(el).attr("vote-value-id")
    $.ajax {
            type: "POST"
            url: "/voices"
            data: ({voice:({vote_id: vote_id, vote_value_id: val_id})})
            success: (msg)-> $("#vtValues").html(msg)
            error: (m)-> console.log m
           }

r = ()->
    voteValues = $("[vote-id]")
    if voteValues.length > 0 then voteValues.click ()-> initVoiceGiver(this)

$(document).ready r
$(document).on "page:load", r