# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

maxContainerHeight = 700
minContainerHeight = 400
newMessageCheckTime = 5000
msgDownLoadingStep = 25
onServerMsgCount = 0
updateMsgsFieldInterval = null
minScrollForScrollDown = 100
lstReadMsg = {  
                msg: null
                c: 0    
             }
frstReadMsg = null
actType = 'start' #'start'-инициализация, 'add'-при добавлении нового сообщения, 'check'-проверка новых входящих, 'get'-догрузка истории сообщений
c = null

cnvRows = ()->
    c.find(".cnv-msg-rows")

lastMessageId = ()->
    msgs = cnvRows()
    if msgs.length>0 then msgs[msgs.length-1].id.replace('msg', "") else 0    
    
firstMessageId = ()->
    msgs = cnvRows()
    if msgs.length>0 then msgs[0].id.replace('msg', "") else 0
    
#curScroll = (s)->
#    if s is undefined 
#        c.scrollTop() + c.height() 
#    else 
#        if s > c.height()
#            
#        c.scrollTop(c.height())
    
sumRowsHeight = ()->
    h = 0
    cnvRows().each ()-> 
        h += $(this).height()
    h

cleanUpdMsgsInterval = ()->
    if updateMsgsFieldInterval isnt null 
        updateMsgsFieldInterval.stopUpdate()
        updateMsgsFieldInterval = null
    #if c isnt null then c.unbind 'scroll'

setContainerHeight = ()->
    h = sumRowsHeight()
    if h > maxContainerHeight 
        c.height(maxContainerHeight)
    else if h < minContainerHeight
        c.height(minContainerHeight)
    else
        c.height(h)

fillLastMessageId = ()->
    $("form.add_conversation_message").find('#conversation_message_last_visible_msg_id').val(lastMessageId())

initDelButListner = ()->
    $('a.cnv-rmv-msg').off()
    $('a.cnv-rmv-msg').on "ajax:success", (e, data, status, xhr) ->
       msgs = cnvRows()
       prnt = $(this).parents('tr')
       prnt_date = prnt.find(".cnv-msg-time").html()
       prnt_user = prnt.find(".cnv-ava-col").html()
       if prnt_user.length > 0 && msgs.length > 1
           msgs.each (i)->
               if this.id is prnt.attr('id')
                   if (i+1) < msgs.length
                       nextRow = $(msgs[i+1])
                       if $.trim(nextRow.find(".cnv-ava-col").html()).length is 0
                           nextRow.find(".cnv-msg-cont").prepend("<br />").prepend(prnt.find("#cnv-usr-link"))
                           nextRow.find(".cnv-ava-col").html(prnt_user)
                           nextRow.find(".cnv-msg-time").html(prnt_date)
                           getCnvMsgs('before', 1)
       prnt.remove()
       #console.log "true #{i}" 
         

#общая функция вставки сообщений в лист   

setScrollCursor = ()->
    console.log actType
    h = sumRowsHeight()
    if actType is 'start'
        lstReadMsg = {   
                       msg: cnvRows()[cnvRows().length-1]
                       c: cnvRows().length 
                     }
        c.scrollTop(sumRowsHeight())
    else if actType is 'check'
        if c.scrollTop() > $(lstReadMsg.msg).position().top + minScrollForScrollDown 
            c.scrollTop(sumRowsHeight()) 
        $("#go-dwn-cnv-msgs-but").text("в конец +#{cnvRows().length - lstReadMsg.c}")
    else if actType is 'add'
        c.scrollTop(h)
        lstReadMsg = {   
                       msg: cnvRows()[cnvRows().length-1]
                       c: cnvRows().length 
                     }
    else if actType is 'get'
        lstReadMsg = {   
                       msg: lstReadMsg.msg
                       c: cnvRows().length 
                     }
        c.scrollTop($(frstReadMsg).position().top - 30)
    return true
 
addMessageToList = (msgs, place)-> 
    if actType is 'get' then frstReadMsg = cnvRows()[0]
    if place is 'before' then $("#cnv-msgs-list").prepend(msgs) else $("#cnv-msgs-list").append(msgs)
    setContainerHeight()
    initDelButListner()
    fillLastMessageId()
    setScrollCursor()
        
        
    


