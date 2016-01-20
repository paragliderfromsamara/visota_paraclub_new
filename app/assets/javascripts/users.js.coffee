# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
newUserFormClass = "new_user_form"
trueFieldColor = '#dbffe7'
falseFieldColor = '#ffdbdb'

initNewUserForm = (frm)->
    uCard = new userCard($(frm))
    uCard.initListeners()
    uCard.checkForm()
class userCard
    constructor: (@formElement,
                  @nameElement = @formElement.find("#user_name"),
                  @passwordElement = @formElement.find("#user_password"),
                  @passwordConfirmationElement = @formElement.find("#user_password_confirmation"),
                  @emailElement = @formElement.find("#user_email"),
                  @submitButt = @formElement.find("#submit_#{newUserFormClass}_button"),
                  @curName = @nameElement.val(),
                  @curEmail = @emailElement.val(),
                  @minNameLength = 2,
                  @maxNameLength = 32,
                  @minPasswordLength = 6,
                  @maxPasswordLength = 40,
                  @errFlagName = false,
                  @errUniqMail = false,
                  @errFlagPswr = false,
                  @errFlagConf = false,
                  @errFlagMail = false,
                  @antibotFlagErr = false,
                  @errFlagAntibotText = "Введите символы с картинки",
                  @shortNameErrText = "Ник должен содержать как минимум #{@minNameLength} знака.",
                  @longNameErrText = "Ник должен содержать не более #{@maxNameLength} знаков.",
                  @uniqNameErrText = "Введенный ник используется другим пользователем.",
                  @shortPswrErrText = "Пароль должен состоять как минимум из #{@minPasswordLength} знаков.",
                  @longPswrErrText = "Пароль должен состоять не более чем из #{@maxPasswordLength} знаков.",
                  @confPswrErrText = "Подтверждение должно совпадать с паролем.",
                  @errFlagMailText = "Почтовый адрес не соответствует формату"
                 )->
    nameCheck: ()->
         name = $.trim @nameElement.val()
         errDescEl = $("#user_name_check").find("#errDesc")
         #$("#user_name_check").find("#length").text "#{name.length}  "
         _this = this
         if name is @curName then return true
         if name.length < @minNameLength
            @errFlagName = false
            errDescEl.text @shortNameErrText
         else if name.length > @maxNameLength 
            @errFlagName = false
            errDescEl.text @longNameErrText
         else 
            @errFlagName = true
            errDescEl.text ""
            $.getJSON "/check_email_and_name.json?name=#{name}", (json)->
                if json.status isnt 'true'
                    _this.errFlagName = true
                    errDescEl.text "Ник введён верно"
                else 
                    _this.errFlagName = false
                    errDescEl.text _this.uniqNameErrText 
                _this.curName = name 
                _this.checkForm() 
            #return true
         this.checkForm()
    passwordCheck: ()->
        pswrd = $.trim @passwordElement.val()
        pswrdCnfr = $.trim @passwordConfirmationElement.val()
        pswrErrDescEl = $("#user_password_check").find("#errDesc")
        cnfrErrDescEl = $("#user_password_confirmation_check").find("#errDesc")
        if pswrd.length < @minPasswordLength
            @errFlagPswr = false
            pswrErrDescEl.text @shortPswrErrText
            cnfrErrDescEl.text ""
        else if pswrd.length > @maxPasswordLength
            @errFlagPswr = false
            pswrErrDescEl.text @longPswrErrText
            cnfrErrDescEl.text ""
        else
            @errFlagPswr = true
            pswrErrDescEl.text "Пароль введён верно"
            if pswrd is pswrdCnfr
                @errFlagConf = true
                cnfrErrDescEl.text "Поддтверждение введено верно"
            else
                @errFlagConf = false
                cnfrErrDescEl.text @confPswrErrText
        this.checkForm()
    
    emailCheck: ()->
        email = $.trim @emailElement.val()
        mailReg = /\S+@\S+\.\S+/
        errDescEl = $("#user_email_check").find("#errDesc")
        _this = this
        if email is @curEmail then return true
        if email.search(mailReg) is -1
            @errFlagMail = false
            errDescEl.text @errFlagMailText
        else
            @errFlagMail = true
            errDescEl.text ""
            $.getJSON "/check_email_and_name.json?email=#{email}", (json)->
                if json.status isnt 'true'
                    @errFlagMail = true
                    errDescEl.text "E-mail введён верно"
                else 
                    @errFlagMail = false
                    errDescEl.text "Введённый E-mail используется другим пользователем"
                _this.curEmail = email 
                _this.checkForm()
            
        
        
    checkForm: ()->
       this.changeInputColor(@errFlagName, @nameElement)
       this.changeInputColor(@errFlagPswr, @passwordElement)
       this.changeInputColor(@errFlagConf, @passwordConfirmationElement)
       this.changeInputColor(@errFlagMail, @emailElement)
       if @errFlagName and @errFlagPswr and @errFlagConf and @errFlagMail then this.submitButt.removeClass('disabled') else this.submitButt.addClass('disabled')
       #console.log this.nameElement.val()
    
    
    
    initListeners: ()->
       _this = this 
       @nameElement.bind "keyup change", ()-> _this.nameCheck()
       @passwordElement.bind "keyup change", ()-> 
           _this.passwordCheck()
           _this.passwordConfirmationElement.val ""
       @passwordConfirmationElement.bind "keyup change", ()-> _this.passwordCheck()               
       @emailElement.bind "keyup change", ()-> _this.emailCheck()
       
       
    changeInputColor: (flag, field)->
        clr = if flag then trueFieldColor else falseFieldColor
        field.css('background-color', clr)

r = ()->
    uForm = document.getElementsByClassName(newUserFormClass)
    $("a#sendCheckMail").on "ajax:start", ()-> 
        $('#wait_message_send').html('Ожидание...')
    $("a#sendCheckMail").on "ajax:success", (e, data, status, xhr)-> 
        $('#wait_message_send').html '<i class = "fi-check"></i> В течение 3-х минут письмо дойдет до указанного Вами адреса'
    $("a#sendCheckMail").on "ajax:error", (e, data, status, xhr)-> 
        $('#wait_message_send').html '<i class = "fi-x"></i> Не удалось отправить сообщение...'
    
        
    if uForm.length > 0 then initNewUserForm(uForm[0])
    


$(document).ready r
$(document).on "page:load", r