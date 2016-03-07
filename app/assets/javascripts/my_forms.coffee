# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
getThemeListLink = "/get_themes_list?format=json"
getAlbumListLink = "/get_albums_list?format=json"
themeFormClass = "theme_form"
messageFormClass = "message_form"
videoFormClass = "video_form"
albumFormClass = "photo_album_form"
voteFormId = "vote_form"
eventFormClass = 'event_form'
articleFormClass = "article_form"
menuIconSizeClass = "fi-large"

waitLineHtml = (id)-> 
    "
    <div class = 'tb-pad-m'>
    <p>Идет загрузка фотографий...</p>
    <div style = 'display:none;' id = '#{id}' class = 'wl'>
        <div class = 'wl-item'>
        </div>
	    <div class = 'wl-item'>
		</div>
		<div class = 'wl-item'>
		</div>
		<div class = 'wl-item'>
		</div>
		<div class = 'wl-item'>
		</div>
	</div></div>"

initArticleAsFlightAccidents = (f)->
    f.aButList = [2]
    f.imagesMaxLength = 30
    f.imagesMaxLengthErr = 'Максимально допустимое количество фотографий альбома превышено на '
    f.tEditor = new textEditor(f)
    f.initPanel()
    f.formChecking = ()->
        cFlag = f.contentLengthCheck()
        iFlag = f.imagesLengthCheck()
        f.switchSubmitBut(cFlag & iFlag)
    f.photosUploader()
    f.getPhsToForm()
    f.formChecking()
    f.contentField.keyup ()-> f.formChecking()
    
initArticleAsDocuments = (f)->
    f.aButList = [3]
    f.nameField = f.formElement.find('#article_name')
    f.nameFieldMaxLength = 100
    f.nameFieldMinLength = 3
    f.shortNameErr = 'Название не должно быть пустым'
    f.longNameErr = 'Максимально допустимое количество знаков превышено на '
    f.attachmentsMaxLength = 20
    f.attachmentsMinLength = 1
    f.attachmentsMinLengthErr = "Должно быть добавлено как минимум 1-но вложение"
    f.attachmentsMaxLengthErr = "Превышено максимально допустимое количество вложений"
    f.hideAttachmentField = false
    f.contentFieldMinLength = 0
    f.tEditor = new textEditor(f)
    f.initPanel()
    f.formChecking = ()->
        cFlag = f.contentLengthCheck()
        nFlag = f.nameLengthCheck() 
        afFlag = f.checkAttachmentLength()
        f.switchSubmitBut(cFlag & nFlag & afFlag)
    f.attachmentFilesUploader()
    f.getAttachmentsToForm()
    f.formChecking()
    f.contentField.keyup ()-> f.formChecking()
    f.nameField.keyup ()-> f.formChecking()
    
initArticleAsDefault = (f)->
    f.aButList = [2,3,1]
    f.nameField = f.formElement.find('#article_name')
    f.nameFieldMaxLength = 100
    f.nameFieldMinLength = 3
    f.shortNameErr = 'Название не должно быть пустым'
    f.longNameErr = 'Максимально допустимое количество знаков превышено на '
    f.imagesMaxLength = 30
    f.imagesMaxLengthErr = 'Максимально допустимое количество фотографий альбома превышено на '
    f.tEditor = new textEditor(f)
    f.initPanel()
    f.formChecking = ()->
        cFlag = f.contentLengthCheck()
        nFlag = f.nameLengthCheck() 
        iFlag = f.imagesLengthCheck()
        afFlag = f.checkAttachmentLength()
        f.switchSubmitBut(cFlag & nFlag & iFlag & afFlag)
    f.getBindingEntities()
    f.photosUploader()
    f.getPhsToForm()
    f.attachmentFilesUploader()
    f.getAttachmentsToForm()
    f.formChecking()
    f.contentField.keyup ()-> f.formChecking()
    f.nameField.keyup ()-> f.formChecking()

initArticleForm = (frm)->
    aId = frm.id.replace("#{articleFormClass}_", '')
    aType = $(frm).attr("article_type")
    f = new myForm('article', aId, "."+frm.className)
    f.contentField = f.formElement.find('#article_content')
    f.contentFieldMaxLength = 150000
    f.contentFieldMinLength = 100
    f.shortContentErr = 'Минимально допустимое количество знаков темы ' + f.contentFieldMinLength
    f.longContentErr = 'Максимально допустимое количество знаков превышено на '
    f.submitButt = f.formElement.find("#submit_#{frm.id}_button")
    switch aType
      when "flight_accidents" then initArticleAsFlightAccidents(f)
      when "documents" then initArticleAsDocuments(f)
      else initArticleAsDefault(f)
          
initEventForm = (frm)->
    eId = frm.id.replace("#{eventFormClass}_", '')
    f = new myForm('event', eId, "."+frm.className)
    f.contentField = f.formElement.find('#event_content')
    f.nameField = f.formElement.find('#event_title')
    f.aButList = [2]
    f.contentFieldMaxLength = 150000
    f.contentFieldMinLength = 10
    f.nameFieldMaxLength = 150
    f.nameFieldMinLength = 3
    f.shortContentErr = 'Новость не должна быть короче ' + f.contentFieldMinLength + ' символов'
    f.longContentErr = 'Длина новости превышена на '
    f.shortNameErr = 'Заголовок новости не должен быть короче ' + f.contentFieldMinLength + ' символов'
    f.longNameErr = 'Длина заголовка новости превышена на '
    f.submitButt = f.formElement.find("#submit_#{frm.id}_button")
    f.tEditor = new textEditor(f)
    f.initPanel()
    f.formChecking = ()->
        cFlag = f.contentLengthCheck()
        nFlag = f.nameLengthCheck() 
        iFlag = f.imagesLengthCheck()
        afFlag = f.checkAttachmentLength()
        f.switchSubmitBut(cFlag & nFlag & iFlag & afFlag)
    f.photosUploader()
    f.getPhsToForm()
    f.formChecking()
    f.contentField.keyup ()-> f.formChecking()
    f.nameField.keyup ()-> f.formChecking()
          
initVoteForm = (frm)->
    f = new myForm('vote', null, "#"+frm.id)
    f.contentField = f.formElement.find('#vote_content')
    f.submitButt = f.formElement.find("#submit_#{voteFormId}_button")
    f.aButList = [0]
    f.contentFieldMaxLength = 500
    f.contentFieldMinLength = 10
    f.shortContentErr = 'Вопрос не должен быть короче ' + f.contentFieldMinLength + ' символов'
    f.longContentErr = 'Длина вопроса превышена на '
    f.updVoteValuesFields()
    f.tEditor = new textEditor(f)
    f.initPanel()
    f.formChecking = ()->
        cFlag = f.contentLengthCheck()
        qFlag = f.voteValuesCheck()
        f.switchSubmitBut(cFlag && qFlag)
    f.contentField.keyup ()-> f.formChecking()
    $('#addVoteValue').click ()->
          if f.voteValuesCheck()
              e = $("#vote_value_item").clone()
              e.find(':text').val('')
              $("#vote_values_table").append(e)
              f.updVoteValuesFields()
          else f.formChecking()
    f.formChecking()


