# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

arrows = true
phTopMenu = document.getElementById("topPhotoPanel")
topMenu = document.getElementById("top")
topEl = if phTopMenu isnt null then phTopMenu else topMenu 
showAtMiddleLinksList = [".nav_string a", ".pagination a", "a#showTopic", ".l_menu a", ".l_menu_b a", ".ctrl_but a", "a.w_link_u", "a.b_link_i"] #добавляем к ссылкам якорь #cs к ссылкам под данными идентификаторами


blocksSumHeight = ()-> 
    $(topEl).outerHeight(true) + $("#middle").outerHeight(true) + $("#bottom").outerHeight(true) + $("#ses_p").outerHeight(true) 

initScrollControl = ()->
    scrollControl()
    $(window).scroll ()->
        $('.scroll-test').text $(this).scrollTop()
        scrollControl()
        true
    $('.quickScroll #aDwn').click ()->
        p=$(topEl).outerHeight(true)+$("#middle").outerHeight(true)
        $(window).scrollTop(p)
        p
    $('.quickScroll #aUp').click ()-> $(window).scrollTop(0)

scrollControl = ()->  #Управление панелькой перемотки
    t = 300
    wH = $(window).height()
    blSH = blocksSumHeight()
    sT = $(window).scrollTop()
    topH = $(topEl).outerHeight(true)
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
        new_middle_h = window_h - $(topEl).outerHeight(true) - $("#bottom").outerHeight(true) - $("#ses_p").outerHeight(true)
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

initSearchForm = (sForm)->
    sForm = $(sForm)
    sBut = sForm.find('.myBut')
    sBut.click ()->
        sBut.find('a').attr('href', "/search?" + sForm.serialize())
        #alert sForm.serialize() #sBut.find('a').attr('href', "/search?" + sForm.serialize())
adaptWheatherTable = (whTable)->
    whTable = $(whTable)
    whTable.find("img").each ()->
        $(this).attr('src', "http://meteo.paraplan.net" + $(this).attr('src'))

linksUpdater = ()->
    $(".t_link").each ()-> if $(this).attr("link_to").indexOf('#') is -1 then $(this).attr("link_to", "#{$(this).attr('link_to')}#cs")
    $("#{i}").each(()-> 
        if $(this).attr('href') isnt undefined then if $(this).attr('href').indexOf('#') is -1 then $(this).attr("href", "#{$(this).attr('href')}#cs")) for i in showAtMiddleLinksList
    

r = ()->
    initScrollControl()
    linksUpdater()
    whTable = document.getElementById('forecast')
    if whTable isnt null then adaptWheatherTable(whTable)
    $(document).click ()-> bottomControl()
    $(document).mouseover ()-> bottomControl()
    $(window).resize ()-> bottomControl()
    if $("#notice").text.length > 0 then setTimeout (()-> $("#notice").fadeOut(500)), 6000
    sForm = document.getElementById("searchForm")
    if sForm isnt null then initSearchForm(sForm)
    
    
    
    
$(document).ready r
$(document).on "page:load", r
    