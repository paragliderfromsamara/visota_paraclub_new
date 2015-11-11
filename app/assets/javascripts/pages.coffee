# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

arrows = true

blocksSumHeight = ()-> 
    $("#top").outerHeight(true) + $("#middle").outerHeight(true) + $("#bottom").outerHeight(true) + $("#ses_p").outerHeight(true) 

initScrollControl = ()->
    scrollControl()
    $(window).scroll ()->
        $('.scroll-test').text $(this).scrollTop()
        scrollControl()
        true
    $('.quickScroll #aDwn').click ()->
        p=$("#top").outerHeight(true)+$("#middle").outerHeight(true)
        $(window).scrollTop(p)
        p
    $('.quickScroll #aUp').click ()-> $(window).scrollTop(0)

scrollControl = ()->  #Управление панелькой перемотки
    t = 300
    wH = $(window).height()
    blSH = blocksSumHeight()
    sT = $(window).scrollTop()
    topH = $("div#top").outerHeight(true)
    botH = $("div#bottom").outerHeight(true)
    if (blSH-topH-botH) > wH
        $('.quickScroll').fadeIn(t)
        if sT>topH then $('.quickScroll #aUp').fadeIn(t) else $('.quickScroll #aUp').fadeOut()
        if (blSH-sT) >wH then $('.quickScroll #aDwn').fadeIn(t) else $('.quickScroll #aDwn').fadeOut()
    else $('.quickScroll').fadeOut()
    t

bottomControl = ()-> 
    sum_h = blocksSumHeight()
    window_h = $(window).height
    markOffset = $("#footerMark").offset().top
    new_middle_h = 0
    if (markOffset + $("#bottom").outerHeight(true)) < window_h
        new_middle_h = window_h - $("#top").outerHeight(true) - $("#bottom").outerHeight(true) - $("#ses_p").outerHeight(true)
        $('#middle').height(new_middle_h)
        $("#bottom").css('position', 'fixed').css('bottom', '0')
    else
        new_middle_h = markOffset - $("#top").outerHeight(true) - $("#ses_p").outerHeight(true)
        $("#bottom").css('position', 'relative').css('bottom', 'none')
        $('#middle').css('height', 'auto')#.height(new_middle_h)
    scrollControl
    new_middle_h
    
wheatherPanel = ()->
    cont = $('.right_menu #cont')
    h_wr = cont.find('#h_wr')
    $('#w_but').click ()-> 
        wh_c = $('.right_menu #wh_cont')
        h_wr.html(wh_c.html())
        h_wr.width(wh_c.width())
        h_wr.show(300)
        true
    $('.right_menu').mouseleave ()->
        h_wr.hide(300)
        h_wr.html('')

r = ()->
    initScrollControl()
    $(document).click ()-> bottomControl()
    $(document).mouseover ()-> bottomControl()
    $(window).resize ()-> bottomControl()
$(document).ready r
$(document).on "page:load", r
    