initAlbumForm = (frm)->
    aId = frm.id.replace("#{albumFormClass}_", '')
    f = new myForm('photo_album', aId, "." + frm.className)
    f.submitButt = f.formElement.find("#submit_#{albumFormClass}_#{aId}_button")
    f.nameField = f.formElement.find('#photo_album_name')
    f.contentField = f.formElement.find('#photo_album_description')
    f.contentFieldMaxLength = 1000
    f.nameFieldMaxLength = 100
    f.nameFieldMinLength = 3
    f.shortNameErr = 'Название не должно быть короче ' + f.nameFieldMinLength + ' символов'
    f.longNameErr = 'Длина названия превышена на '
    f.longContentErr = 'Длина описания превышена на '
    f.imagesMaxLength = 120
    f.imagesMinLength = 3
    f.imagesMaxLengthErr = 'Максимально допустимое количество фотографий альбома превышено на '
    f.imagesMinLengthErr = 'В альбоме должно быть не менее '+f.imagesMinLength+' фотографий'
    f.matchNameErr = 'Фотоальбом с таким названием уже существует...'
    f.initPanel()
    f.formChecking = ()->
        iFlag = f.imagesLengthCheck()
        nFlag = f.nameLengthCheck() & f.nameMatchesCheck()
        cFlag = f.contentLengthCheck()
        f.switchSubmitBut(iFlag & cFlag & nFlag)
    f.formChecking()
    f.photosUploader()
    f.getPhsToForm()
    f.nameField.keyup ()-> 
        f.formChecking()
        f.getLikebleNames()
    f.contentField.keyup ()-> f.formChecking()

        
initVideoForm = (frm)->
    wb = new waitbar("wait_video_check")
    f = new myForm('video', null, "#" + frm.id)
    nFlag = false
    dFlag = false
    f.contentField = f.formElement.find('#video_description')
    f.nameField = f.formElement.find('#video_name')
    f.submitButt = f.formElement.find("#"+frm.id+"_button")
    f.contentFieldMaxLength = 400
    f.contentFieldMinLength = 0
    f.nameFieldMaxLength = 70
    f.nameFieldMinLength = 0
    f.longContentErr = 'Максимально допустимое количество знаков превышено на '
    f.longNameErr = 'Максимально допустимое количество знаков превышено на '
    nFlag = f.nameLengthCheck()
    cFlag = f.contentLengthCheck()
    f.nameField.keyup ()->
        nFlag = f.nameLengthCheck()
        f.switchSubmitBut(f.videoLinkFlag & nFlag & cFlag)
    f.contentField.keyup ()->
        cFlag = f.contentLengthCheck()
        f.switchSubmitBut(f.videoLinkFlag & nFlag & cFlag)
    f.videoLinkFlag = if $("#video_preview").html() is "" then false else true
    f.switchSubmitBut(f.videoLinkFlag & nFlag & cFlag)
    $("#video_link").change ()->
        e=this
        wb.startInterval()
        $.ajax {
                url: "/videos/new.json"
                dataType: "json"
                type: "GET"
                data: ({link: $(e).val()})
                error: (XMLHttpRequest, textStatus, errorThrown)->
                    console.log(errorThrown)
                    console.log(textStatus)
                    wb.stopInterval()
                    f.videoLinkFlag = false
                    f.switchSubmitBut(f.videoLinkFlag & nFlag & cFlag)
                success: (data)->
                    if data.link_html isnt "" and data.link_html isnt $(e).val()
                        $("#video_preview").html(data.link_html)
                        $("#tError").empty()
                        f.videoLinkFlag = true
                    else
                        $("#tError").addClass('err').html("Ccылка должна быть указана в формате \"youtube\", \"vk\", \"vimeo\"...")
                        $("#video_preview").empty()
                        f.videoLinkFlag = false
                        #console.log(data.link_html)
                    wb.stopInterval()
                    f.switchSubmitBut(f.videoLinkFlag & nFlag & cFlag)
               }

initMessageForm = (frm)->
    mId = $(frm).attr('id').replace("#{messageFormClass}_", "")
    msgType = $(frm).attr('form_type')
    f = new myForm(msgType,  mId, "."+ messageFormClass)
    f.nameField = f.formElement.find("#message_name")
    f.contentField = f.formElement.find("#message_content")
    f.submitButt = f.formElement.find("#submit_#{messageFormClass}_#{mId}_button")
    minContentLength = 1
    if msgType is 'comment'
        f.aButList = [0]
        f.contentFieldMaxLength = 10000
        f.contentFieldMinLength = minContentLength
        f.shortContentErr = 'Комментарий не должен быть пустым'
    else
        f.aButList = [0, 2, 3]
        f.contentFieldMaxLength = 150000
        f.shortContentErr = 'Сообщение не должно быть пустым'
        f.imagesMaxLength = 40
        f.imagesMaxLengthErr = 'Максимально допустимое количество фотографий для сообщения превышено на '
        f.attachmentsMaxLengthErr = "Превышено максимально допустимое количество вложений"
        f.attachmentsMaxLength = 20
    f.contentFieldMinLength = minContentLength  
    f.curContentValue = f.contentField.val()
    f.tEditor = new textEditor(f)
    f.initPanel()
    f.formChecking = ()->
        iFlag = f.imagesLengthCheck()
        afFlag = f.checkAttachmentLength()
        f.contentFieldMinLength = if f.imagesLength>0 || f.attachmentFilesLength>0 then 0 else minContentLength
        cFlag = f.contentLengthCheck()
        f.switchSubmitBut((iFlag && f.imagesLength>0) || cFlag || (afFlag && f.attachmentFilesLength>0))
        #console.log f.imagesLength, f.attachmentFilesLength
    f.formChecking()
    if msgType isnt 'comment'
        f.photosUploader()
        f.getPhsToForm()
        f.attachmentFilesUploader()
        f.getAttachmentsToForm()
    f.contentField.keyup ()-> f.formChecking()
    f.formElement.mouseover ()-> f.formChecking()
    $('a#answer_but, #newMsgBut').click ()->
        fTop = $("[name=new_message]").offset().top
        $(document).scrollTop(fTop)
        f.contentField.setCurretPosition(f.contentField.val().length)
        if this.id is 'answer_but'
            msgToId = $(this).attr('alt')
            if f.formElement.find('#message_message_id').val() is undefined
                f.formElement.append('<input id = "message_message_id" type="hidden" name = "message[message_id]" value = "'+msgToId+'"/>')
            else
                f.formElement.find('#message_message_id').val(msgToId)
            f.formElement.find('#answr_to_str').html('<a id = "ans_link" class = "b_link_i" href = "#m_'+msgToId+'">ответ пользователю '+$('#m_'+msgToId).find('#u_name').text()+'</a> <a title = "Не отвечать" class = "b_link pointer" id = "noAnswer"><i class = "fi-x fi-small"></i></a>').show()
            f.formElement.find('#ans_link').click ()->
                $($(this).attr('href')).find('.cWrapper').animate({opacity: 1.0}, 500 ).animate({opacity: 0.0}, 500) 
            f.formElement.find('#noAnswer').click ()->
                f.formElement.find('#answr_to_str').empty()
                f.formElement.find('#message_message_id').remove()
        

#tId = $(frm).attr('id').replace(themeFormId, "")


