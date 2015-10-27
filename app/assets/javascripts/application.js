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

var allowArrows = true;
function my_functions()
	{
		var enteredLi, leftLi; //для управления главным меню
		setInterval(function(){bottomControl()}, 500);
        //$(window).resize(function(){bottomControl();});
		Dropzone.autoDiscover = false;
		//scroller
		$('.quickScroll #aUp').click(function(){$(window).scrollTop(0);});
		$('.quickScroll #aDwn').click(function(){var p=$("#top").outerHeight(true)+$("#middle").outerHeight(true);$(window).scrollTop(p);});
		//scroller end

		$(document).on("click", ".slider .nav span", function() { // slider click navigate
		var sl = $(this).closest(".slider"); // находим, в каком блоке был клик
		$(sl).find("span").removeClass("on"); // убираем активный элемент
		$(this).addClass("on"); // делаем активным текущий
		var obj = $(this).attr("rel"); // узнаем его номер
		sliderJS(obj, sl); // слайдим
		return false;
		});
		
		$(window).scroll(function(){$('.scroll-test').text($(this).scrollTop()); scrollControl();});  
		$('#mLogo, .nav_li, #ses_p li, .t_link, .ph-paginate, .ph-big-links,.wide-butt').click(function () {goToLink($(this).attr('link_to'));});
		$('#split_theme_topic_id').change(function(){var th = new themeObj(); th.topic = $(this).val(); make_themes_list(th);});
		
		$('#add_attachments').click(function(){$('div#toggle_add_attachments').toggle(150);});
		$('#add_photos').click(function(){$('div#toggle_add_photos').toggle(150);});
		$("#nav_topics").hover(function(){$('div#nav_topics_list').show(100);},function(){$('div#nav_topics_list').hide(100);});
		$("#nav_materials").hover(function(){$('div#nav_materials_list').show(100);},function(){$('div#nav_materials_list').hide(100);});

		$("div.index_miniature").hover(function(){
													var dat_id=this.id.replace('icon_','#bgr_icon_');
													$(dat_id).animate( { opacity: '0.7' }, { duration:500} );
												},
									   function(){
													var dat_id=this.id.replace('icon_','#bgr_icon_');
													$(dat_id).animate( { opacity: '0.2' }, { duration:500} );
												}
									  );
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
                                    document.getElementById(id).submit();
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
function bottomControl()
	{
		var sum_h, window_h, new_middle_h, markOffset; 
		sum_h = blocksSumHeight();
		window_h = $(window).height();
        markOffset = $("#footerMark").offset().top;
       // $("#test").text(markOffset);
		if (markOffset + $("#bottom").outerHeight(true) < window_h)
		{
			new_middle_h = window_h - $("#top").outerHeight(true) - $("#bottom").outerHeight(true) - $("#ses_p").outerHeight(true);
			$('#middle').height(new_middle_h);
			$("#bottom").css('position', 'fixed').css('bottom', '0');
		}else{
                new_middle_h = markOffset - $("#top").outerHeight(true) - $("#ses_p").outerHeight(true);
                $("#bottom").css('position', 'relative').css('bottom', 'none');
                $('#middle').height(new_middle_h);
             }
		scrollControl();
	}
function blocksSumHeight(){return $("#top").outerHeight(true) + $("#middle").outerHeight(true) + $("#bottom").outerHeight(true) + $("#ses_p").outerHeight(true);} 

function scrollControl() //Управление панелькой перемотки
	{
		var wH,blSH,sT,sB, botH,topH,t=300; 
		wH = $(window).height();
		blSH = blocksSumHeight();
		sT = $(window).scrollTop();
		topH = $("div#top").outerHeight(true);
		botH = $("div#bottom").outerHeight(true);
		if ((blSH-topH-botH) > wH)
		{
			$('.quickScroll').fadeIn(t);
			if (sT>topH) {
							$('.quickScroll #aUp').fadeIn(t);
						 }else{$('.quickScroll #aUp').fadeOut();}
			if ((blSH-sT)>wH)
							{
								$('.quickScroll #aDwn').fadeIn(t);
							}else{$('.quickScroll #aDwn').fadeOut();}
		} else {$('.quickScroll').fadeOut();}

	}
//Wheater_panel
function wheatherPanel()
{
	var cont = $('.right_menu #cont');
	var h_wr = cont.find('#h_wr');
	$('#w_but').click(function(){
									var wh_c = $('.right_menu #wh_cont');
									h_wr.html(wh_c.html());
									h_wr.width(wh_c.width());
									h_wr.show(300);
							    });
	$('.right_menu').mouseleave(function(){
											h_wr.hide(300);
											h_wr.html('');
										});
	
}
//Wheater_panel end

	function goToLink(link)
	{
		if (link !== '' && link !== undefined) {document.location.href = link;}
	};
//photos part
function getUploadedPhoto(phID, el, prEl)
	{
		$.getJSON("/photos/"+phID+"?format=json", function(t){
															if (t.id != 'null')
																{
																	$(prEl).remove();
																	$(el).find(".dz-message").show();
																	renderImgForm(t, el);
																}
															 }
				  ); 
	}
function renderImgForm(ph, el) //создаёт форму для фотографии
{
	var imgTag, field, curHtml;
	if (ph.description == null){ph.description='Без описания...';}
	imgTag='<img src="'+ph.thumb+'">';
	field='<textarea cols="35" defaultrows="3" id="photo_editions_photos_photo_'+ph.id+'_description" name="photo_editions[photos][photo_'+ph.id+'][description]" onkeyup="changingTextarea(this)" rows="3"></textarea><br /><br /><a onclick="deletePhotoInTable(this)" photo_id="'+ph.id+'" class="b_link pointer">Удалить</a>';
	if (el.attr('id') != 'photosField')
	{
		field+= '| <a onclick="addHashCodeToTextArea(this,\''+$(el).attr('id')+'\')"  class="b_link pointer addHashCode" hashCode="#Photo'+ph.id+'"  title = "Нажмите, чтобы встроить фото в текст...">Встроить в текст</a>';
	}
	curHtml = '<tbody class = "tImage" id="img_'+ph.id+'"><tr><td valign="top" ><input id="photo_editions_photos_photo_'+ph.id+'_id" name="photo_editions[photos][photo_'+ph.id+'][id]" type="hidden" value="'+ph.id+'">'+imgTag+'</td><td valign="top" >'+field+'</td></tr></tbody>';
	$(el).find("#uPhts").prepend(curHtml);
}

function getParentFormNode(e){return $(e+':parent').find('.answr, #newMsgForm');}
function updUploadedImageButtons(id){$('a.addHashCode').each(function() {$(this).attr('onclick', 'addHashCodeToTextArea(this, "'+id+'")');});}
function getPhotosToForm(entId, entName, el){var t = $(el).find("#uploadedPhotos"); $(t).load("/edit_photos #update_photos_form", { 'e': entName, 'e_id': entId, "hashToCont": "true", "submitBut": "false"}, function(){updUploadedImageButtons('newMsgForm')}); }

function newPhObj(id, description)
{
	var ph = new Object();
	ph.id = id;
	ph.description = description;
	return ph;
}


//photos part end

//message and themes part


	function entCounter(text){var c,v;c=text.length;v=0;if(c>0){for(var i=0;i<c;i++){if (text[i]=='\n'){v++;}if(i==(c-1)){return v;};}}else{return 0;}}
	
//message and themes part end
function photosUploaderOld(ent_id, entity, el) //добавление фотографий к сообщению
	{ 
		var link = '/'+entity+'s/' + ent_id + '/upload_photos?format=json'; 
		el.find('#ph_to_msg').empty();
		el.find('#ph_to_msg').dropzone(
									{ 
										url: link,
										acceptedFiles: "image/*",
										paramName: entity+"[uploaded_photos]",
										inputId: entity+"_uploaded_photos",
										forceFallback: false,
										success: function(file, response){
																			var ph_id = response.photoID;
																			getUploadedPhoto(ph_id, el, file.previewElement);
																			
																		 },
										fallback: function(){
																var v;
																v='<div class = "dz-message"><p class = "istring norm">'+this.options.dictFallbackMessage+'</p></div>';
																v+= '<p class = "istring norm">'+this.options.dictFallbackText+'</p><br />';
																$(el).find('#ph_to_msg').append(v);
																$(el).find('#ph_to_msg').append($('#'+this.options.inputId).clone());
															}
									}
								);
	}
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


//photo_path
function myPhotoPage()
{
	var fVisible=-1,lVisible=-1, maxVBlocks=7, blC, offset;
	offset = (maxVBlocks-1)/2;
	blC = $(".ph-paginate").length;
	if (blC>maxVBlocks){updPhotoPaginate('init');$(".ph-arrows").removeClass('ph-h');}
	function updPhotoPaginate(f)
	{
		var j=0;
		$(".ph-paginate").each(function(i){
											if (f == 'init')
											{
												
												if ($(this).hasClass('ph-h') == false){
																				fVisible=j;
																				updScrIndexes('right');
																				return false;
																				}
												
											}else{
													if ((j<fVisible) || (lVisible < j))
														{
														$(this).addClass('ph-h');
														} else {
																	$(this).removeClass('ph-h');
															    }
												 }
											j++;
										  });
										  
	}
	function updScrIndexes(f)
	{
		if (f=='left')
		{
			if ((lVisible-(maxVBlocks-1)) >= 0)
			{
				fVisible = lVisible-(maxVBlocks-1);
			}else{
					fVisible = 0;
					lVisible = maxVBlocks-1;
				 }
		}
		else if (f=='right')
		{
			if ((fVisible+(maxVBlocks-1)) < blC)
			{
				lVisible = fVisible+(maxVBlocks-1);
			}else{
					fVisible = blC - maxVBlocks-1;
					lVisible = blC-1;
				 }
		}
		if (fVisible==0){$(".ph-arr-left").css("visibility", "hidden");}else{$(".ph-arr-left").css("visibility", "visible")}
		if (lVisible==(blC-1)){$(".ph-arr-right").css("visibility", "hidden")}else{$(".ph-arr-right").css("visibility", "visible")}
	}
	$(".ph-arr-right").click(function(){
											if ((fVisible+(maxVBlocks-1)) !== (blC-1)){fVisible++;updScrIndexes('right');updPhotoPaginate('upd');}
									   });
	$(".ph-arr-left").click(function(){
											if ((lVisible-(maxVBlocks-1)) !== 0){lVisible--;updScrIndexes('left');updPhotoPaginate('upd');}
									  });
	
	//var
}
function setPhotoSizeByScreen(width, height)
{
   var wHeight =  $(window).height();
   var pagHeight = $("#photoPagination").outerHeight(true) + $("#topPhotoPanel").outerHeight(true);
   var newHeight = wHeight-pagHeight;
   var iconsTop = 200;
   $(document).keyup(
       function(event){
           if (allowArrows == true)
           {
               if (event.keyCode == 37) //previousPhoto
               {
                     goToLink($(".ph-big-prev").attr('link_to'));
               }else if (event.keyCode == 39)  //nextPhoto
               {
                     goToLink($(".ph-big-next").attr('link_to'));
               }
           }});          
   if (height > newHeight){$("#bPhoto").height(newHeight); iconsTop = newHeight/2 - $("div#iIcon").height()/2;}else{iconsTop = height/2 - $("div#iIcon").height()/2;}
   $("div#iIcon").css('top', iconsTop + 'px')   ;
}

//photo_path end
//vote_path
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
//vote_path end
function switchThemeWatcher(el, th_id)
{
	$.ajax({
					type: "POST",
					url: "/theme_notifications.json",
					data: ({theme_notifications:({type: 'single', theme_id: th_id})}),
					success: function(but){$(el).html('<li><img src = "/files/'+but.type+'_b.png" style = "float: left;" height = "20px">'+but.name+'</li>');}
})
}
function switchLikeMark(id, type)
{
	$.ajax({
					type: "POST",
					url: "/switch_mark.json",
					data: ({mark:({type: type, id: id})}),
					success: function(v){
                                            var el = $('#' + type + '_' + id + '_mark');
                                            var toRemoveClass = (v.img == "fi-blue")? "fi-grey":"fi-blue";
                                            var toAddClass = (v.img == "fi-blue")? "fi-blue":"fi-grey"; 
                                            el.find('#mark_link').text(v.linkName); 
                                            el.find('#mark_count').text(v.mCount); 
                                            el.find('#mark_img').removeClass(toRemoveClass);
                                            el.find('#mark_img').addClass(toAddClass);
                                        }
})
}
//Старые функции, удалять лишнее
function wheather_panel(){var time=360;$(".wheather_content").hover(function(){},function(){$("div#wheather_blocks").animate({opacity:0.0},time,function(){$("div#wheather_blocks").css('display','none');});$(".wheather_panel").animate({width:"0"},time);});$(".wheather_link").click(function(){$(".wheather_panel").animate({width:"750px"},time);$("div#wheather_blocks").css('display','inline-block');$("div#wheather_blocks").animate({opacity:1.0},time);});};
function replace_block(e){var first_block = document.getElementById(e.name+'_first_block');var second_block=document.getElementById(e.name+'_second_block');second_block.style.display="block";first_block.style.display="none";e.style.display = "none";};
function add_content_to_article(e){var type=$(e).attr("item-type");var h_field_name="#article_assigned_"+type;var item_id=parseFloat($(e).attr("val"));var old_value_str=$(h_field_name).val();var old_value_arr=getIdsArray(old_value_str);var new_arr=update_ids_array(old_value_arr,item_id);changeSelection(e);$(h_field_name).val(addScobes(new_arr));};
function changeSelection(e){var s=$(e).attr("was_selected");if(s=="false"){$(e).css("background-color","#FFFCED");$(e).attr("was_selected","true");}else if(s == "true"){$(e).css("background-color","#CCEAD1");$(e).attr("was_selected","false");};};



function checkMyDropLists(){var list_types=["albums", "videos"];for(var i = 0;i<list_types.length;i++){setItemsByType(list_types[i]);}}
function setItemsByType(type){var hidden_f=document.getElementById("article_assigned_"+type);var ids=new Array();var val = "";if(hidden_f!=null){val=$(hidden_f).val();if(val!=''){ids=getIdsArray(val);$(".drop_value").each(function(i){var item_type=$(this).attr("item-type");var item_id=parseFloat($(this).attr("val"));if(item_type==type){for(var j=0;j<ids.length;j++){if(item_id==ids[j]){changeSelection(this);}}} else {return true}});}}}


	

	