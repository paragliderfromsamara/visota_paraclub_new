# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
newUserFormClass = "new_user_form"
trueFieldColor = '#dbffe7'
falseFieldColor = '#ffdbdb'

nameCheck = ()->
     name = $("#user_name")
     isTrueLength = name.val().length > 2 && name.val().length < 37
     isMatchName = true
     if isTrueLength
         $.ajax(
                url: "/check_email_and_name.json?name=#{name.val()}"
                async: false
                data: "json"
                success: (json)->
                    isMatchName = if json.status is 'true' then false else true
               )
     err = if (isMatchName || isTrueLength) && not isMatchName then "Пользователь с ником \"#{name.val()}\" уже существует" else "Ввёденный ник имеет некорректную длину"
     $("#user_name_error").text(err)
     return isMatchName && isTrueLength

passwordCheck = ()->
    l = $("#user_password").val().length
    min = 6
    max = 40
    isTrueLength = l >= min && l <= max
    $("#password_error").text(if not isTrueLength && l <= min then "Длина пароля не должна быть меньше #{min} символов" else "Длина пароля не должна быть больше #{max} символов")
    if isTrueLength then $('.new_user_form').foundation('validateInput', $("#user_password_confirmation"))
    return isTrueLength

emailCheck = ()->
    email = $("#user_email").val()
    mailReg = /\S+@\S+\.\S+/
    isTrueEmail = email.search(mailReg) isnt -1
    if isTrueEmail
        $.ajax(
               url: "/check_email_and_name.json?email=#{email}"
               async: false
               data: "json"
               success: (json)->
                   isTrueEmail = if json.status is 'true' then false else true
              )
        $("#email_error").text "Введённый E-mail используется другим пользователем"
    else
        $("#email_error").text  "E-mail введён не верно"
    return isTrueEmail
    
initNewUserForm = (frm)->
    f = new Foundation.Abide($(frm))
    Foundation.Abide.defaults.validators['check_user_name'] = nameCheck
    Foundation.Abide.defaults.validators['check_user_password'] = passwordCheck
    Foundation.Abide.defaults.validators['check_user_email'] = emailCheck
        
r = ()->
    rForm = document.getElementById("remember-password")
    uForm = document.getElementsByClassName(newUserFormClass)
    $("a#sendCheckMail").on "ajax:start", ()-> 
        $('#wait_message_send').html('Ожидание...')
    $("a#sendCheckMail").on "ajax:success", (e, data, status, xhr)-> 
        $('#wait_message_send').html '<i class = "fi-check"></i> В течение 3-х минут письмо дойдет до указанного Вами адреса'
    $("a#sendCheckMail").on "ajax:error", (e, data, status, xhr)-> 
        $('#wait_message_send').html '<i class = "fi-x"></i> Не удалось отправить сообщение...'   
    if uForm.length > 0 then initNewUserForm(uForm[0])
    if rForm isnt null then f = new Foundation.Abide($(rForm))
    


$(document).ready r
$(document).on "page:load", r