initThemeForm = (frm)->
    tId = $(frm).attr('id').replace("#{themeFormClass}_", "")
    f = new myForm('theme',  tId, "."+$(frm).attr('class'))
    f.nameField = f.formElement.find("#theme_name")
    f.contentField = f.formElement.find("#theme_content")
    f.submitButt = f.formElement.find("#submit_"+ $(frm).attr('class') + "_" + tId + "_button")
    f.aButList = [0, 2, 3]
    f.imagesMaxLength = 120
    f.contentFieldMaxLength = 150000
    f.contentFieldMinLength = 3
    f.parentElID = '#articleForm'
    f.shortContentErr = 'Минимально допустимое количество знаков темы ' + f.contentFieldMinLength
    f.longContentErr = 'Максимально допустимое количество знаков превышено на '
    f.nameFieldMaxLength = 100
    f.nameFieldMinLength = 1
    f.shortNameErr = 'Название не должно быть пустым'
    f.longNameErr = 'Максимально допустимое количество знаков превышено на '
    f.matchNameErr = 'Тема с таким названием уже существует...'
    f.attachmentsMaxLengthErr = "Превышено максимально допустимое количество вложений"
    f.attachmentsMaxLength = 20
    f.tEditor = new textEditor(f)
    f.initPanel()
    #f.formElement.mouseover ()->
    #formChecking()
    f.formChecking = ()->
        cFlag = f.contentLengthCheck()
        afFlag = f.checkAttachmentLength()
        nFlag = f.nameLengthCheck() && f.nameMatchesCheck()
        f.switchSubmitBut(nFlag & cFlag & afFlag)
    f.formChecking()
    f.photosUploader()
    f.getPhsToForm()
    f.attachmentFilesUploader()
    f.getAttachmentsToForm()
    f.contentField.keyup ()->
        f.formChecking()
    f.nameField.keyup ()->
        f.getLikebleNames()
        f.formChecking()
    f.formElement.mouseover ()-> f.formChecking()

