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
//= require turbolinks
//= require_tree


function my_functions()
	{
		var enteredLi, leftLi; //для управления главным меню
		
        Dropzone.autoDiscover = false;
        Dropzone.options.myAwesomeDropzone = false;
		$('#mLogo, .nav_li, #ses_p li, .t_link, .ph-paginate, .ph-big-links,.wide-butt').click(function () {goToLink($(this).attr('link_to'));});
		$('#split_theme_topic_id').change(function(){var th = new themeObj(); th.topic = $(this).val(); make_themes_list(th);});
		$('#add_attachments').click(function(){$('div#toggle_add_attachments').toggle(150);});
		//$('#add_photos').click(function(){$('div#toggle_add_photos').toggle(150);});
		//$("#nav_topics").hover(function(){$('div#nav_topics_list').show(100);},function(){$('div#nav_topics_list').hide(100);});
		//$("#nav_materials").hover(function(){$('div#nav_materials_list').show(100);},function(){$('div#nav_materials_list').hide(100);});

		//$("div.index_miniature").hover(function(){
		//											var dat_id=this.id.replace('icon_','#bgr_icon_');
		//											$(dat_id).animate( { opacity: '0.7' }, { duration:500} );
		//										},
		//							   function(){
		//											var dat_id=this.id.replace('icon_','#bgr_icon_');
		//											$(dat_id).animate( { opacity: '0.2' }, { duration:500} );
		//										}
		//							  );
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
                                    $(el).parents('form').submit();
                                }    
                             }
