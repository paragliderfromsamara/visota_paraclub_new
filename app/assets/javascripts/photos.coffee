# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
photoPathFieldId = "phContent"
fVisible=-1
lVisible=-1
maxVBlocks=7
offset = (maxVBlocks-1) / 2
sumPagWidth = 0
blC = 0
height = 0
width = 0
photo = null

goToLink = (link)->
    if link isnt '' && link isnt undefined then document.location.href = link

updScrIndexes = (f)->
    if f is 'left'
        if (lVisible-(maxVBlocks-1)) >= 0
            fVisible = lVisible-(maxVBlocks-1)
        else
           fVisible = 0
           lVisible = maxVBlocks-1
    else if f is 'right'
        if fVisible+(maxVBlocks-1) < blC
            lVisible = fVisible+(maxVBlocks-1)
        else
            fVisible = blC - maxVBlocks-1
            lVisible = blC-1
    if fVisible is 0 then $(".ph-arr-left").css("visibility", "hidden") else $(".ph-arr-left").css("visibility", "visible")
    if lVisible is (blC-1) then $(".ph-arr-right").css("visibility", "hidden") else $(".ph-arr-right").css("visibility", "visible")

getMessageFormTopOffset = (f)-> #вычисляет есть ли форма на странице, если есть в зависимости от отступа блокирует событие нажатия стрелок
    e = document.getElementsByClassName("message_form")
    v = true
    if e.size isnt 0
       e = $(e[0])
       o = e.offset().top
       s = $(document).scrollTop()
       if s > (o / 4) then v = false 
    v


updPhotoPaginate = (f)->
    j=0
    $(".ph-paginate").each (i)->
        if f is 'init'
            if not $(this).hasClass('ph-h')
                fVisible=i
                updScrIndexes('right')
                return false
        else
            if (j<fVisible) or (lVisible < j) then $(this).addClass('ph-h') else $(this).removeClass('ph-h')
        j++

initPhotoPage = ()->
    blC = $(".ph-paginate").length
    if blC > maxVBlocks
        updPhotoPaginate('init')
        $(".ph-arrows").removeClass('ph-h')
    else
        sumPagWidth = blC*($(".ph-paginate").outerWidth(true)+1+parseInt($(".ph-paginate").css("border-width"))*2)
        $("#paginationLine").width(sumPagWidth)
    $(document).keyup (event)->
        if getMessageFormTopOffset() is true
            if event.keyCode is 37 then goToLink($(".ph-big-prev").attr('link_to'))
            else if event.keyCode is 39 then goToLink($(".ph-big-next").attr('link_to'))
    $(window).resize ()-> setPhotoSizeByScreen()

getHeightAndWidth = ()->
    if height isnt 0 and width isnt 0
        wHeight = $(window).height()
        wWidth = $(window).width()
        sDiv= height / width #Вычисляем пропорцию сторон
        pagHeight = $("#photoPagination").outerHeight(true) + $("#topPhotoPanel").outerHeight(true)
        newHeight = if wWidth > width then wHeight-pagHeight else (960) * sDiv
    else newHeight = 0 
    newHeight
        
setPhotoSizeByScreen = ()->
    newHeight = getHeightAndWidth()
    if newHeight isnt 0    
        iconsTop = 200
        if height > newHeight 
            $("#bPhoto").height(newHeight)
            iconsTop = newHeight / 2 - $("div#iIcon").height() / 2
            photo.parent('div.central_field').height(newHeight)
        else 
            iconsTop = height / 2 - $("div#iIcon").height() / 2
            photo.parent('div.central_field').height(height)
        $("div#iIcon").css('top', iconsTop + 'px')
    
    
r = ()->
    phPathEl = document.getElementById(photoPathFieldId)
    if phPathEl isnt null
        photo = $("img[photo-height]")
        height = parseInt photo.attr('photo-height')
        width = parseInt photo.attr('photo-width')
        setPhotoSizeByScreen()
        initPhotoPage()
        $(".ph-big-links, .ph-paginate").click ()->
            goToLink($(this).attr('link_to'))
        $(".ph-arr-right").click ()->
            if fVisible+(maxVBlocks-1) isnt blC-1
                fVisible++
                updScrIndexes('right')
                updPhotoPaginate('upd')
    	$(".ph-arr-left").click ()->
            #console.log 'ass'
            if lVisible-(maxVBlocks-1) isnt 0
                lVisible--
                updScrIndexes('left')
                updPhotoPaginate('upd')
       
$(document).ready r
$(document).on "page:load", r