class myForm
    constructor: (@type, 
                  @entityID, 
                  @formName, 
                  @formElement = $(@formName), 
                  @submitButt = null, 
                  @tEditor = null, 
                  @parentElID = 'none', 
                  @classPrefix = 'fi-', 
                  @nameList = ['paw', 'link', 'photo', 'paperclip'], 
                  @descList = ['Эмоции', 'Вложить альбомы и видео', 'Добавить фотографии', 'Прикрепить файл'], 
                  @aButList = [],
                  @nameField = null,
                  @nameFieldMaxLength = 0,
                  @nameFieldMinLength = 0,
                  @shortNameErr = '',
                  @longNameErr = '',
                  @matchNameErr = '',
                  @curNameValue = '',
                  @contentField = null,
                  @curBbFont = null,
                  @curBbAlign = null,
                  @videoLinkFlag = null,
                  @contentFieldMaxLength = 0,
                  @contentFieldMinLength = 0,
                  @shortContentErr = '',
                  @longContentErr = '',
                  @curContentValue = '',
                  @imagesField = '',
                  @imagesLength = 0,
                  @imagesMaxLength = 20,
                  @imagesMinLength = 0,
                  @imagesMaxLengthErr = '',
                  @imagesMinLengthErr = '',
                  @attachmentsMaxLengthErr = 'Количество вложение превышено на ',
                  @attachmentsMaxLength = 20,
                  @attachmentsMinLength = 0,
                  @attachmentsMinLengthErr = "Минимальное количество вложений " ,
                  @attachmentFilesLength = 0,
                  @hideAttachmentField = true,
                  @formChecking = null
                  )->
        
    #name part------------------------------------------------------------

    nameLengthCheck: ()->
        f = true
        s = this.formElement.find('p#nLength')
        err = ''
        if this.nameField.val() isnt undefined
            if this.nameFieldMaxLength isnt 0 && this.nameField.val().length > this.nameFieldMaxLength
                d = this.nameField.val().length - this.nameFieldMaxLength
                err = this.longNameErr + d
                f = false
            if this.nameFieldMinLength isnt 0 && this.nameField.val().length < this.nameFieldMinLength
                err = this.shortNameErr
                f = false
            s.find('#txtL').text "#{this.nameField.val().length } из #{this.nameFieldMaxLength}"
            s.find('#txtErr').text err
            switchErr(s, f)
        f
    nameMatchesCheck: ()->
        f=true
        err = ''
        _this = this
        ent_id = 'ent_'+this.entityID
        s = this.formElement.find('p#nLength')
        this.formElement.find('div.likebleName').each (i)->
            if this.id isnt ent_id
               if _this.curNameValue.toLowerCase() is ($(this).find('a').text()).toLowerCase()
                   $(this).css('background-color', '#f1c8c8')
                   f=false
                   err = _this.matchNameErr
               else $(this).css('background-color', 'none')
            else $(this).hide()
        s.find('#txtMatchesErr').text(err)
        #console.log this.formElement.attr('class')
        f
    getLikebleNames: ()->
        if this.curNameValue isnt $.trim(this.nameField.val())
            if this.type is 'theme'
                o = new themeObj()
                o.topic = this.formElement.find('#theme_topic_id').val()
                o.name = this.nameField.val()
                make_themes_list(o, this.formChecking)
            else if this.type is 'article'
                #to_do
            else if this.type is 'photo_album'
                a = new albumObj()
                a.name = this.nameField.val()
                a.category = this.formElement.find('#photo_album_category_id').val()
                a.id = this.entityID
                a.getAlbumNames(this.formChecking)
            this.curNameValue = this.nameField.val()
            true
    #name part end--------------------------------------------------------
    #content part---------------------------------------------------------

    getAlignArray: ()->
        str = this.contentField.val()
        names = this.tEditor.tAlignMenus
        arr = new Array()
        if str isnt undefined
            for n in names[1..names.length]
                c=0
                f=false
                for l in [0..(this.contentFieldMaxLength / (n.length+2))]
                    b = new bbCodeObj(n, 'none')
                    b.sTagStart = str.indexOf(b.tagName().start, c)
                    if (b.sTagStart isnt -1) or (b.sTagStart is c and c > 0 ) or (b.sTagStart is str.length)
                        break
                    else
                        b.eTagStart = str.indexOf(b.tagName().end, b.sTagStart+b.eTagStart.length)
                        if (b.sTagStart isnt -1) or (b.sTagStart is c and c > 0 ) or (b.sTagStart is str.length)
                            break
                        else
                            arr[arr.length] = b
                            c=b.eTagStart+b.tagName().end.length

    alterText: ()->
        if this.tEditor isnt null
            if this.tEditor.tArea isnt undefined then this.tEditor.escapeBbText() else this.contentField.val()
        else
            this.contentField.val()
    contentLengthCheck: ()->
        err = ''
        f = true
        s = this.formElement.find('p#cLength')
        str = this.alterText()
        if str isnt undefined and this.contentField.val() isnt undefined
            maxTxtL = this.contentFieldMaxLength - (this.contentField.val().length - str.length)
            if maxTxtL < 0 then maxTxtL = 0
            if this.contentFieldMaxLength isnt 0 and str.length > maxTxtL and maxTxtL > 0
                d = str.length - maxTxtL
                err = this.longContentErr + d
                f = false
            if this.contentFieldMinLength isnt 0 and str.length < this.contentFieldMinLength
                err = this.shortContentErr
                f = false
            s.find('#txtL').text("#{str.length} из #{maxTxtL}")
            s.find('#txtErr').text(err)
            switchErr(s, f)
        f
    #content part  end------------------------------------------------------
    #images part ------------------------------------------------------

    imagesLengthCheck: ()->
        l=0
        eFlag = true
        err = ''
        s = this.formElement.find('p#iLength')
        l = this.formElement.find('.ph-list-items').length - this.formElement.find('.del-photo').length
        if l is 0 
            #lFlag = false
            if this.type isnt 'photo_album' then s.hide() 
        else 
            #lFlag=true
            if this.type isnt 'photo_album' then s.show()
        this.imagesLength = l
        if this.imagesMaxLength isnt 0
            if l>this.imagesMaxLength
                d = l-this.imagesMaxLength
                err = this.imagesMaxLengthErr + d
                eFlag=false
        if this.imagesMinLength isnt 0
            if l<this.imagesMinLength
                err = this.imagesMinLengthErr
                eFlag=false
        switchErr(s, eFlag)
        s.find('#txtL').text('Фотографий добавлено: ' + l + ';')
        s.find('#txtErr').text(err)
        eFlag
        
    photosUploader: ()->
        _this = this
        ent_id = this.entityID
        entity = this.type
        link = '/'+entity+'s/' + ent_id + '/upload_photos?format=json'
        this.formElement.find('#ph_to_frm').empty()
        this.formElement.find('#ph_to_frm').dropzone {
                                        url: link
                                        init: ()-> 
                                            if _this.formChecking isnt null
                                                this.on "addedfile", (file)-> 
                                                    _this.formChecking()
                                        acceptedFiles: "image/*"
                                        paramName: entity+"[uploaded_photos]"
                                        inputId: entity+"_uploaded_photos"
                                        #forceFallback:true
                                        sending: (file, xhr, formData)->
                                            formData.append("authenticity_token", _this.formElement.find("input[name='authenticity_token']").val())
                                        success: (file, response)->
                                            _this.getPhsToForm()
                                            $(file.previewElement).remove()
                                            #ph_id = response.photoID
                                            #getUploadedPh(ph_id, el, file.previewElement, entity)
                                        fallback: ()->
                                            v='<div class = "dz-message"><p class = "istring norm">'+this.options.dictFallbackMessage+'</p></div>'
                                            v+= '<p class = "istring norm">'+this.options.dictFallbackText+'</p><br />'
                                            _this.formElement.find('#ph_to_frm').append(v)
                                            _this.formElement.find('#ph_to_frm').append($('#'+this.options.inputId).clone()) 
                                       }
    attachmentFilesUploader: ()->
        _this = this
        ent_id = this.entityID
        entity = this.type
        link = '/'+entity+'s/' + ent_id + '/upload_attachment_files?format=json'
        this.formElement.find('#att_to_frm').empty()
        this.formElement.find('#att_to_frm').dropzone {
                                        url: link
                                        init: ()-> 
                                            if _this.formChecking isnt null
                                                this.on "addedfile", (file)-> 
                                                    _this.formChecking()
                                        acceptedFiles: "application/pdf, application/msword, application/vnd.ms-excel, application/zip, .psd, .doc, .docx"
                                        paramName: entity+"[attachment_files]"
                                        inputId: entity+"_attachment_files"
                                        #forceFallback:true
                                        sending: (file, xhr, formData)->
                                            formData.append("authenticity_token", _this.formElement.find("input[name='authenticity_token']").val())
                                        success: (file, response)->
                                            _this.getAttachmentsToForm()
                                            $(file.previewElement).remove()
                                            #ph_id = response.photoID
                                            #getUploadedPh(ph_id, el, file.previewElement, entity)
                                        fallback: ()->
                                            v='<div class = "dz-message"><p class = "istring norm">'+this.options.dictFallbackMessage+'</p></div>'
                                            v+= '<p class = "istring norm">'+this.options.dictFallbackText+'</p><br />'
                                            _this.formElement.find('#ph_to_frm').append(v)
                                            _this.formElement.find('#ph_to_frm').append($('#'+this.options.inputId).clone()) 
                                       }
    getBindingEntities: ()->
        link = "/" + this.type + "s/" + this.entityID + "/bind_videos_and_albums?format=json"
        el = this
        arr_a = getIdsArray(this.formElement.find("#"+this.type+'_assigned_albums').val())
        arr_v = getIdsArray(this.formElement.find("#"+this.type+'_assigned_videos').val())
        $.getJSON link, (json)->
            v = ''
            a = ''
            sv = ''
            sa = ''
            #console.log json.albums.length
            $.each json.albums, (r, i)->
                f = false
                if arr_a.length>0
                    newArr = new Array()
                    for al in arr_a
                        do (al)->
                           if al is i.id then f = true else newArr[newArr.length] = al
                    arr_a = newArr
                if f
                    sa += '<div class = "art-binding-ent-item to-unbind" b-type="albums"  ent-id = "'+i.id+'"><p>'+i.name+'</p></div>'
                    f = false
                else
                    a+='<div class = "art-binding-ent-item to-bind" b-type="albums"  ent-id = "'+i.id+'"><p>'+i.name+'</p></div>'
            $.each json.videos, (s, j)->
                f = false
                if arr_v.length>0
                    newArr = new Array()
                    for vid in arr_v
                        do (v)->
                            if vid is j.id then f = true else newArr[newArr.length] = vid
                    arr_v = newArr
                if f
                    sv += '<div class = "art-binding-ent-item to-bind" b-type="videos"  ent-id = "'+j.id+'"><p>'+j.name+'</p></div>'
                    f = false
                else
                    v += '<div class = "art-binding-ent-item to-bind" b-type="videos"  ent-id = "'+j.id+'"><p>'+j.name+'</p></div>'
            $('#ab_albums').html(sa)
            $('#ab_videos').html(sv)
            $('#b_albums').html(a)
            $('#b_videos').html(v)
            updBindEntLists('albums', el)
            updBindEntLists('videos', el)
            true
    getPhsToForm: ()->
        t = $(this.formElement).find("#uploadedPhotos")
        el = this
        t.html(waitLineHtml("wait_photos_to_form"))
        wb = new waitbar("wait_photos_to_form")
        wb.startInterval()
        $(t).load "/edit_photos #update_photos_form", { 'e': el.type, 'e_id': el.entityID, "hashToCont": "true", "submitBut": "false"}, ()->
             #updUploadedImageButtons(el.formElement.attr('id'))
             wb.stopInterval()
             $(".addHashCode").click ()-> updCurFormText(" " + $(this).attr('hashCode'), el)    
             $(".del-photo-but").click ()-> el.deletePhoto(this)
             cur_photo_id = if $("##{el.type}_photo_id").val() is undefined then null else $("##{el.type}_photo_id").val()
             $(".set-as-main").each ()->
                 if $(this).attr('set_photo_id') is $("##{el.type}_photo_id").val() then $(this).hide()
                 
             $(".set-as-main").click ()-> el.setAsMainAlbumPhoto(this)
             
             $(".photo_form").on "ajax:success", (e, data, status, xhr) ->
                 nts = $(this).find("#notice")
                 nts.fadeIn 300, ()-> 
                     setTimeout (()-> nts.fadeOut(300)), 3000         
             $("[name='photo[description]']").change ()-> 
                 $(this).parents(".photo_form").submit()
             if el.formChecking isnt null then el.formChecking()
    getAttachmentsToForm: ()->
        _this = this
        t = $(this.formElement).find("#uploadedAttachmentFiles")
        $.ajax {
                type: 'get'
                url: "/attachment_files?e=#{_this.type}&e_id=#{_this.entityID}"
                dataType: "json"
                error: (d)-> console.log  
                success: (json)-> 
                    v = ""
                    if json.length > 0
                        v += "<li af-id=\"#{a.id}\" class = \"af-item\"><a class=\"b_link\" href = \"#{a.link}\">#{a.name} (#{a.size})</a> <a class = \"af-delete pointer\" title = \"Удалить\" attachment_file_id = \"#{a.id}\">#{drawIcon("fi-x","fi-medium","fi-blue")}</a></li>" for a in json
                    t.html "<ul class = \"af-uploaded-field\">#{v}</ul>"
                    $(".af-delete").click ()-> _this.deleteAttachmentFile(this)     
                    _this.formChecking()    
               }
    
    checkAttachmentLength: ()->
        eFlag = true
        err = ''
        af_field = this.formElement.find("#afContainer")
        s = af_field.find("#afLength")
        l = af_field.find(".af-item").length
        if l is 0 
            #lFlag = false
            if this.hideAttachmentField then af_field.hide() 
        else 
            #lFlag=true
            if this.hideAttachmentField then af_field.show()
        this.attachmentFilesLength = l
        if this.attachmentsMaxLength isnt 0
            if l>this.attachmentsMaxLength
                d = l-this.attachmentsMaxLength
                err = this.attachmentsMaxLengthErr + d
                eFlag=false
        if this.attachmentsMinLength isnt 0
            if l<this.attachmentsMinLength
                err = this.attachmentsMinLengthErr
                eFlag=false
        switchErr(s, eFlag)
        s.find('#txtL').text('Вложений добавлено: ' + l + ';')
        s.find('#txtErr').text(err)
        #this.imagesLenghtFlag = lFlag&eFlag
        eFlag# and lFlag
              
    deleteAttachmentFile: (delBut)->
        _this = this
        id = $(delBut).attr('attachment_file_id')
        $.ajax {
                type: 'DELETE'
                url: '/attachment_files/' + id
                dataType: "json"
                success: (data)-> 
                    $(delBut).parents('.af-item').fadeOut 300, ()-> 
                        $(this).remove()
                        if _this.formChecking isnt null then _this.formChecking()
               }        
    initPanel: ()->
        menus = ''
        buttons = '<ul>'
        for i in this.aButList
            cur_addr=this.classPrefix + this.nameList[i]
            curButClass = ' hItem'
            curMenuClass = ' hMenu'
            buttons += '<li class = "mItem'+curButClass+'" title = "'+this.descList[i]+'" id = "'+this.nameList[i]+'">'+drawIcon(cur_addr, menuIconSizeClass, "fi-grey")+'</li>'
            menus += '<div class = "mMenus'+curMenuClass+'" id = "'+this.nameList[i]+'Menu">'+menuContent(this.nameList[i], this)+'</div>'
        buttons += '</ul>'
        $('td#formButtons').html(buttons)
        $('td#formMenus').html(menus)
        el = this
        if this.tEditor isnt null
            #this.tEditor = new textEditor(this)
            $('td#formButtons').append(this.tEditor.init())
            this.tEditor.initListeners()
            this.getAlignArray()
        this.formElement.find('li.mItem').click ()->
            updMenusList(this.id, el)
        this.formElement.find('.smiles').click (e)-> 
            updCurFormText($(this).attr('smilecode'), el)
        this.contentField.keyup ()-> 
            changingTextarea(el.contentField)
        #if this.contentField isnt null
            #this.contentField.setCurretPosition(this.contentField.val().length)
        if this.type is 'theme' or this.type is 'message' or this.type is 'comment' or this.type is 'photo_album' or this.type is 'article'
            t = if el.type is 'comment' then 'message' else el.type
            st = this.formElement.find("##{t}_status_id")
            this.submitButt.mouseup ()-> 
                if not el.submitButt.hasClass("disabled") 
                    el.formElement.append("<input id = \"#{el.type}_status_id\" type = \"hidden\" name = \"#{t}[status_id]\" value = 1 />")
        if @nameField isnt null
            this.nameField.bind "keypress", (e)->
                code = e.keyCode || e.which
                if e.keyCode is 13
                    e.preventDefault()
                    false
    switchSubmitBut: (f)->
        if f then this.submitButt.removeClass('disabled') else this.submitButt.addClass('disabled')
        
    setAsMainAlbumPhoto: (setBut)->
        _this = this
        id = $(setBut).attr('set_photo_id')
        el = document.getElementById("#{this.type}_photo_id")
        if el is null 
            this.formElement.append("<input type = \"hidden\" id = \"#{this.type}_photo_id\" name = \"#{this.type}[photo_id]\" value = \"#{id}\" />")
            $(setBut).hide()
        else
            cur = $(el).val()
            $(el).val(id)
            $(setBut).hide()
            $("[set_photo_id=#{cur}]").show()
                
    deletePhoto: (delBut)->
        _this = this
        id = $(delBut).attr('photo_id')
        m = '#message_deleted_photos'
        t = '#theme_deleted_photos'
        a = '#photo_album_deleted_photos'
        n = null
        if $(m).val() isnt undefined then n = m
        else if $(t).val() isnt undefined then n = t
        else if $(a).val() isnt undefined then n = a
        if n isnt null
            v = $(n).val()
            $(n).val(addScobes(update_ids_array(getIdsArray(v),id)))
            $(delBut).unbind('click')
            $(delBut).bind 'click', ()->
                _this.recoveryPhoto(this)
            $(delBut).find('p').text('Восстановить')
            $('#img_'+id).find('.addHashCode').hide()
            $('#img_'+id).addClass('del-photo')
            if _this.formChecking isnt null then _this.formChecking()
        else
            v = confirm("Вы уверены что хотите удалить фото?")
            if v
                $.ajax {
                        type: 'DELETE'
                        url: '/entity_photos/' + id
                        dataType: "json"
                        success: (data)-> 
                            $("li#img_"+data.id).fadeOut 300, ()-> 
                                $(this).remove()
                                if _this.formChecking isnt null then _this.formChecking()
                       }
    
    recoveryPhoto: (but)->
            id = $(but).attr('photo_id')
            _this = this
            m = '#message_deleted_photos'
            t = '#theme_deleted_photos'
            a = '#photo_album_deleted_photos'
            n = null
            if $(m).val() isnt undefined then n = m
            else if $(t).val() isnt undefined then n = t
            else if $(a).val() isnt undefined then n = a
            if n isnt null
                v = $(n).val()
                $(but).unbind('click')
                $(but).bind 'click', ()->
                    _this.deletePhoto(this)
                $(but).find('p').text('Удалить')
                $(n).val(addScobes(update_ids_array(getIdsArray(v),id)))
                $('#img_'+id).find('.addHashCode').show()
                $('#img_'+id).removeClass('del-photo')
                if _this.formChecking isnt null then _this.formChecking()
                
    updVoteValuesFields: ()->
        _this = this
        els = this.formElement.find('.vote_value_items')
        l = els.length
        els.each (i)->
            el = this
            $(this).find(":text").keyup ()-> if _this.formChecking isnt null then _this.formChecking()
            $(this).find(":text").attr('name', 'vote[added_vote_values]['+i+']').focus()
            if l>2
               $(this).find("#voteValDelBut").html("<a id = 'delItem' class = 'b_link pointer'>Удалить</a>")
               $(this).find("#delItem").click ()->
                   $(el).remove()
                   _this.updVoteValuesFields()
            else
                $(this).find("#voteValDelBut").empty()
                
                   
    voteValuesCheck: ()->
        variants = []
        uFlag = true
        notEmptyCounter = 0
        text1 = ''
        text2 = ''
        fail = ''
        this.formElement.find('.vote_value_items').each (i)-> 
            variants[variants.length] = $(this).find(":text").val()
        for idx in [0.. variants.length-1]
            text1 = $.trim(variants[idx].toLowerCase())
            if text1 isnt '' then notEmptyCounter++
            if (idx < variants.length-1) and (uFlag is true) and (text1 isnt '')
                for j in [idx+1.. variants.length-1]
                    text2 = $.trim(variants[j].toLowerCase())
                    if text2 isnt ''
                        if text1 is text2
                            uFlag = false
                            break
        if not uFlag then fail+='Варианты ответа должны быть уникальные...; '
        if notEmptyCounter < 2
            fail+='Должно быть как минимум два варианта ответа...;'
            uFlag = false
        $("#qLength").find("#txtErr").html(fail)        
        uFlag

