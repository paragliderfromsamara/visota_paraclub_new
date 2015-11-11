# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
getThemeListLink = "/get_themes_list?format=json"
getAlbumListLink = "/get_albums_list?format=json"
themeFormClass = "theme-form"
themeFormId = "theme_form_"


initThemeForm = (frm)->
    tId = $(frm).attr('id').replace(themeFormId, "")
    console.log $(frm).attr('class')
    f = new myForm('theme',  tId, "."+$(frm).attr('class'))
    f.contentField = f.formElement.find("#theme_content")
    f.aButList = [0]
    f.photosUploader()
    f.tEditor = new textEditor(f)
    f.initPanel()

class myForm
    constructor: (@type, 
                  @entityID, 
                  @formName, 
                  @formElement = $(@formName), 
                  @submitButt = null, 
                  @tEditor = null, 
                  @parentElID = 'none', 
                  @classPrefix = 'fi-', 
                  @nameList = ['paw', 'link', 'photo'], 
                  @descList = ['Эмоции', 'Вложить альбомы и видео', 'Добавить фотографии'], 
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
                  @imagesMaxLength = 0,
                  @imagesMinLength = 0,
                  @imagesMaxLengthErr = '',
                  @imagesMinLengthErr = '',
                  @imagesLenghtFlag = false
                  )->
        
    #name part------------------------------------------------------------

    nameLentghCheck: ()->
        f = true
        s = this.formElement.find('p#nLength')
        if this.nameField.val() isnt undefined
            if this.nameFieldMaxLength isnt 0 && this.nameField.val().length > this.nameFieldMaxLength
                d = this.nameField.val().length - this.nameFieldMaxLength
                err = this.longNameErr + d
                f = false
            if this.nameFieldMinLength isnt 0 && this.nameField.val().length < this.nameFieldMinLength
                err = this.shortNameErr
                f = false
            s.find('#txtL').text this.nameField.val().length +' из ' + this.nameFieldMaxLength
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
               if _this.curNameValue.toLowerCase() == ($(this).find('a').text()).toLowerCase()
                   $(this).css('background-color', '#f1c8c8')
                   f=false
                   err = el.matchNameErr
               else $(this).css('background-color', 'none')
            else $(this).hide()
        s.find('#txtMatchesErr').text(err)
        f
    getLikebleNames: ()->
        if this.curNameValue isnt $.trim(this.nameField.val())
            if this.type is 'theme'
                o = new themeObj()
                o.topic = this.formElement.find('#theme_topic_id').val()
                o.name = this.nameField.val()
                make_themes_list(o)
            else if this.type is 'article'
                #to_do
            else if this.type is 'photo_album'
                a = new albumObj()
                a.name = this.nameField.val()
                a.category = this.formElement.find('#photo_album_category_id').val()
                a.id = this.entityID
                a.getAlbumNames()
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
            if this.tEditor.tArea isnt undefined then return this.tEditor.escapeBbText()
        return this.contentField.val()
    contentLengthCheck: ()->
        err = ''
        f = true
        s = this.formElement.find('p#cLength')
        if str isnt undefined and this.contentField.val() isnt undefined
            maxTxtL = this.contentFieldMaxLength - (this.contentField.val().length - str.length)
            if maxTxtL < 0 then maxTxtL = 0
            if this.contentFieldMaxLength isnt 0 and this.alterText().length > maxTxtL and maxTxtL > 0
                d = this.alterText().length - maxTxtL
                err = this.longContentErr + d
                f = false
            if this.contentFieldMinLength isnt 0 and this.alterText().length < this.contentFieldMinLength
                err = this.shortContentErr
                f = false
            s.find('#txtL').text(this.alterText().length +' из ' + maxTxtL)
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
        l = this.formElement.find('.tImage').length - this.formElement.find('.del-photo').length
        if l is 0 then lFlag = false else lFlag=true
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
        this.imagesLenghtFlag = lFlag&eFlag
        lFlag and eFlag
    photosUploader: ()->
        ent_id = this.entityID
        el = if this.parentElID is 'none' then this.formElement else $(this.parentElID)
        entity = this.type
        link = '/'+entity+'s/' + ent_id + '/upload_photos?format=json'
        el.find('#ph_to_frm').empty()
        el.find('#ph_to_frm').dropzone {
                                        url: link
                                        acceptedFiles: "image/*"
                                        paramName: entity+"[uploaded_photos]"
                                        inputId: entity+"_uploaded_photos"
                                        #forceFallback:true
                                        sending: (file, xhr, formData)->
                                            formData.append("authenticity_token", el.find("input[name='authenticity_token']").val())
                                        success: (file, response)->
                                            ph_id = response.photoID
                                            getUploadedPh(ph_id, el, file.previewElement, entity)
                                        fallback: ()->
                                            v='<div class = "dz-message"><p class = "istring norm">'+this.options.dictFallbackMessage+'</p></div>'
                                            v+= '<p class = "istring norm">'+this.options.dictFallbackText+'</p><br />'
                                            $(el).find('#ph_to_frm').append(v)
                                            $(el).find('#ph_to_frm').append($('#'+this.options.inputId).clone()) 
                                       }
        true
        
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
        $(t).load "/edit_photos #update_photos_form", { 'e': el.type, 'e_id': el.entityID, "hashToCont": "true", "submitBut": "false"}, ()->
             updUploadedImageButtons(el.formElement.attr('id'))
    initPanel: ()->
        menus = ''
        buttons = '<ul>'
        for i in this.aButList
            cur_addr=this.classPrefix + this.nameList[i]
            curButClass = ' hItem'
            curMenuClass = ' hMenu'
            buttons += '<li class = "mItem'+curButClass+'" title = "'+this.descList[i]+'" id = "'+this.nameList[i]+'">'+drawIcon(cur_addr, "fi-largest", "fi-grey")+'</li>'
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
    switchSubmitBut: (f)->
        if f then this.submitButt.removeClass('disabled') else this.submitButt.addClass('disabled') 
            

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
getUploadedPh = (phID, el, prEl, type)->
        $.getJSON "/photos/"+phID+"?format=json", (t)->
            if t.id isnt 'null'
                $(prEl).remove()
                $(el).find(".dz-message").show()
                renderImgFrm(t, el, type)
    