function initSearchForm()
        {
            
            //alert(curTopicListDispAttr);
            var but = $("#searchForm").find(".myBut");
            if ($("#in_themes_and_messages").attr('checked') !== 'checked')
            {
                $('#topicsList').find(":checkbox").each(function(i){$(this).attr('disabled','false');});
            }
            $("#searchFormContainer").mouseleave(function(){
                                                            var curTopicListDispAttr = $("#topicsList").css("display");
                                                            if (curTopicListDispAttr != 'none') $("#topicsList").hide(100);
                                                });
        
                                                $("#t_and_msg_s").mousemove(function(){ var curTopicListDispAttr = $("#topicsList").css("display");
                                                            if (curTopicListDispAttr == 'none') $("#topicsList").show(100);});
            but.click(function(){
                                    //alert($("#searchForm").serialize());

                                        but.find('a').attr('href', "/search?" + $("#searchForm").serialize());
                                        //goToLink($("#searchForm").serialize());
                                        //else alert('Введите поисковую фразу.');
                                });
            $("#in_themes_and_messages").change(
                                                        function(){
                                                                    var curTopicListDispAttr = $("#topicsList").css("display");
                                                                    
                                                                    
                                                                    if ($(this).attr('checked') !== 'checked')
                                                                    {
                                                                        $(this).attr('checked', 'checked');
                                                                        $('#topicsList').find(":checkbox").each(function(i){
                                                                                                                                $(this).attr('checked', 'checked');
                                                                                                                                $(this).removeAttr('disabled');
                                                                                                                           });
                                                                    }else {
                                                                        $(this).removeAttr('checked');
                                                                        $('#topicsList').find(":checkbox").each(function(i){if ($(this).attr('checked') == 'checked') $(this).attr('disabled','false');});
                                                                    }
                                                                    //$('#topicsList').toggle(200);

                                                                  });
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

//message and themes part end
function initCardChecking(flds) //Инициализация
			{
				for (var i=0;i<flds.length;i++)
					{
						$('#' + flds[i]).after(' <span class = "check" id = "' + flds[i] + '_check"><span id = "note_length"></span> <span id = "err_desc"></span><span id = "test"></span></span>');
					}
			}
//Проверка полей заполнения пользователя
function userFieldsChecking()
	{
		var flds = ['user_name', 'user_password', 'user_password_confirmation', 'user_email'];
		var trueFieldColor = '#dbffe7';
		var falseFieldColor = '#ffdbdb';
		var usrCard = new userCard();
		initCardChecking(flds);
		setInterval(function(){
								//$('#user_name_check').find('#test').text($('#user_name').val());
								checkUserFields();
							  }, 800);
		$('#user_name, #user_password, #user_password_confirmation, #user_email').keyup(function(){
																									if (this.id == 'user_password' || this.id == 'user_password_confirmation' || this.id == 'user_email' )
																									{
																										var cVal = $(this).val();
																										cVal = jQuery.trim(cVal);
																										$(this).val(cVal);
																									}
																									//checkUserFields();
																								   })//.click(function(){checkUserFields();});

		function checkUserFields() //Проверка правильности заполненных полей
			{
				if (usrCard.updateParams())
					{
						if (usrCard.cngFlagName == true)
							{
								var f = 'user_name';
								var errLength = lengthErrors(usrCard.minNameLength, usrCard.maxNameLength, usrCard.oName.length);
								uniqNameValidation();
								setTimeout(function(){
														var txt;
														usrCard.errFlagName = errLength.flag | usrCard.errUniqName;
														if (errLength.flag)
															{
																txt = errLength.text;
															}
														else 
															{
																if (usrCard.errUniqName)
																{
																	txt = 'Введённый Вами Ник уже занят.'
																}
																else {txt = errLength.text;}
															}
														changeInputColor(f, usrCard.errFlagName);
														printErrText(txt, f);
														
													 }, 500);
							}
						if (usrCard.cngFlagPswr | usrCard.cngFlagConf)
							{
								var f = 'user_password';
								var errLength = lengthErrors(usrCard.minPswrLength, usrCard.maxPswrLength, usrCard.oPswr.length);
								usrCard.errFlagPswr = errLength.flag;
								changeInputColor(f, usrCard.errFlagPswr);
								printErrText(errLength.text, f);
							}
						if (usrCard.cngFlagConf == true)
							{
								var f = 'user_password_confirmation';
								var t;
								if (!usrCard.cngFlagPswr)
									{
										if (usrCard.oConf != '')
											{
												if (usrCard.oConf == usrCard.oPswr && !usrCard.errFlagPswr)
													{
															t = 'Подтверждение введено верно.';
															usrCard.errFlagConf = false;
													}
													else if (usrCard.oConf != usrCard.oPswr && !usrCard.errFlagPswr)
															{
																if (usrCard.oConf.length < usrCard.oPswr.length)
																	{	
																		if (usrCard.partialConf())
																		{
																			t = 'Подтверждение вводится правильно...';
																			usrCard.errFlagConf = true;
																		}
																		else {
																				t = 'Подтверждение не соответствует введённому паролю.';
																				usrCard.errFlagConf = true;
																			 }
																	}
															}
															else {
																	t = 'Подтверждение не соответствует введённому паролю.';
																	usrCard.errFlagConf = true;
																 }
											}
											else
											{
												t = 'Поле не должно быть пустым.';
												usrCard.errFlagConf = true;
											}
									}
									else {
											t = '';
											usrCard.errFlagConf = true;
										 }
								
								changeInputColor(f, usrCard.errFlagConf);
								printErrText(t, f);
								
							}
						if (usrCard.cngFlagMail == true)
							{
								var f = 'user_email';
								uniqMailValidation();
								setTimeout(function(){
														var t;
														var mailReg = /\S+@\S+\.\S+/; 
														var str = usrCard.oMail;
														var mailTest = str.search(mailReg);
														if (mailTest == -1)
														{
															t = 'Неправильный формат email адреса. Правильный формат example@visota.ru';
															usrCard.errFlagMail = true;
														}
														else {
																if (usrCard.errUniqMail)
																{
																	t = 'Введённый E-mail используется другим пользователем.';
																	usrCard.errFlagMail = false;
																}
																else {
																		t = 'Поле заполнено верно';
																		usrCard.errFlagMail = false;
																	  }
															}
														
														
														changeInputColor(f, usrCard.errFlagMail | usrCard.errUniqMail);
														printErrText(t, f);
														
													 }, 500);
							}
					} //else alert('Без изменений');
					setTimeout(function(){if (usrCard.errFlag()) {$('#new_user_button').addClass('disabled');} //Блокирует кнопку отправки формы
				else {$('#new_user_button').removeClass('disabled');} }, 800)
				
			}
			function uniqNameValidation(){
												$.getJSON("/check_email_and_name.json?name=" + usrCard.oName, function(json){
												if (json.status == 'true') {
																				usrCard.errUniqName = true;
																			} else {usrCard.errUniqName = false;}
											});
										 }
			function uniqMailValidation(){
												$.getJSON("/check_email_and_name.json?email=" + usrCard.oMail, function(json){
												if (json.status == 'true') {
																				usrCard.errUniqMail = true;
																			} else {usrCard.errUniqMail = false;}
											});
										 }
			function changeInputColor(f, flag)
			{
				if (flag)
					{
						$('#' + f).css('background-color', falseFieldColor);
					} else $('#' + f).css('background-color', trueFieldColor);
			}
			function printErrText(txt, f) //Печатает ошибки в id = "err_desc"
				{
					$('#'+f+'_check').find('span#err_desc').html(txt);
				}
			function lengthErrors(min, max, length)
			{
				var err = new Object();
				var emptyErr = 'Поле не должно быть пустым';
				var minErr = 'Поле должно содержать не менее ' + min + ' символов.';
				var maxErr = 'Поле должно содержать не более ' + max + ' символов.';
				var noErr = 'Поле заполнено верно';
				err.inputLength = length;
				if (err.inputLength == 0) {err.text = emptyErr; err.flag = true;}
				else if (err.inputLength < min && err.inputLength > 0) {err.text = minErr; err.flag = true;}
				else if (err.inputLength > max) {err.text = maxErr; err.flag = true;}
				else if (err.inputLength >= min && err.inputLength <= max) {err.text = noErr; err.flag = false;}
				return err;
			}
			function userCard() //конструктор объекта userData
			{
				var usr = new Object();
				//Введённые значения
				usr.oName = '';
				usr.oPswr = '';
				usr.oConf = '';
				usr.oMail = '';
				//usr.lastKeyUp();
				//Введённые значения 
				//Введённые значения
				usr.cngFlagName = true;
				usr.cngFlagPswr = true;
				usr.cngFlagConf = true;
				usr.cngFlagMail = true;
				//Введённые значения 
				//Ограничивающие параметры
				usr.minNameLength = 2;
				usr.maxNameLength = 32;
				usr.minPswrLength = 6;
				usr.maxPswrLength = 40;
				//Ограничивающие параметры end
				//Флаги ошибок
				usr.errFlagName = true;
				usr.errUniqName = true;
				usr.errUniqMail = true; 
				usr.errFlagPswr = true;						  
				usr.errFlagConf = true;						  
				usr.errFlagMail = true;
				//
				
				usr.uniqValidStatus = false; //Статус проверки уникальности 
				usr.updateParams = function(){ //Обновляем поля...
												var newName = $('#user_name').val();
												var newPswr = $('#user_password').val();
												var newConf = $('#user_password_confirmation').val();
												var newMail = $('#user_email').val();
												if (this.oName != newName)
													{
														this.oName = newName;
														this.cngFlagName = true;
													} else {this.cngFlagName = false;}
												if (this.oPswr != newPswr)
													{
														this.oPswr = newPswr;
														this.cngFlagPswr = true;
														$('#user_password_confirmation').val('');
														this.cngFlagConf = true;
													} else {this.cngFlagPswr = false;}
												if (this.oConf != newConf)
													{
														this.oConf = newConf;
														this.cngFlagConf = true;
													} else {this.cngFlagConf = false;}
												if (this.oMail != newMail)
													{
														this.oMail = newMail;
														this.cngFlagMail = true;
													} else {this.cngFlagMail = false;}	
												if (this.cngFlagName == true || this.cngFlagPswr == true || this.cngFlagConf == true || this.cngFlagMail == true){return true;}
												else {return false;}
											 }
				
												   
				usr.errFlag = function(){return (this.errUniqMail | this.errFlagName | this.errUniqName | this.errFlagPswr | this.errFlagConf | this.errFlagMail)};
				usr.partialConf = function(){
												var cLength = this.oConf.length;
												var flag = true;
												for (var i=0; i<cLength; i++)
												{
													if (this.oConf[i] != this.oPswr[i]) {flag = false; break;}
												}
												return flag;
											}
				return usr;
			} 
	}
 
//Проверка полей заполнения пользователя end

/*/vote_path
function voteShowPath(id)
{
	$("a#giveVoice").click(function(){giveVoteVoice(id, $(this).attr("valId"))});
	function giveVoteVoice(vote_id, val_id)
	{
		$.ajax({
					type: "POST",
					url: "/voices",
					data: ({voice:({vote_id: vote_id, vote_value_id: val_id})}),
					success: function(msg){$("#vtValues").html(msg);}
 });
	}
	
}
*///vote_path end


//Старые функции, удалять лишнее


/*

function wheather_panel(){var time=360;$(".wheather_content").hover(function(){},function(){$("div#wheather_blocks").animate({opacity:0.0},time,function(){$("div#wheather_blocks").css('display','none');});$(".wheather_panel").animate({width:"0"},time);});$(".wheather_link").click(function(){$(".wheather_panel").animate({width:"750px"},time);$("div#wheather_blocks").css('display','inline-block');$("div#wheather_blocks").animate({opacity:1.0},time);});};
function replace_block(e){var first_block = document.getElementById(e.name+'_first_block');var second_block=document.getElementById(e.name+'_second_block');second_block.style.display="block";first_block.style.display="none";e.style.display = "none";};
function add_content_to_article(e){var type=$(e).attr("item-type");var h_field_name="#article_assigned_"+type;var item_id=parseFloat($(e).attr("val"));var old_value_str=$(h_field_name).val();var old_value_arr=getIdsArray(old_value_str);var new_arr=update_ids_array(old_value_arr,item_id);changeSelection(e);$(h_field_name).val(addScobes(new_arr));};
function changeSelection(e){var s=$(e).attr("was_selected");if(s=="false"){$(e).css("background-color","#FFFCED");$(e).attr("was_selected","true");}else if(s == "true"){$(e).css("background-color","#CCEAD1");$(e).attr("was_selected","false");};};



function checkMyDropLists(){var list_types=["albums", "videos"];for(var i = 0;i<list_types.length;i++){setItemsByType(list_types[i]);}}
function setItemsByType(type){var hidden_f=document.getElementById("article_assigned_"+type);var ids=new Array();var val = "";if(hidden_f!=null){val=$(hidden_f).val();if(val!=''){ids=getIdsArray(val);$(".drop_value").each(function(i){var item_type=$(this).attr("item-type");var item_id=parseFloat($(this).attr("val"));if(item_type==type){for(var j=0;j<ids.length;j++){if(item_id==ids[j]){changeSelection(this);}}} else {return true}});}}}


*/	

	