addItem = (item, el)->
        item = $(item)
        tId = "#ab_" + item.attr('b-type')
        item.removeClass('to-bind')
        item.addClass('to-unbind')
        item.unbind('click')
        item.bind('click')
        item.prependTo(tId)
        updBindEntLists(item.attr('b-type'), el)
removeItem = (item, el)->
        item = $(item)
        tId = "#b_" + item.attr('b-type')
        item.removeClass('to-unbind')
        item.addClass('to-bind')
        item.prependTo(tId)
        updBindEntLists(item.attr('b-type'), el)
updBindEntLists = (t, fe)->
        bId = "#ab_"+t
        ubId = "#b_"+t
        v = ''
        $(ubId + ' .art-binding-ent-item').each (i)->
            e = if i%2 then true else false
            o = if i%2 then false else true
            $(this).toggleClass('odd',o)
            $(this).toggleClass('even',e)
        $(bId + ' .art-binding-ent-item').each (i)->
            e = if i%2 then true else false
            o = if i%2 then false else true
            $(this).toggleClass('odd',o)
            $(this).toggleClass('even',e)
            v+='['+$(this).attr('ent-id')+']'
        $(ubId + ' .art-binding-ent-item').unbind('click')
        $(bId + ' .art-binding-ent-item').unbind('click')
        $(ubId + ' .art-binding-ent-item').bind 'click', (e)->
            bindEntityOnclick(fe, this)
        $(bId + ' .art-binding-ent-item').bind 'click', (e)->
            unbindEntityOnclick(fe, this)
        v
