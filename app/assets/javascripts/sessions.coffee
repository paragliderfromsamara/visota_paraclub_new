# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
openEntryFormId = "open-session-menu-but"
sessionFormId = "site-entry-form"
sessionFormUrl = "/signin?nolayout=true #sesForm"
formContainerId = "ses-form-container"
sesBut = null
sesForm = null

makeSessionForm = ()->
    $("body").append(
                        "
                            <div class=\"reveal\" id=\"#{sessionFormId}\" data-reveal>
                              <h1>Вход</h1>
                              <div id = \"#{formContainerId}\">
                              </div>
                              <button class=\"close-button\" data-close aria-label=\"Закрыть окно\" type=\"button\">
                                <span aria-hidden=\"true\">&times;</span>
                              </button>
                            </div>
                        "
                    )
    sesForm = $("##{sessionFormId}")
    sesForm.find("##{formContainerId}").load(sessionFormUrl, ()-> 
                                    el = new Foundation.Reveal(sesForm)
                                    $("##{sessionFormId}").foundation('open')
                                    $("##{sessionFormId}").on("closed.zf.reveal", ()-> $("##{sessionFormId}").foundation('destroy'))
                                )
    

r = ()->
    sesBut = document.getElementById(openEntryFormId)
    if sesBut isnt null
        sesBut = $(sesBut)
        sesBut.click(makeSessionForm)
    
    


$(document).ready r
$(document).on "page:load", r