renderImgFrm = (ph, el, type)->
        if ph.description is null then ph.description = 'Без описания...'
        imgTag='<img src="#{ph.thumb}">'
        field='<textarea cols="35" defaultrows="3" id="photo_editions_photos_photo_#{ph.id}_description" name="photo_editions[photos][photo_#{ph.id}][description]" onkeyup="changingTextarea(this)" rows="3"></textarea><br /><br /><a onclick="deletePhotoInTable(this)" photo_id="#{ph.id}" class="b_link pointer">Удалить</a>'
        if el.attr('id') isnt 'photosField' and type isnt 'photo_album'
            field += ' <a onclick="addHashCodeToTextArea(this,\'#{el.attr("id")}\')"  class="b_link pointer addHashCode" hashCode="#Photo#{ph.id}"  title = "Нажмите, чтобы встроить фото в текст...">Встроить в текст</a>'
        curHtml = '<tbody class = "tImage" id="img_#{ph.id}"><tr><td valign="top" align = "center"><input id="photo_editions_photos_photo_#{ph.id}_id" name="photo_editions[photos][photo_#{ph.id}][id]" type="hidden" value="#{ph.id}">#{imgTag}</td><td valign="top" >#{field}</td></tr></tbody>'
        $(el).find("#uPhts").prepend(curHtml)
menuContent = (n, el)->
        if n is 'paw'
            val='<div class = "central_field" style = "width: 90%;">'+drawSmiles()+'</div>'
        else if n is 'binding'
            val = '<table style = "width: 100%;"><tr><td><label>Вложенные альбомы</label><div class = "art-binding-ent-list" id = "ab_albums"></div></td><td><label>Вложенное видео</label><div class = "art-binding-ent-list" id = "ab_videos"></div></td></tr><tr><td style = "width: 50%; " ><br /><label>Доступные альбомы</label><br /><div class = "art-binding-ent-list" id = "b_albums"></div></td><td style = "width: 50%; "><br /><label>Доступные видео</label><br /><div class = "art-binding-ent-list" id = "b_videos"></div></td></tr></table>'
        else if n is 'photo'
            val = '<div class = "dropzone" id = "ph_to_frm"></div>'
        val
updMenusList = (n, el)->
        for j in [0..el.aButList.length-1]
            i = el.aButList[j]
            if n is el.nameList[i]
                if $('li#'+el.nameList[i]).hasClass('sItem')
                    $('li#'+el.nameList[i]).find('i').addClass('fi-grey').removeClass('fi-blue')
                else
                    $('li#'+el.nameList[i]).find('i').addClass('fi-blue').removeClass('fi-grey')
                $('li#'+el.nameList[i]).addClass('hItem').removeClass('sItem')
                $('div#' + el.nameList[i] + 'Menu').toggleClass('sMenu').toggleClass('hMenu')
            else
                $('li#'+el.nameList[i]).addClass('hItem').removeClass('sItem')
                $('li#'+el.nameList[i]).find('i').addClass('fi-grey').removeClass('fi-blue')
                $('div#'+el.nameList[i]+'Menu').addClass('hMenu').removeClass('sMenu')
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
        console.log i
switchErr = (el, sw)->
        el.toggleClass('norm', sw).toggleClass('err', !sw)
        





changingTextarea = (e)->
    r = $(e).attr('rows')
    c = $(e).attr('cols')
    dr = $(e).attr('defaultRows')
    cr = c*r
    txt = $(e).val()
    v = entCounter(txt)
    nr = dr*1 + v + ((txt.length - v) / $(e).attr('cols')*0.9)
    $(e).attr('rows', nr)
    