bindEntityOnclick = (fe, el)->
        val = addItem(el, fe)
        t = $(el).attr('b-type')
        fe.formElement.find("#"+fe.type+'_assigned_'+t).val(val)
unbindEntityOnclick = (fe, el)->
        val = removeItem(el, fe)
        t = $(el).attr('b-type')
        fe.formElement.find("#"+fe.type+'_assigned_'+t).val(val)

    
menuContent = (n, el)->
        if n is 'paw'
            val='<div class = "central_field" style = "width: 90%;">'+drawSmiles()+'</div>'
        else if n is 'link'
            val = '<table style = "width: 100%;"><tr><td><label>Вложенные альбомы</label><div class = "art-binding-ent-list" id = "ab_albums"></div></td><td><label>Вложенное видео</label><div class = "art-binding-ent-list" id = "ab_videos"></div></td></tr><tr><td style = "width: 50%; " ><br /><label>Доступные альбомы</label><br /><div class = "art-binding-ent-list" id = "b_albums"></div></td><td style = "width: 50%; "><br /><label>Доступные видео</label><br /><div class = "art-binding-ent-list" id = "b_videos"></div></td></tr></table>'
        else if n is 'photo'
            val = '<div class = "dropzone" id = "ph_to_frm"></div>'
        else if n is 'paperclip'
            val = "<div class = \"section group\"><div class = \"dropzone\" id = \"att_to_frm\"></div></div>"
        val
updMenusList = (n, el)->
        for i in el.aButList
            if n is el.nameList[i]
                if $('li#'+el.nameList[i]).hasClass('sItem')
                    $('li#'+el.nameList[i]).find('i').addClass('fi-grey').removeClass('fi-blue')
                else
                    $('li#'+el.nameList[i]).find('i').addClass('fi-blue').removeClass('fi-grey')   
                $('li#'+el.nameList[i]).toggleClass('sItem').toggleClass('hItem')
                $('div#' + el.nameList[i] + 'Menu').toggleClass('sMenu').toggleClass('hMenu')
            else
                $('li#'+el.nameList[i]).addClass('hItem').removeClass('sItem')
                $('li#'+el.nameList[i]).find('i').addClass('fi-grey').removeClass('fi-blue')
                $('div#'+el.nameList[i]+'Menu').addClass('hMenu').removeClass('sMenu')
            
        true

drawSmiles = ()->
        smilesCount=34
        smilesPath='/smiles/'
        val=''
        for i in [1..smilesCount]
            val+='<img class = "smiles" src="'+smilesPath+i+'.gif" smilecode ="*sm'+i+'*">'
        val
updCurFormText = (txt, el)->
        i = el.contentField.getSelection().start + txt.length
        el.contentField.replaceSelection(txt)
        el.contentField.keyup()
        el.contentField.setCurretPosition(i)
switchErr = (el, sw)->
        el.toggleClass('norm', sw).toggleClass('err', !sw)

entCounter = (text)->
    c = text.length
    v = 0
    if c>0
        for i in [0.. c-1]
            if text[i] is '\n' then v++
        v
    else 0

changingTextarea = (e)->
    r = $(e).attr('rows')
    c = $(e).attr('cols')
    dr = $(e).attr('defaultRows')
    cr = c*r
    txt = $(e).val()
    v = entCounter(txt)
    nr = dr*1 + v + ((txt.length - v) / $(e).attr('cols')*0.9)
    $(e).attr('rows', nr)

getTargetTheme = (el)->
    selectTheme = $(el)
    targetPlace = $('#target_theme')
    e_text = '<p class = "istring norm">Тема не выбрана</p>'
    d_val = selectTheme.val()
    if d_val is '' then targetPlace.html(e_text)
    targetPlace.load("/themes/"+d_val+"?but=false #thBody")

make_themes_list = (th, func)->
    $.getJSON th.getThemeQuery(), (json)-> 
        build_themes_list(json)
        if typeof func is "function" then func()
        true
    
build_themes_list = (themes)->
    $("div#likebleNames, select#merge_theme_theme_id").empty()
    $("select#merge_theme_theme_id").html("<option value>Выберите тему из списка</option>")
    $.each themes, (i, theme)-> 
        $("#merge_theme_theme_id").append("<option value='" + theme.id + "'>" + theme.name + "</option>")
        $('div#likebleNames').append('<div class = "likebleName" id = "ent_'+theme.id+'" style = "width: 100%;position:relative;"><a title = "Открыть в новой вкладке" target = "_blank" href = "/themes/'+theme.id+'" class="b_link" style = "padding-left: 5px;">'+theme.name + '</a></div>')

addScobes = (a)->
    v = ""
    v+="["+i+"]" for i in a
    v

getIdsArray = (val)->
    a = []
    j = 0
    v = ""
    if val isnt ''
        for i in [0..val.length-1]
            if val[i] is ']'
                a[j]= parseFloat(v)
                v=""
                j++
            else if val[i] isnt ']' and val[i] isnt '['
                v += val[i]
    a
    
update_ids_array = (id_array,id)->
    id_int = parseFloat(id)
    val = $.grep id_array, (n)-> n is id_int
    array_size = id_array.length
    new_arr = new Array()
    if val.length > 0
        new_arr = $.grep id_array, (n)-> n isnt id_int
    else
        id_array[array_size] = id_int
        new_arr = id_array
    new_arr


#theme request Class
class themeObj
    constructor: (
                 @name = 'none',
                 @topic = 'none',
                 @limit = 'none'
                 )->
    
    getThemeQuery: ()->
        getThemesList = getThemeListLink
        link='none'
        if this.name isnt 'none' or this.topic isnt 'none' or this.limit isnt 'none'
            link = getThemesList
            if this.name isnt 'none' then link=link+'&name='+this.name
            if this.topic isnt 'none' then link=link+'&topic='+this.topic
            if this.limit isnt 'none' then link=link+'&limit='+this.limit
        link

