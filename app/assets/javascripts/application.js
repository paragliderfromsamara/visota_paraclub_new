// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/core
//= require jquery-ui/dialog
//= require turbolinks
//= require_tree

function my_functions()
	{
		var enteredLi, leftLi; //для управления главным меню
		
        Dropzone.autoDiscover = false;
        Dropzone.options.myAwesomeDropzone = false;
        eventRotator();
		$('#mLogo, .nav_li, #ses_p li, .t_link, .ph-paginate, .ph-big-links,.wide-butt').click(function () {goToLink($(this).attr('link_to'));});
		//$('#split_theme_topic_id').change(function(){var th = new themeObj(); th.topic = $(this).val(); make_themes_list(th);});
		$('#add_attachments').click(function(){$('div#toggle_add_attachments').toggle(150);});
		$('div#show_cmts').click(
									function(){
												var txt,c;
												txt=$(this).text();
												c=$(this).attr('cmts_count')*1-1;
												if (txt == 'Показать все')
													{$(this).text('Скрыть');
														$(this).css('background-color', '#0087BC');
														$('.msgs').each(function(i)
																			{
																				$(this).show(150);
																			}
																		);
													}
												else{
													$(this).text('Показать все');
													$('.msgs').each(function(i)
																		{
																			if(i>c)
																				{ 
																					$(this).find('#answr').empty(); 
																					$(this).find('#answer_but').html("<div class = 'b_green'><p class = 'b_link_name'>Ответить</p></div>");
																					$(this).hide(150);
																				}
																		}
																	);
															}
												}
								);
		$('a#ans_link').click(function()
										{
											var c=$($(this).attr('href')).css('background-color'), n='blue';
											$($(this).attr('href')).find('.cWrapper').animate({opacity: 1.0}, 500 ).animate({opacity: 0.0}, 500 );
										}
							 );
		
	};

function submitMyForm(id, el){
                                if ($(el).hasClass('disabled') == false)
                                {
                                    $(el).parents("form").submit();
                                    console.log("Yeah!!!")
                                }    
                             }
function waitbar(id)
    {
        var wl = $("#" + id);
        var tNull = 100;
        var loopTime = wl.find(".wl-item").length*tNull + tNull;
        this.curVisible = 0;
        this.interval = null;
        this.startInterval = function () {
                                wl.fadeIn(200);
                                this.interval = setInterval(function() {
    							var t = tNull;
                                
    							wl.find(".wl-item").css("background-color", "grey");
							
    							wl.find(".wl-item").each(function(i){
    																	var el = $(this);
    																	setTimeout(
    																				function() {
    																							el.css("background-color", "black");
    																						   }, t
    																			  );
    																	t += tNull;
    															   });
    						   }, loopTime);}
        
        this.stopInterval = function()
        {
            if (this.interval !== null) {clearInterval(this.interval); wl.fadeOut(200);}
        }
        
    }

	function goToLink(link)
	{
		if (link !== '' && link !== undefined) {document.location.href = link;}
	};
    
function eventRotator()
    {
        var hEvents = $.makeArray($('.h-event'));
        var vEvents = $.makeArray($('.v-event'));
        var iTime = 12000;
        var cTime = 2000;
        var tTime = 700;
        console.log(hEvents.length + ' ' + vEvents.length);
        if (hEvents.length > 0)
        {
            setInterval(function(){
                for(var i = 0; i<3; i++)
                {
                    setTimeout(function(){
                        var vEl = vEvents.shift();
                        var hEl = hEvents.shift();
                        var oHtml = $(vEl).html();
                        var nHtml = $(hEl).html();
                        $(vEl).fadeOut(tTime, function(){
                            $(vEl).html(nHtml);
                            $(hEl).html(oHtml);
                            $(vEl).fadeIn(tTime);
                            vEvents.push(vEl);
                            hEvents.push(hEl);
                            
                        })
                    }, i*cTime);
                }
            }, iTime)
        }
    }

	