#Обновление контейнера сообщений
updCnvFieldFunc = (data)->
    onServerMsgCount = data.val
    if data.html isnt "" 
        addMessageToList(data.html, 'after') 
        initDelButListner()
        setContainerHeight()
    return "type=after&val=#{lastMessageId()}&offset=500"
    
scrollDown = ()->
    if lstReadMsg.msg isnt undefined
        if cnvRows()[cnvRows().length-1] is lstReadMsg.msg then c.scrollTop(sumRowsHeight()) else c.scrollTop(sumRowsHeight(lstReadMsg.msg.id) - c.height())
    #console.log "pos: #{lstReadMsg.msg.position().top}; offset: #{lstReadMsg.msg.offset().top}"
    #else
    #    c.scrollTop(99999)
    
scrollMsgContainer = ()->
    s = c.scrollTop()
    srh = sumRowsHeight() - c.height()
    if s < 40 && onServerMsgCount > cnvRows().length
        #getCnvMsgs('before', msgDownLoadingStep)
        v = if onServerMsgCount >= msgDownLoadingStep then msgDownLoadingStep else msgDownLoadingStep - onServerMsgCount
        $("#get-cnv-msgs-but").text("загрузить ещё #{v}")
        $("#get-cnv-msgs-but").show()   
    else
        $("#get-cnv-msgs-but").hide() 
        
    if s > srh - minScrollForScrollDown 
        $("#go-dwn-cnv-msgs-but").hide()
        lstReadMsg = { 
                       msg: cnvRows()[cnvRows().length-1]
                       c: cnvRows().length   
                      }
        $("#go-dwn-cnv-msgs-but").unbind('click').bind('click', ()-> scrollDown())
    else
        t = if lstReadMsg.c > cnvRows().length then " +#{lstReadMsg.c - cnvRows().length}" else ''
        $("#go-dwn-cnv-msgs-but").text("в конец#{t}")
        $("#go-dwn-cnv-msgs-but").show()
        
    #console.log "#{srh} #{s} " 

        
        
startUpd = ()->
    cleanUpdMsgsInterval()
    actType = 'check'
    updateMsgsFieldInterval = new checkupd("/conversations/#{c.attr('cnv_id')}", "type=after&val=#{lastMessageId()}&offset=500", updCnvFieldFunc, newMessageCheckTime)
    updateMsgsFieldInterval.startUpdate()

    
initMessagesContainer = ()->
    #c.prepend().append("<a><div id = 'go-dwn-cnv-msgs-but'></div></a>")
    actType = 'start'
    $("#get-cnv-msgs-but").bind "click", ()->
        actType = 'get' 
        getCnvMsgs('before', msgDownLoadingStep)
    getCnvMsgs('after', msgDownLoadingStep)
    scrollMsgContainer(c[0])
    c.bind 'scroll', ()-> scrollMsgContainer(this)
    
getCnvMsgs = (type, offset)->
    cleanUpdMsgsInterval()
    ofst = if offset is undefined then msgDownLoadingStep else offset
    msgs = cnvRows()   
    if msgs.length > 0
        val = if type is 'before' then firstMessageId() else lastMessageId()
        val = "&val=#{val}"
    else
        val = ''  
    $.ajax({
            type: 'GET'
            url: "/conversations/#{c.attr('cnv_id')}"
            data: "type=#{type}&offset=#{ofst}&val=#{val}"
            dataType: 'json'
            success: (data)->
                onServerMsgCount = data.val
                if data.html isnt ""
                    addMessageToList(data.html, type)
                startUpd()    
           })

r = ()->
    cnvMsgContainer = document.getElementById("cnv-msgs-container")
    if cnvMsgContainer isnt null 
        c = $(cnvMsgContainer)
        initMessagesContainer()
        
        $("form.add_conversation_message").on "ajax:beforeSend", () ->
           cleanUpdMsgsInterval()
        $("form.add_conversation_message").on "ajax:success", (e, data, status, xhr) ->
           actType = 'add'
           addMessageToList(data.html, 'after')
           startUpd()      
           $("form.add_conversation_message").find('textarea').val('') 
     else
         cleanUpdMsgsInterval()   
        

       
    
    
$(document).ready r
$(document).on 'page:load', r