class albumObj
    constructor: ()->
    @name: 'none'
    @category: 'none'
    @limit: 'none'
    @id: ''
    @hasNotMatches: true
    getAlbumQuery: ()->
        getAlbumsList = getAlbumListLink
        link='none'
        if this.name != 'none' or this.category isnt 'none' or this.limit isnt 'none'
            link = getAlbumsList
            if this.name isnt 'none' then link=link+'&name='+this.name
            if this.category isnt 'none' then link=link+'&category_id='+this.category
            if this.limit isnt 'none' then link=link+'&limit='+this.limit
        link
    getAlbumNames: (func)->
        _this = this
        $.getJSON this.getAlbumQuery(), (albums)->
            f = true
            $('div#likebleNames').empty();
            $.each albums, (i, album)->
                if album.id isnt _this.id
                    #if album.name.toLowerCase() is _this.name then f = false
                    $('div#likebleNames').append('<div class = "likebleName" id = "ent_'+album.id+'" style = "width: 100%;position:relative;"><a title = "Открыть в новой вкладке" target = "_blank" href = "/photo_albums/'+album.id+'" class="b_link" style = "padding-left: 5px;">'+ album.name + '</a></div>')
            func()
        true  

class bbCodeObj
    constructor: (@name, 
                  @params,
                  @sTagStart = 0,
                  @eTagStart = 0,
                  @tagsCollection = [
                                      {
                                          name: 'align-center'
                                          className: 'cnt-al-c'
                                      }
                                      {
                                          name: 'align-right'
                                          className: 'cnt-al-r'
                                      }
                                      {
                                          name: 'quote'
                                          className: 'cnt-quotes'
                                      }
                                      {
                                          name: 'list-number'
                                          className: 'cnt-un-num'
                                      }
                                     ])->
    getContent: (s)->
        if this.sTagStart+1 is this.eTagStart 
            return ''
        else
            return s.substring(this.sTagStart+this.tagName().start.length, this.eTagStart)
    tagName: ()->
        p = if this.params is 'none' then '' else '='+this.params
        e = if this.name is 'list-number' then '\n' else ''
        if this.name is 'i'
            v = {
                  start: this.params + ". " 
                  end: ""
                }
        else 
            v = {
                 start: if this.name is 'align-left' then "" else "["+this.name+p+"]" + e
                 end: if this.name is 'align-left' then "" else e + "[/"+this.name+"]"
                }
        v
    initBb: (a)->
        cur = a.getCurAlignBbCode()
        if this.name isnt cur.name
            if this.name isnt 'align-left' and cur.name isnt 'align-left'
                if cur.getContent(a.tArea.val()).length > 0
                    cur.getContent(a.tArea.val()).length
                    a.tArea.setCurretPosition(cur.eTagStart + cur.tagName().end.length)
                    this.sTagStart = a.tArea.getSelection().start
                    this.eTagStart = a.tArea.getSelection().start + this.tagName().start.length
                    t = this.tagName().start+this.tagName().end
                    a.tArea.replaceSelection(t)
                    a.tArea.setCurretPosition(this.eTagStart)
                else
                    a.tArea.setCurretPosition(cur.sTagStart, cur.eTagStart + cur.tagName().end.length)
                    t = this.tagName().start+this.tagName().end
                    a.tArea.replaceSelection(t)
                    a.tArea.setCurretPosition(cur.sTagStart+this.tagName().start.length)
            else if this.name isnt 'align-left' and cur.name is 'align-left'
                this.sTagStart = a.tArea.getSelection().start
                this.eTagStart = a.tArea.getSelection().start + this.tagName().start.length
                t = this.tagName().start+this.tagName().end
                a.tArea.replaceSelection(t)
                a.tArea.setCurretPosition(this.sTagStart+this.tagName().start.length)
            else if this.name is 'align-left' && cur.name isnt 'align-left'
                if cur.getContent(a.tArea.val()).length > 0
                    a.tArea.setCurretPosition(cur.eTagStart + cur.tagName().end.length)
                else
                    a.tArea.setCurretPosition(cur.sTagStart, cur.eTagStart + cur.tagName().end.length)
                    a.tArea.replaceSelection('')
                    a.tArea.setCurretPosition(cur.sTagStart)
            if this.name is 'list-number'
                nItem = new bbCodeObj('i', '1')
                nItem.initTBb(a)
        else 
           a.tArea.setCurretPosition(a.tArea.getSelection().start)
           
    initTBb: (a)->
        this.sTagStart = a.tArea.getSelection().start
        this.eTagStart = a.tArea.getSelection().start + this.tagName().start.length
        t = this.tagName().start+this.tagName().end
        a.tArea.replaceSelection(t)
        a.tArea.setCurretPosition(this.sTagStart+this.tagName().start.length)
    getClassName: ()->
        for i in [0..this.tagsCollection.length-1]
            if this.tagsCollection[i].name is this.name then return this.tagsCollection[i].className
        return 'none'
    getTagFromStr: ()->
        if str isnt null and str isnt undefined
            if $.trim(str).length>0
                s = str.indexOf(this.tagName().start, 0)
                if s>-1
                    e = str.indexOf(this.tagName().end, s)
                    if e>-1 then return {start: s, end: e}
        return {start: -1, end: -1}