addHashCodeToTextArea = (e, id)->
    t = ''
    ta = $('#'+id).find('#message_content, #theme_content, #article_content, #event_content')
    t= $.trim(ta.val())
    if t isnt '' then t = t+'\n'
    ta.val(t+$(e).attr('hashCode'))
    ta.focus()

getTargetTheme = ()->
    selectTheme = $('#split_theme_theme_id')
    targetPlace = $('#target_theme')
    e_text = '<p class = "istring norm">Тема не выбрана</p>'
    initTargetTheme()
    selectTheme.change ()-> 
        getTargetTheme($(this).val())
    initTargetTheme = ()->
        d_val = selectTheme.val()
        if d_val is '' then targetPlace.html(e_text)
    getTargetTheme = (id)->
        $("#target_theme").load("/themes/"+id+"?but=false #thBody")

make_themes_list = (th)->
    $.getJSON th.getThemeQuery(), (json)-> 
        build_themes_list(json)
    
build_themes_list = (themes)->
    $("div#likebleNames, select#split_theme_theme_id").empty()
    $("div#split_theme_theme_id").html("<option value>Выберите тему из списка</option>")
    $.each themes, (i, theme)-> 
        $("#split_theme_theme_id").append("<option value='" + theme.id + "'>" + theme.name + "</option>")
        $('div#likebleNames').append('<div class = "likebleName" id = "ent_'+theme.id+'" style = "width: 100%;position:relative;"><a title = "Открыть в новой вкладке" target = "_blank" href = "/themes/'+theme.id+'" class="b_link" style = "padding-left: 5px;">'+theme.name + '</a></div>')

addScobes = (a)->
    v = ""
    for i in [0..a.length-1]
        v+="["+a[i]+"]" 
    return v

getIdsArray = (val)->
    a = new Array()
    j = 0
    v = ""
    if val isnt ''
        for i in [0..val.length-1]
            if val[i] is ']'
                a[j]=v
                v=""
                j++
            else if val[i] isnt ']' and val[i] isnt '['
                v += val[i]
    a

update_ids_array = (id_array,id)->
    id_int = parseFloat(id)
    $.grep id_array, (n)-> 
        return n == id_int
    array_size = id_array.length
    new_arr = new Array()
    if val.length > 0
        new_arr = $.grep id_array, (n)-> 
            return n != id_int
    else
        id_array[array_size] = id_int
        new_arr = id_array
        return new_arr

deletePhotoInTable = (delBut)->
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
        $(delBut).attr('onclick', 'recoveryPhotoInTable(this)')
        $(delBut).text('Восстановить')
        $('#img_'+id).find('.addHashCode').hide()
        $('#img_'+id).addClass('del-photo')
    else
        v = confirm("Вы уверены что хотите удалить фото?")
        if v
            $.ajax {
                    type: 'DELETE'
                    url: '/photos/' + id
                    success: (data)-> 
                        alert data.message
                   }
            $("tbody#img_"+id).remove()
            

recoveryPhotoInTable = (but)->
    id = $(but).attr('photo_id')
    m = '#message_deleted_photos'
    t = '#theme_deleted_photos'
    a = '#photo_album_deleted_photos'
    n = null
    if $(m).val() isnt undefined then n = m
    else if $(t).val() isnt undefined then n = t
    else if $(a).val() isnt undefined then n = a
    if n isnt null
        v = $(n).val()
        $(but).attr('onclick', 'deletePhotoInTable(this)')
        $(but).text('Удалить')
        $(n).val(addScobes(update_ids_array(getIdsArray(v),id)))
        $('#img_'+id).find('.addHashCode').show()
        $('#img_'+id).removeClass('del-photo')


#theme request Class
class themeObj
    constructor: ()->
    @name: 'none'
    @topic: 'none'
    @limit: 'none'
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
    getAlbumNames: ()->
        _this = this
        $.getJSON this.getAlbumQuery(), (albums)->
            f = true
            $('div#likebleNames').empty();
            $.each albums, (i, album)->
                if album.id isnt _this.id
                    #if album.name.toLowerCase() is _this.name then f = false
                    $('div#likebleNames').append('<div class = "likebleName" id = "ent_'+album.id+'" style = "width: 100%;position:relative;"><a title = "Открыть в новой вкладке" target = "_blank" href = "/photo_albums/'+album.id+'" class="b_link" style = "padding-left: 5px;">'+ album.name + '</a></div>')         
            
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
                  @curFormat = 'none',
                  @editorPreview = document.getElementById('editorPreview'))->
    init: ()->
        t = this.initAPanel()
        t = if this.editorPreview is null then t else t+'<li id = "updTextPrewiew" title = "Обновить поле предварительного просмотра">'+drawIcon("fi-refresh", "fi-largest", "fi-grey")+'</li>'
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
            console.log v
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
            sImg = "fi-largest"
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
    "<i class = \""+n+" "+s+" "+c+"\"></i>"

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
    if tForm.length > 0 then initThemeForm(tForm[0])

$(document).ready r
$(document).on "page:load", r
    