class textEditor
    constructor: (@el, 
                  @formElement = @el.formElement, 
                  @tArea = @el.contentField,
                  @imgAddr = 'fi-',
                  @tAlignMenus = ['align-left', 'align-center', 'align-right', 'quote', 'list-number'],
                  @tAlignMenusDescription = ['Выравнивание по левому краю', 'Выравнивание по центру', 'Выравнивание по правому краю', 'Цитирование', 'Нумерованный список'],
                  @tFormatMenus = ['italic', 'bold', 'underline', 'strikethrough', 'h2', 'h3'],
                  @tFormatMenusDescription = ['Наклонный', 'Жирный', 'Подчёркнутый', 'Зачёркнутый', 'Заголовок второго уровня', 'Заголовок третьего уровня'],
                  @curFormat = 'none',
                  @editorPreview = document.getElementById('editorPreview')
                  )->
    init: ()->
        t = this.initAPanel()
        t = if this.editorPreview is null then t else t+'<li id = "updTextPrewiew" title = "Обновить поле предварительного просмотра">'+drawIcon("fi-refresh", menuIconSizeClass, "fi-grey")+'</li>'
        t
    initListeners: ()->
        el = this
        this.formElement.find('#updTextPrewiew').click ()->
            el.drawCode()
            el.tArea.setCurretPosition(el.tArea.getSelection().start)
        this.formElement.find('.alItem').click ()->
            for i in [0..el.tAlignMenus.length-1]
                if this.id is el.tAlignMenus[i]
                    bb = new bbCodeObj(el.tAlignMenus[i], 'none')
                    bb.initBb(el)
                    $('li#'+el.tAlignMenus[i]).addClass('sItem').removeClass('hItem')
                    switchClasses("fi-blue", "fi-grey", $('li#'+el.tAlignMenus[i]).find('i'))
                else
                    $('li#'+el.tAlignMenus[i]).addClass('hItem').removeClass('sItem')
                    switchClasses("fi-grey", "fi-blue", $('li#'+el.tAlignMenus[i]).find('i'))
        this.tArea.keyup (e)->
            c = el.updateAlignMenu()
            if c.name is 'list-number'
                if e.keyCode is 13
                    el.addNextNumItem(c)
        this.tArea.click ()->
            el.updateAlignMenu()
    addNextNumItem: (c)->
        s= c.getContent(this.tArea.val())
        re = /^\d+\.\s(.*)\n/gm
        newStr = ''
        nItem = new bbCodeObj('i', '1')
        j=0
        if $.trim(s).length > 0
            v = s.match(re)
            if v.length>0
                for i in [0.. v.length-1]
                    j = i+1
                    newStr += v[i].replace(/\d+\.\s/, j+". ")
                this.tArea.setCurretPosition(c.sTagStart + c.tagName().start.length, c.eTagStart)
                this.tArea.replaceSelection(newStr)
                this.tArea.setCurretPosition(c.sTagStart + c.tagName().start.length + newStr.length)
        nItem.params = j+1
        nItem.initTBb(this)
    getCurAlignBbCode: ()->
        str = this.tArea.val()
        names = this.tAlignMenus
        b = new bbCodeObj('align-left', 'none')
        j = -1
        if str isnt undefined
            for i in [1.. names.length-1]
                c = 0
                b.name = names[i]
                
                while j<str.length
                    j++
                    b.sTagStart = str.indexOf(b.tagName().start, c)
                    if b.sTagStart is -1 then break 
                    else
                        b.eTagStart = str.indexOf(b.tagName().end, b.sTagStart)
                        if b.eTagStart is -1 then break
                        else
                            if this.tArea.getSelection().start > b.sTagStart && this.tArea.getSelection().end < b.eTagStart + b.tagName().end.length
                                return b
                            else c=b.eTagStart+b.tagName().end.length
            b.name = 'align-left'
            b.sTagStart = str.length
            b.eTagStart = str.length
            b

    escapeBbText: ()->
       str=$.trim(this.tArea.val())
       names = this.tAlignMenus
       if str.length > 0
           for i in [1..names.length-1]
               str = str.replace(new RegExp("\\["+names[i]+"\\]",'g'), '')
               str = str.replace(new RegExp("\\[/"+names[i]+"\\]",'g'), '')
           str = str.replace(new RegExp("\n",'g'), '')
       str
    drawCode: ()->
       _this = this
       t = if this.el.type is "comment" then "message" else this.el.type
       url = "/"+t+"s/"+this.el.entityID
       arr = ''
       arr = this.formElement.serialize()
       $.ajax {
               url: url
               dataType: "json"
               type: "POST"
               data: arr
               error: (x, y, z)->
                   console.log(x)
               success: (data)->
                   $("#editorPreview").load(url + "?preview_mode=true #" + t[0] + "_" + _this.el.entityID)
              }
    initAPanel: ()->
        v = ''
        curBbAlign = this.getCurAlignBbCode()
        for i in [0.. this.tAlignMenus.length-1]
            cBCl = if curBbAlign.name is this.tAlignMenus[i] then "sItem" else "hItem"
            cImg = if curBbAlign.name is this.tAlignMenus[i] then 'fi-blue' else 'fi-grey'
            nImg = this.imgAddr+this.tAlignMenus[i]
            sImg = menuIconSizeClass
            v += '<li class = "alItem '+cBCl+'" title = "'+this.tAlignMenusDescription[i]+'" id = "'+this.tAlignMenus[i]+'">'+drawIcon(nImg, sImg, cImg)+'</li>' 
        v
    updateAlignMenu: ()->
       c = this.getCurAlignBbCode()
       _this = this
       for i in [0.. this.tAlignMenus.length-1]
           if c.name is this.tAlignMenus[i]
               $('li#'+this.tAlignMenus[i]).addClass('sItem').removeClass('hItem')
               switchClasses("fi-blue", "fi-grey", $('li#'+this.tAlignMenus[i]).find('i'))
           else
               $('li#'+this.tAlignMenus[i]).addClass('hItem').removeClass('sItem')
               switchClasses("fi-grey", "fi-blue", $('li#'+this.tAlignMenus[i]).find('i'))
       c
     
drawIcon = (n,s,c)->
    if n isnt 'h2' && n isnt 'h3'
        return "<i class = \""+n+" "+s+" "+c+"\"></i>"
    else
        return "<#{n} class = \"#{c} #{s}\">#{n}</#{n}>" 

switchClasses = (cOn, cOff, e)->
    if e.hasClass(cOff) then e.removeClass(cOff)
    if !e.hasClass(cOn) then e.addClass(cOn)

bindCoordetecter = ()->
    (()->
        fieldSelection = {
                            getSelection: ()->
                                e = if this.jquery then this[0] else this
                                return (('selectionStart' of e and ()->
                                    l = e.selectionEnd - e.selectionStart
                                    return { 
                                            start: e.selectionStart
                                            end: e.selectionEnd
                                            length: l
                                            text: e.value.substr(e.selectionStart, l) 
                                           }
                                ) or (document.selection and ()->
                                    e.focus()
                                    r = document.selection.createRange()
                                    if r is null
                                        return {
                                                start: 0
                                                end: e.value.length
                                                length: 0
                                                }
                                    re = e.createTextRange()
                                    rc = re.duplicate()
                                    re.moveToBookmark(r.getBookmark())
                                    rc.setEndPoint('EndToStart', re)
                                    return {
                                            start: rc.text.length
                                            end: rc.text.length + r.text.length
                                            length: r.text.length
                                            text: r.text 
                                           } 
                                ) or
                                ()->
                                    null
                                
                                )()
                            replaceSelection: ()->
                                e = if this.jquery then this[0] else this
                                text = arguments[0] || ''
                                return (('selectionStart' of e and ()->
                                    e.value = e.value.substr(0, e.selectionStart) + text + e.value.substr(e.selectionEnd, e.value.length)
                                    return this
                                ) or (document.selection and ()->
                                    e.focus()
                                    document.selection.createRange().text = text
                                    return this 
                                ) or ()->
                                    e.value += text
                                    return jQuery(e)
                                )()
                            setCurretPosition: (start, end)->
                                end = if not end then start else end
                                return this.each ()->
                                    if this.setSelectionRange
                                        this.focus()
                                        this.setSelectionRange(start, end)
                                    else if this.createTextRange 
                                        range = this.createTextRange()
                                        range.collapse(true)
                                        range.moveEnd('character', end)
                                        range.moveStart('character', start)
                                        range.select()
                              }
        jQuery.each fieldSelection, (i)-> 
            jQuery.fn[i] = this
    )()

r = ()->
    Dropzone.autoDiscover = false
    bindCoordetecter()
    tForm = document.getElementsByClassName(themeFormClass)
    mForm = document.getElementsByClassName(messageFormClass)
    vForm = document.getElementsByClassName(videoFormClass)
    paForm = document.getElementsByClassName(albumFormClass)
    vtForm = document.getElementById(voteFormId)
    aForm = document.getElementsByClassName(articleFormClass)
    eForm = document.getElementsByClassName(eventFormClass) 
    if tForm.length > 0 then initThemeForm(tForm[0])
    if mForm.length > 0 then initMessageForm(mForm[0])
    if vForm.length > 0 then initVideoForm(vForm[0])
    if paForm.length > 0 then initAlbumForm(paForm[0]) 
    if vtForm isnt null then initVoteForm(vtForm)
    if aForm.length > 0 then initArticleForm(aForm[0])
    if eForm.length > 0 then initEventForm(eForm[0])
    $('#merge_theme_topic_id').change ()->
        th = new themeObj()
        th.topic = $(this).val()
        make_themes_list(th)
    $('#merge_theme_theme_id').change ()->
        getTargetTheme this

$(document).ready r
$(document).on "page:load", r
    