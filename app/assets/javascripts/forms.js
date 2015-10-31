
function initVideoForm(id)
{
    var wb = new waitbar("wait_video_check");
    var f = new myForm('video', null, "#" + id);
    var nFlag = false;
    var dFlag = false;
	f.contentField = f.formElement.find('#video_description');
	f.nameField = f.formElement.find('#video_name');
    f.submitButt = f.formElement.find("#"+id+"_button");
	f.contentFieldMaxLength = 400;
	f.contentFieldMinLength = 0;
	f.nameFieldMaxLength = 70;
	f.nameFieldMinLength = 0;
    f.longContentErr = 'Максимально допустимое количество знаков превышено на ';
    f.longNameErr = 'Максимально допустимое количество знаков превышено на ';
	nFlag = f.nameLengthCheck();
	cFlag = f.contentLengthCheck();
    f.nameField.keyup(function(){nFlag = f.nameLengthCheck(); f.switchSubmitBut(f.videoLinkFlag & nFlag & cFlag);});
    f.contentField.keyup(function(){cFlag = f.contentLengthCheck(); f.switchSubmitBut(f.videoLinkFlag & nFlag & cFlag);});
    f.videoLinkFlag = false;
    f.switchSubmitBut(f.videoLinkFlag & nFlag & cFlag);
    //console.log(f.switchSubmitBut.attr('class'));
    $("#video_link").change(function() {
                                        var e=this;
                                        wb.startInterval();
                                        $.ajax(
                                                {
                                                    url: "/videos/new.json",
                                                    dataType: "json",
                                                    type: "GET",
                                                    data: ({link: $(e).val()}),
                                                    error: function(XMLHttpRequest, textStatus, errorThrown){console.log(errorThrown);console.log(textStatus); wb.stopInterval();f.videoLinkFlag = false; f.switchSubmitBut(f.videoLinkFlag & nFlag & cFlag);},
                                                    success: function(data){
                                                                            if (data.link_html !== "" && data.link_html !== $(e).val())
                                                                                {
                                                                                    $("#video_preview").html(data.link_html);
                                                                                    $("#tError").empty();
                                                                                    f.videoLinkFlag = true;
                                                                                
                                                                                } else {$("#tError").html("Ccылка должна быть указана в формате \"youtube\", \"vk\", \"vimeo\"..."); f.videoLinkFlag = false;}
                                                                            console.log(data.link_html); wb.stopInterval();
                                                                            f.switchSubmitBut(f.videoLinkFlag & nFlag & cFlag);
                                                                           }
                                                }
                                              );//console.log("hello");
                                       });

}

function initReportForm(art_id, formName)
{
	var f;
	f = new myForm('article', art_id, formName);
	f.contentField = f.formElement.find('#article_content');
	f.nameField = f.formElement.find('#article_name');
	f.aButList = [1, 0];	
	f.getPhsToForm();
	f.photosUploader();
	f.contentFieldMaxLength = 150000;
	f.contentFieldMinLength = 150;
	f.parentElID = '#articleForm'; 
	f.shortContentErr = 'Минимально допустимое количество знаков статьи ' + f.contentFieldMinLength;
	f.longContentErr = 'Максимально допустимое количество знаков превышено на ';
	f.nameFieldMaxLength = 100;
	f.nameFieldMinLength = 1;
	f.shortNameErr = 'Название не должно быть пустым';
	f.longNameErr = 'Максимально допустимое количество знаков превышено на ';
	f.tEditor = new textEditor(f);
	f.initPanel();
	f.getBindingEntities();
	setInterval(function(){
							var nFlag, cFlag, iFlag;
							nFlag = f.nameLengthCheck();
							cFlag = f.contentLengthCheck();
							iFlag = f.imagesLengthCheck();
							if (nFlag && cFlag)
							{
								f.formElement.find('.butt').removeAttr('disabled');
							}else{f.formElement.find('.butt').attr('disabled', 'true');};
						  }, 300);
	//form.initForm();
}

function initDocumentForm(art_id, formName)
{
	var f;
	f = new myForm('article', art_id, formName);
	f.contentField = f.formElement.find('#article_content');
	f.nameField = f.formElement.find('#article_name');
	//f.aButList = [];	
	//f.getPhsToForm();
	//f.photosUploader();
	f.contentFieldMaxLength = 1000;
	f.parentElID = '#articleForm'; 
	f.shortContentErr = 'Минимально допустимое количество знаков ' + f.contentFieldMinLength;
	f.longContentErr = 'Максимально допустимое количество знаков превышено на ';
	f.nameFieldMaxLength = 100;
	f.nameFieldMinLength = 1;
	f.shortNameErr = 'Название не должно быть пустым';
	f.longNameErr = 'Максимально допустимое количество знаков превышено на ';
	f.tEditor = new textEditor(f);
	f.initPanel();
	setInterval(function(){
							var cFlag, iFlag;
							cFlag = f.contentLengthCheck();
							iFlag = f.imagesLengthCheck();
							if (cFlag)
							{
								f.formElement.find('.butt').removeAttr('disabled');
							}else{f.formElement.find('.butt').attr('disabled', 'true');};
						  }, 300);
	//form.initForm();
}
function initAccidentForm(art_id, formName)
{
	var f;
	f = new myForm('article', art_id, formName);
	f.contentField = f.formElement.find('#article_content');
	f.nameField = f.formElement.find('#article_name');
	//f.aButList = [];	
	f.getPhsToForm();
	f.photosUploader();
	f.contentFieldMaxLength = 150000;
	f.contentFieldMinLength = 75;
	f.parentElID = '#articleForm'; 
	f.shortContentErr = 'Минимально допустимое количество знаков статьи ' + f.contentFieldMinLength;
	f.longContentErr = 'Максимально допустимое количество знаков превышено на ';
	f.nameFieldMaxLength = 100;
	f.nameFieldMinLength = 1;
	f.shortNameErr = 'Название не должно быть пустым';
	f.longNameErr = 'Максимально допустимое количество знаков превышено на ';
	f.tEditor = new textEditor(f);
	f.initPanel();
	setInterval(function(){
							var cFlag, iFlag;
							cFlag = f.contentLengthCheck();
							iFlag = f.imagesLengthCheck();
							if (cFlag)
							{
								f.formElement.find('.butt').removeAttr('disabled');
							}else{f.formElement.find('.butt').attr('disabled', 'true');};
						  }, 300);
	//form.initForm();
}
function initThemeForm(th_id, formName)
{
	var form, minContentLength;
	minContentLength = 70;
	form = new myForm('theme', th_id, formName);
	form.contentField = form.formElement.find('#theme_content');
	form.nameField = form.formElement.find('#theme_name');
	form.curNameValue = $.trim(form.nameField.val());
	form.aButList = [0];
	form.tEditor = new textEditor(form);
	form.initPanel();
	form.getPhsToForm();
	form.photosUploader();
	form.contentFieldMaxLength = 150000;
	form.contentFieldMinLength = minContentLength;
	form.parentElID = '#articleForm'; 
	form.shortContentErr = 'Минимально допустимое количество знаков темы ' + form.contentFieldMinLength;
	form.longContentErr = 'Максимально допустимое количество знаков превышено на ';
	form.nameFieldMaxLength = 100;
	form.nameFieldMinLength = 1;
	form.shortNameErr = 'Название не должно быть пустым';
	form.longNameErr = 'Максимально допустимое количество знаков превышено на ';
	form.matchNameErr = 'Тема с таким названием уже существует...';
    form.submitButt.bind("mouseup", function(e){if(!form.submitButt.hasClass("disabled")) {form.formElement.append("<input type = 'hidden' name = 'theme[status_id]' value = '1' />")};});
	setInterval(function(){
							var nFlag, cFlag, iFlag;
							nFlag = form.nameLengthCheck();
							nFlag &= form.nameMatchesCheck();
							cFlag = form.contentLengthCheck(); 
							form.imagesLengthCheck();
							form.getLikebleNames();
							if (form.imagesLength>0){form.contentFieldMinLength = 0;}else{form.contentFieldMinLength = minContentLength; }
							if (nFlag && cFlag)
							{
								form.submitButt.removeClass('disabled');
							}else{form.submitButt.addClass('disabled');};
						  }, 300);
}
function initMessageForm(msg_id, formName, msgType)
{
	var f, formAnswer, minContentLength, curVisFrm, iFlag, cFlag, delImagesFlag;
	minContentLength = 3;
	f = new myForm(msgType, msg_id, formName);
	f.parentElID = '#newMsgForm';
    f.submitButt = f.formElement.find(formName.replace(".", "#") + "_" + msg_id + "_button");
    f.contentField = f.formElement.find('#message_content');
	f.longContentErr = 'Максимально допустимое количество знаков превышено на ';
    if (msgType == 'comment')
    {
        f.aButList = [0];
        f.contentFieldMaxLength = 10000;
        f.contentFieldMinLength = 3;
        f.shortContentErr = 'Комментарий не должен быть пустым';
        f.tEditor = new textEditor(f);
        f.initPanel();
    }else
    {
        f.aButList = [0, 2];
        f.contentFieldMaxLength = 150000;
        f.shortContentErr = 'Сообщение не должно быть пустым';
    	f.imagesMaxLength = 40;
    	f.imagesMaxLengthErr = 'Максимально допустимое количество фотографий для сообщения превышено на ';
        f.contentFieldMinLength = minContentLength;
    	f.curContentValue = f.contentField.val();
        f.tEditor = new textEditor(f);
    	f.initPanel();
    	f.photosUploader();
    	f.getPhsToForm();
    }
    f.curContentValue = f.contentField.val();
	f.submitButt.bind("mouseup", function(e){if(!f.submitButt.hasClass("disabled")) {f.formElement.append("<input type = 'hidden' name = 'message[status_id]' value = '1' />")};});
    checkAll();
    f.contentField.keyup(function(){checkAll();});
    f.formElement.mouseover(function(){checkAll();});

    function checkAll() {
                              iFlag = f.imagesLengthCheck();
                              
                              if (f.imagesLength>0) f.contentFieldMinLength = 0; else f.contentFieldMinLength = minContentLength;                        	
                              cFlag = f.contentLengthCheck();
                              f.switchSubmitBut(iFlag || cFlag);
                              console.log("{0} : {1}", cFlag, iFlag);
                          }                      
	$('a#answer_but').click(function() {
											var msgToId = $(this).attr('alt');
											if (f.formElement.find('#message_message_id').val() == undefined)
                                            {
                                                f.formElement.append('<input type="hidden" name = "message[message_id]" value = "'+msgToId+'"/>');
                                            }else
                                            {
                                                f.formElement.find('#message_message_id').val(msgToId);
                                            }
                                            f.formElement.find('#answr_to_str').html('<a id = "ans_link" class = "b_link_i" href = "#m_'+msgToId+'">ответ пользователю '+$('#m_'+msgToId).find('#u_name').text()+'</a>').show();
											f.formElement.find('#ans_link').click(function(){var c=$($(this).attr('href')).css('background-color'), n='blue';
											$($(this).attr('href')).find('.cWrapper').animate({opacity: 1.0}, 500 ).animate({opacity: 0.0}, 500 );});
                                            
									 });
}
function initAlbumForm(id, formName)
{
	var f;
	f = new myForm('photo_album', id, formName);
	f.contentField = f.formElement.find('#photo_album_description');
	f.nameField = f.formElement.find('#photo_album_name');
	f.contentFieldMaxLength = 1000;
	f.nameFieldMaxLength = 100;
	f.nameFieldMinLength = 5;
	f.shortNameErr = 'Название не должно быть короче ' + f.nameFieldMinLength + ' символов';
	f.longNameErr = 'Длина названия превышена на ';
	f.imagesMaxLength = 120;
	f.imagesMinLength = 3;
	f.imagesMaxLengthErr = 'Максимально допустимое количество фотографий альбома превышено на ';
	f.imagesMinLengthErr = 'В альбоме должно быть не менее '+f.imagesMinLength+' фотографий';
	f.matchNameErr = 'Фотоальбом с таким названием уже существует...';
	f.photosUploader();
	f.getPhsToForm();
	
	setInterval(function(){
							var nFlag, cFlag, iFlag;
							nFlag = f.nameLengthCheck();
							nFlag &= f.nameMatchesCheck();
							iFlag = f.imagesLengthCheck();
							cFlag = f.contentLengthCheck(); 
							f.getLikebleNames();
							if (nFlag && cFlag && iFlag)
							{
								f.formElement.find('.butt').removeAttr('disabled');
							}else{f.formElement.find('.butt').attr('disabled', 'true');};
						  }, 300);
}
function initEventForm(id, formName)
{
	var f;
	f = new myForm('event', id, formName);
    
	f.contentField = f.formElement.find('#event_content');
	f.nameField = f.formElement.find('#event_title');

	f.contentFieldMaxLength = 1000;
    f.contentFieldMinLength = 20;
	f.nameFieldMaxLength = 150;
	f.nameFieldMinLength = 5;
    f.tEditor = new textEditor(f);
    f.initPanel();
	f.shortNameErr = 'Заголовок не должен быть короче ' + f.nameFieldMinLength + ' символов';
	f.longNameErr = 'Длина заголовка превышена на ';
	f.shortContentErr = 'Содержимое новости не должно быть короче ' + f.contentFieldMinLength + ' символов';
	f.longContentErr = 'Длина содержимого новости превышена на ';
	f.imagesMaxLength = 20;
	f.imagesMinLength = 0;
	f.imagesMaxLengthErr = 'Максимально допустимое количество фотографий новости превышено на ';
	f.photosUploader();
	f.getPhsToForm();
	setInterval(function(){
							var nFlag, cFlag;
							nFlag = f.nameLengthCheck();
							cFlag = f.contentLengthCheck(); 
							if (nFlag && cFlag)
							{
								f.formElement.find('.butt').removeAttr('disabled');
							}else{f.formElement.find('.butt').attr('disabled', 'true');};
						  }, 300);
}
function initVoteForm(formName)
{
	f = new myForm('photo_album', null, formName);
	f.contentField = f.formElement.find('#vote_content');
	f.aButList = [0];
	f.contentFieldMaxLength = 500;
	f.contentFieldMinLength = 10;
	updVoteValuesFields();
	f.shortContentErr = 'Вопрос не должен быть короче ' + f.contentFieldMinLength + ' символов';
	f.longContentErr = 'Длина вопроса превышена на ';
	setInterval(function(){
							var cFlag, qFlag;
							cFlag = f.contentLengthCheck();
                            qFlag = voteValuesCheck();
							if (cFlag && qFlag)
							{
								f.formElement.find('.butt').removeAttr('disabled');
							}else{f.formElement.find('.butt').attr('disabled', 'true');};
						  }, 300);
    
	$('#addVoteValue').click(function(){
										var e, c;
										e = $("#vote_value_item").clone();
										e.find(':text').val('');
										$("#vote_values_table").append(e);
										updVoteValuesFields();
										bottomControl();
									   });
	
    function voteValuesCheck()
                                       {
                                        var variants = new Array();
                                        var uFlag = true;
                                        var notEmptyCounter = 0;
                                        var text1 = '';
                                        var text2 = '';
                                        var fail = '';
                                   		f.formElement.find('.vote_value_items').each(function(i, e){
                                   																	variants[variants.length] = $(e).find(":text").val();
                                   																   });
                                        for(var i=0; i<variants.length; i++)
                                        {
                                            text1 = $.trim(variants[i].toLowerCase());
                                            if(text1 != ''){notEmptyCounter++;}
                                            if((i < variants.length-1) && (uFlag == true) && (text1 != ''))
                                            {
                                                 for(var j=i+1; j<variants.length; j++)
                                                     {
                                                         text2 = $.trim(variants[j].toLowerCase());
                                                         if (text2 != '')
                                                         {
                                                             if(text1 == text2){uFlag = false; break;}
                                                         }
                                                     } 
                                            }
                                        }
                                        if (!uFlag){fail+='Варианты ответа должны быть уникальные...; ';}
                                        if (notEmptyCounter<2){fail+='Должно быть как минимум два варианта ответа...;'; uFlag = false;}
                                        $("#qLength").find("#txtErr").html(fail);
                                        return uFlag;
                                                                                            
                 
                                       }
    function updVoteValuesFields()
	{
		var l, els;
		els = f.formElement.find('.vote_value_items');
		l = els.length;
		f.formElement.find('.vote_value_items').each(function(i, e){
																	$(e).find(":text").attr('name', 'vote[added_vote_values]['+i+']').focus();
																	if (l>2)
																	{
																		$(e).find("#voteValDelBut").html("<a id = 'delItem' class = 'b_link pointer'>Удалить</a>");
																		$(e).find("#delItem").bind('click', function(){$(e).remove(); updVoteValuesFields();});
																	}else $(e).find("#voteValDelBut").empty();
																});
	}
    
    
	
}
function myForm(type, entityID, formName)
{
	this.type = type;
	this.entityID = entityID;
	this.formElement = $(formName);
    this.submitButt = null;
	this.tEditor = null;
	this.parentElID = 'none'; 
    this.classPrefix = 'fi-'
	this.nameList = ['paw', 'link', 'photo'];
	this.descList = ['Эмоции', 'Вложить альбомы и видео', 'Добавить фотографии'];
	this.aButList = []; //список используемых кнопок отражает номер кнопки в массивах descList и nameList
	//включение 
	//наименование
	this.nameField = null;
	this.nameFieldMaxLength = 0;
	this.nameFieldMinLength = 0;
	this.shortNameErr = '';
	this.longNameErr = '';
	this.matchNameErr = '';
	this.curNameValue = '';
	this.nameLengthCheck = function () 
										{
											var d, err ='', s, f = true;
											s = this.formElement.find('p#nLength');
                                            if (this.nameField.val() !== undefined)
                                            {
    											if (this.nameFieldMaxLength != 0 && this.nameField.val().length > this.nameFieldMaxLength)
    											{
    												d = this.nameField.val().length - this.nameFieldMaxLength;
    												err = this.longNameErr + d;
    												f = false;
    											}
    											if (this.nameFieldMinLength != 0 && this.nameField.val().length < this.nameFieldMinLength)
    											{
    												err = this.shortNameErr;
    												f = false;
    											}
    											s.find('#txtL').text(this.nameField.val().length +' из ' + this.nameFieldMaxLength);
											
    											s.find('#txtErr').text(err);
    											switchErr(s, f);
                                            }
											return f;
										};
	this.nameMatchesCheck = function() {
										var f=true, ent_id,s, err = '', el;
										el = this;
										ent_id = 'ent_'+this.entityID;
										s = this.formElement.find('p#nLength');
											this.formElement.find('div.likebleName').each(function(i){
																				if (this.id != ent_id)
																				{
																					if (el.curNameValue.toLowerCase() == ($(this).find('a').text()).toLowerCase())
																					{
																						$(this).css('background-color', '#f1c8c8'); 
																						f=false;
																						err = el.matchNameErr;
																					}else {$(this).css('background-color', 'none');}
																				}else {$(this).hide();}
																			  }
																 );
											s.find('#txtMatchesErr').text(err);	
										return f;	
									   };
	this.getLikebleNames = function() {
							var o;
							if (this.curNameValue != $.trim(this.nameField.val()))
							{
								if (this.type == 'theme')
								{
									o = new themeObj();
									o.topic = this.formElement.find('#theme_topic_id').val(); 
									o.name = this.nameField.val();
									make_themes_list(o);
									
								}else if(this.type == 'article')
								{
									//to do
								}else if(this.type == 'photo_album')
								{	
									var a = new albumObj();
									a.name = this.nameField.val();
									a.category = this.formElement.find('#photo_album_category_id').val();
									a.id = this.entityID;
									a.getAlbumNames();
								}
								this.curNameValue = this.nameField.val();
							}
						   }
	//наименование end
	//содержимое
	this.contentField = null;
	this.curBbFont = null;
	this.curBbAlign = null;
    this.videoLinkFlag = null;
	this.getAlignArray = function() 
	{
		var str = this.contentField.val();
		var names = this.tEditor.tAlignMenus;
		var arr = new Array();
        if (str !== undefined)
        {
    		for (var i=1; i< names.length; i++)
    		{
    			var c = 0; f=false;
    			for(var l=0; l<(this.contentFieldMaxLength/(names[i].length+2)); l++)
    			{
    				var b = new bbCodeObj(names[i], 'none');

    					b.sTagStart = str.indexOf(b.tagName().start, c);
					
    					if (b.sTagStart == -1 || (b.sTagStart == c && c > 0 ) || b.sTagStart == str.length)
    					{
    						break;
    					}else{
    							b.eTagStart = str.indexOf(b.tagName().end, b.sTagStart+b.eTagStart.length);
    							if  (b.eTagStart == -1 || (b.eTagStart == c && c > 0 )|| b.eTagStart == str.length)
    							{
    								break;
    							}else{
    									arr[arr.length] = b; 
									
    									c=b.eTagStart+b.tagName().end.length;
    								}
    						 }
    			}
    		}
        }
		
	}
	this.contentFieldMaxLength = 0;
	this.contentFieldMinLength = 0;
	this.shortContentErr = '';
	this.longContentErr = '';
	this.curContentValue = '';
	this.alterText = function()
	{
		if (this.tEditor != null)
								{
								if (this.tEditor.tArea !== undefined)
								{
									
									return this.tEditor.escapeBbText();	
								} 
								}
		return this.contentField.val();
	}
	this.contentLengthCheck = function () 
										{
											var d, err ='', s, f = true, str, maxTxtL;
											s = this.formElement.find('p#cLength');
											str = this.alterText();
											if (str !== undefined && this.contentField.val() !== undefined)
                                            {
                                                maxTxtL = this.contentFieldMaxLength - (this.contentField.val().length - str.length);
    											if (maxTxtL < 0) maxTxtL = 0; 
    											if (this.contentFieldMaxLength !== 0 && this.alterText().length > maxTxtL && maxTxtL > 0)
    											{
												
    												d = this.alterText().length - maxTxtL;
    												err = this.longContentErr + d;
    												f = false;
    											}
    											if (this.contentFieldMinLength !== 0 && this.alterText().length < this.contentFieldMinLength)
    											{
    												err = this.shortContentErr;
    												f = false;
    											}
    											s.find('#txtL').text(this.alterText().length +' из ' + maxTxtL);
    											s.find('#txtErr').text(err);
    											switchErr(s, f);
                                            }
                                            
											return f;
										};
	//содержимое end
	this.imagesField = '';
	this.imagesLength = 0;
	this.imagesMaxLength = 0;
	this.imagesMinLength = 0;
	this.imagesMaxLengthErr = '';
	this.imagesMinLengthErr = '';
    this.imagesLenghtFlag = false;
	this.imagesLengthCheck = function()	{
											var l = 0, lFlag, eFlag=true, err='', s;
											s = this.formElement.find('p#iLength');
											l = this.formElement.find('.tImage').length - this.formElement.find('.del-photo').length;
                                            //del = this.formElement.find('.del-photo').length;
											//this.imagesLength = l-del;
											if (l==0){lFlag=false;}
											else{lFlag=true;}
                                            this.imagesLength = l;
											if (this.imagesMaxLength != 0)
												{
													if (l>this.imagesMaxLength)
													{
														d = l-this.imagesMaxLength;
														err = this.imagesMaxLengthErr + d;
														eFlag=false;
													}
												}
												if (this.imagesMinLength != 0)
												{
													if (l<this.imagesMinLength)
													{
													err = this.imagesMinLengthErr;
													eFlag=false;
													}
												}
											switchErr(s, eFlag);
											s.find('#txtL').text('Фотографий добавлено: ' + l + ';');
											s.find('#txtErr').text(err);
                                            this.imagesLenghtFlag = lFlag&eFlag;
											return lFlag&&eFlag;
											}
											
									
	this.photosUploader = function() //добавление фотографий к сообщению
	{ 
		var link, ent_id, el, entity; 
		ent_id = this.entityID;
		if (this.parentElID == 'none'){el = this.formElement;}
		else {el = $(this.parentElID);}
		entity = this.type;
		link = '/'+entity+'s/' + ent_id + '/upload_photos?format=json'
		el.find('#ph_to_frm').empty();
		el.find('#ph_to_frm').dropzone(
									{ 
										url: link,
										acceptedFiles: "image/*",
										paramName: entity+"[uploaded_photos]",
										inputId: entity+"_uploaded_photos",
										/* forceFallback:true, */
                                        sending: function(file, xhr, formData) {
                                                // Pass token. You can use the same method to pass any other values as well such as a id to associate the image with for example.
                                                formData.append("authenticity_token", el.find("input[name='authenticity_token']").val()); // Laravel expect the token post value to be named _token by default
                                            },
										success: function(file, response){
																			var ph_id = response.photoID;
																			getUploadedPh(ph_id, el, file.previewElement, entity);
																			//updUploadedImageButtons(el.attr('id'));
																		 },
										fallback: function(){
																var v;
																v='<div class = "dz-message"><p class = "istring norm">'+this.options.dictFallbackMessage+'</p></div>';
																v+= '<p class = "istring norm">'+this.options.dictFallbackText+'</p><br />';
																$(el).find('#ph_to_frm').append(v);
																$(el).find('#ph_to_frm').append($('#'+this.options.inputId).clone());
															}
									}
								);
	}
	this.getBindingEntities = function() 
		{
			var link = "/" + this.type + "s/" + this.entityID + "/bind_videos_and_albums?format=json" 
			var arr_v = '';
			var arr_a = '';
			var el = this;
			arr_a = getIdsArray(this.formElement.find("#"+this.type+'_assigned_albums').val());
			arr_v = getIdsArray(this.formElement.find("#"+this.type+'_assigned_videos').val());
			$.getJSON(link, function(json)
			{
				var v = '';
				var a = '';
				var sv = '';
				var sa = '';
				
				$.each(json.albums, function(r, i)
				{
					var f = false;
					if (arr_a.length>0)
					{
						var newArr = new Array();
						for(var h=0; h<arr_a.length; h++)
						{
							if (arr_a[h] == i.id){f = true;}
							else {newArr[newArr.length] = arr_a[h];}
						}
						arr_a = newArr;
					}
					if (f)
					{
						sa += '<div class = "art-binding-ent-item to-unbind" b-type="albums"  ent-id = "'+i.id+'"><p>'+i.name+'</p></div>';
						f = false;
					}else 
					{
						a+='<div class = "art-binding-ent-item to-bind" b-type="albums"  ent-id = "'+i.id+'"><p>'+i.name+'</p></div>';
					}
				});
				$.each(json.videos, function(s, j)
				{
					var f = false;
					if (arr_v.length>0)
					{
						var newArr = new Array();
						for(var h=0; h<arr_v.length; h++)
						{
							if (arr_v[h] == j.id){f = true;}
							else {newArr[newArr.length] = arr_v[h];}
						}
						arr_v = newArr;
					}
					if (f)
					{
						sv += '<div class = "art-binding-ent-item to-bind" b-type="videos"  ent-id = "'+j.id+'"><p>'+j.name+'</p></div>';
						f = false;
					}
					else
					{
						v += '<div class = "art-binding-ent-item to-bind" b-type="videos"  ent-id = "'+j.id+'"><p>'+j.name+'</p></div>';
					}
				});
				$('#ab_albums').html(sa);
				$('#ab_videos').html(sv);
				$('#b_albums').html(a);
				$('#b_videos').html(v);
				updBindEntLists('albums', el);
				updBindEntLists('videos', el);
			});
		};
	function addItem(item, el)
	{
		var item = $(item);
		var tId = "#ab_" + item.attr('b-type');
		item.removeClass('to-bind');
		item.addClass('to-unbind');
		item.unbind('click');
		item.bind('click');
		item.prependTo(tId);
		return updBindEntLists(item.attr('b-type'), el);
	}
	function removeItem(item, el)
	{
		var item = $(item);
		var tId = "#b_" + item.attr('b-type');
		item.removeClass('to-unbind');
		item.addClass('to-bind');
		item.prependTo(tId);
		return updBindEntLists(item.attr('b-type'), el);
	}
	function updBindEntLists(t, fe)
	{
		var bId = "#ab_"+t;
		var ubId = "#b_"+t;
		var v = ''
		$(ubId + ' .art-binding-ent-item').each(function(i){var e=(i%2)?true:false;var o=(i%2)?false:true;$(this).toggleClass('odd',o);$(this).toggleClass('even',e);});
		$(bId + ' .art-binding-ent-item').each(function(j){var e=(j%2)?true:false;var o=(j%2)?false:true;$(this).toggleClass('odd',o);$(this).toggleClass('even',e);v+='['+$(this).attr('ent-id')+']';});
		$(ubId + ' .art-binding-ent-item').unbind('click');
		$(bId + ' .art-binding-ent-item').unbind('click');
		$(ubId + ' .art-binding-ent-item').bind('click', function(e){bindEntityOnclick(fe, this);});
		$(bId + ' .art-binding-ent-item').bind('click', function(e){unbindEntityOnclick(fe, this);});
		return v;
	}
	function bindEntityOnclick(fe, el)
	{
		var val = addItem(el, fe);
		var t = $(el).attr('b-type');
		fe.formElement.find("#"+fe.type+'_assigned_'+t).val(val); 
	}
	function unbindEntityOnclick(fe, el)
	{
		var val = removeItem(el, fe);
		var t = $(el).attr('b-type');
		fe.formElement.find("#"+fe.type+'_assigned_'+t).val(val); 
	}
	function getUploadedPh(phID, el, prEl, type)
	{
		$.getJSON("/photos/"+phID+"?format=json", function(t){
															if (t.id != 'null')
																{
																	$(prEl).remove();
																	$(el).find(".dz-message").show();
																	renderImgFrm(t, el, type);	
																}
															 }
				  ); 
	}
	function renderImgFrm(ph, el, type) //создаёт форму для фотографии
	{
		var imgTag, field, curHtml;
		if (ph.description == null){ph.description='Без описания...';}
		imgTag='<img src="'+ph.thumb+'">';
		field='<textarea cols="35" defaultrows="3" id="photo_editions_photos_photo_'+ph.id+'_description" name="photo_editions[photos][photo_'+ph.id+'][description]" onkeyup="changingTextarea(this)" rows="3"></textarea><br /><br /><a onclick="deletePhotoInTable(this)" photo_id="'+ph.id+'" class="b_link pointer">Удалить</a>';
		if (el.attr('id') != 'photosField' && type != 'photo_album')
		{
			field += ' <a onclick="addHashCodeToTextArea(this,\''+el.attr('id')+'\')"  class="b_link pointer addHashCode" hashCode="#Photo'+ph.id+'"  title = "Нажмите, чтобы встроить фото в текст...">Встроить в текст</a>';
		}
		curHtml = '<tbody class = "tImage" id="img_'+ph.id+'"><tr><td valign="top" align = "center"><input id="photo_editions_photos_photo_'+ph.id+'_id" name="photo_editions[photos][photo_'+ph.id+'][id]" type="hidden" value="'+ph.id+'">'+imgTag+'</td><td valign="top" >'+field+'</td></tr></tbody>';
		$(el).find("#uPhts").prepend(curHtml);
	}
	this.getPhsToForm = function(){
									var t = $(this.formElement).find("#uploadedPhotos"), el;
									el = this;
									$(t).load("/edit_photos #update_photos_form", { 'e': el.type, 'e_id': el.entityID, "hashToCont": "true", "submitBut": "false"}, function(){updUploadedImageButtons(el.formElement.attr('id'))}); 
								 }
	this.initPanel = function(){
							var buttons, menus, cur_addr, curMenuClass, i, curButClass, el; 
                            bindCoordetecter();
							menus = ''; 
							buttons = '<ul>';
							for (j=0; j<this.aButList.length; j++)
							{
								i = this.aButList[j]; 
								cur_addr=this.classPrefix + this.nameList[i]; 
								curButClass = ' hItem';
								curMenuClass = ' hMenu';
								buttons += '<li class = "mItem'+curButClass+'" title = "'+this.descList[i]+'" id = "'+this.nameList[i]+'">'+drawIcon(cur_addr, "fi-largest", "fi-grey")+'</li>';
								menus += '<div class = "mMenus'+curMenuClass+'" id = "'+this.nameList[i]+'Menu">'+menuContent(this.nameList[i], this)+'</div>';
								
							}
							
							buttons += '</ul>';
							$('td#formButtons').html(buttons);
							$('td#formMenus').html(menus); 
							el = this;
							if (this.tEditor !== null)
							{	
								this.tEditor = new textEditor(this);
								$('td#formButtons').append(this.tEditor.init());
								this.tEditor.initListeners();
								this.getAlignArray();
							}
							this.formElement.find('li.mItem').click(function(){updMenusList(this.id, el);});
							this.formElement.find('.smiles').click(function(e){updCurFormText($(this).attr('smilecode'), el);});
							this.contentField.keyup(function(){changingTextarea(el.contentField);});
							
						}
    this.switchSubmitBut = function(f) {
        		                if (f)
                            		{
                            			this.submitButt.removeClass('disabled');
                            		}else{this.submitButt.addClass('disabled');};
                                 }
	function menuContent(n, el){
								var val;
								if(n=='paw')
									{val='<div class = "central_field" style = "width: 90%;">'+drawSmiles()+'</div>';}
								else if(n=='binding')
									{
										val = '<table style = "width: 100%;"><tr><td><label>Вложенные альбомы</label><div class = "art-binding-ent-list" id = "ab_albums"></div></td><td><label>Вложенное видео</label><div class = "art-binding-ent-list" id = "ab_videos"></div></td></tr><tr><td style = "width: 50%; " ><br /><label>Доступные альбомы</label><br /><div class = "art-binding-ent-list" id = "b_albums"></div></td><td style = "width: 50%; "><br /><label>Доступные видео</label><br /><div class = "art-binding-ent-list" id = "b_videos"></div></td></tr></table>';
									}
                                    else if(n=='photo')
                                    {
                                        val = '<div class = "dropzone" id = "ph_to_frm"></div>';
                                    }
								return val;
							}
							
	function updMenusList(n, el)
	{
		var i;
		for(j=0;j<el.aButList.length;j++)
		{
			i= el.aButList[j]; 
			if(n==el.nameList[i])
			{
                if ($('li#'+el.nameList[i]).hasClass('sItem'))
                {
                    $('li#'+el.nameList[i]).find('i').addClass('fi-grey').removeClass('fi-blue');
                }else
                {
    				$('li#'+el.nameList[i]).find('i').addClass('fi-blue').removeClass('fi-grey');
                }
				$('li#'+el.nameList[i]).toggleClass('sItem').toggleClass('hItem');
                $('div#' + el.nameList[i] + 'Menu').toggleClass('sMenu').toggleClass('hMenu');

			}else{
					$('li#'+el.nameList[i]).addClass('hItem').removeClass('sItem');
					$('li#'+el.nameList[i]).find('i').addClass('fi-grey').removeClass('fi-blue');
					$('div#'+el.nameList[i]+'Menu').addClass('hMenu').removeClass('sMenu');
				}
		}
	}
	function drawSmiles(){var smilesCount=34,smilesPath='/smiles/',val='';for(i=1;i<(smilesCount+1);i++){val+='<img class = "smiles" src="'+smilesPath+i+'.gif" smilecode ="*sm'+i+'*">';}return val;}
	function smilesClick(e, el){updCurFormText($(e).attr('smilecode'), el);} 
	function updCurFormText(txt, el){
									 var i = el.contentField.getSelection().start + txt.length;
									 el.contentField.replaceSelection(txt);
									 el.contentField.keyup();el.contentField.setCurretPosition(i);
									}/* обновляет текст в текущей форме */
	function switchErr(el, sw)
		{
			el.toggleClass('norm', sw).toggleClass('err', !sw);
		}

}	
function changingTextarea(e){var v,cr,nr,r,c,dr,txt;r = $(e).attr('rows');c = $(e).attr('cols');dr = $(e).attr('defaultRows');cr = c*r;txt = $(e).val();v = entCounter(txt);nr = dr*1 + v + ((txt.length - v)/$(e).attr('cols')*0.9);$(e).attr('rows', nr);}
	
function addHashCodeToTextArea(e, id)
{var t='',ta;
	ta = $('#'+id).find('#message_content, #theme_content, #article_content, #event_content');
	t= $.trim(ta.val());
	if (t!==''){t = t+'\n'}
	ta.val(t+$(e).attr('hashCode'));
	//changingTextarea(ta);
	ta.focus();
}

//Поиск и встраивание целевой темы
function getTargetTheme() //используется в themes/split_themes
	{
		var selectTheme = $('#split_theme_theme_id');
		var targetPlace = $('#target_theme');
		var e_text = '<p class = "istring norm">Тема не выбрана</p>';
		initTargetTheme();
		selectTheme.change(function(){getTargetTheme($(this).val());});
		function initTargetTheme()
		{
			var d_val = selectTheme.val();
			if (d_val == '')
			{
				targetPlace.html(e_text);
			}
		}
		function getTargetTheme(id)
		{
			$("#target_theme").load("/themes/"+id+"?but=false #thBody");
		}
		
	}
function make_themes_list(th)
	{
		$.getJSON(th.getThemeQuery(), function(json){build_themes_list(json);});
	};
function build_themes_list(themes)
	{
		$("div#likebleNames, select#split_theme_theme_id").empty();
		$("div#split_theme_theme_id").html("<option value>Выберите тему из списка</option>");
		$.each(themes, function(i, theme){$("#split_theme_theme_id").append("<option value='" + theme.id + "'>" + theme.name + "</option>");$('div#likebleNames').append('<div class = "likebleName" id = "ent_'+theme.id+'" style = "width: 100%;position:relative;"><a title = "Открыть в новой вкладке" target = "_blank" href = "/themes/'+theme.id+'" class="b_link" style = "padding-left: 5px;">'+theme.name + '</a></div>');}); 
	};
function addScobes(a){var v= "";for(var i=0;i<a.length;i++){v+="["+a[i]+"]";};return v;};
function getIdsArray(val){var a = new Array();var j = 0;var v = "";if (val != ''){for(var i=0;i<val.length;i++){if(val[i]==']'){a[j]=v;v="";j++;}else if (val[i] != ']' && val[i] != '['){v += val[i];}}}return a;};
function update_ids_array(id_array,id){
                                        var id_int=parseFloat(id);
                                        var val=$.grep(id_array, function(n){return n == id_int});
                                        var array_size = id_array.length;
                                        var new_arr = new Array();
                                        if (val.length > 0)
                                            {
                                                new_arr = $.grep(id_array, function (n) {return n != id_int});
                                                return new_arr;
                                            }else{
                                                    id_array[array_size] = id_int; 
                                                    new_arr = id_array;
                                                    return new_arr;
                                                 }
                                             };
function deletePhotoInTable(delBut)
{
 var id = $(delBut).attr('photo_id');
 var m, t, a, n;
 m = '#message_deleted_photos';
 t = '#theme_deleted_photos';
 a = '#photo_album_deleted_photos';
 n = null;
 if ($(m).val() != undefined) n = m;
 else if ($(t).val() != undefined) n = t;
 else if ($(a).val() != undefined) n = a;
if (n != null)
 {
     var v = $(n).val();
     $(n).val(addScobes(update_ids_array(getIdsArray(v),id)));
     $(delBut).attr('onclick', 'recoveryPhotoInTable(this)');
     $(delBut).text('Восстановить');
     $('#img_'+id).find('.addHashCode').hide();
     $('#img_'+id).addClass('del-photo');
 }else
 {
     var v = confirm("Вы уверены что хотите удалить фото?");
 	if (v)
 	{
 		$.ajax({
 				type: 'DELETE',
 				url: '/photos/' + id,
 				success: function(data){alert(data.message);}
 				});
 		$("tbody#img_"+id).remove();

 	} 
 }
}
function recoveryPhotoInTable(but)
{
 var id = $(but).attr('photo_id');
 var m, t, a, n;
 m = '#message_deleted_photos';
 t = '#theme_deleted_photos';
 a = '#photo_album_deleted_photos';
 n = null;
 if ($(m).val() != undefined) n = m;
 else if ($(t).val() != undefined) n = t;
 else if ($(a).val() != undefined) n = a;
 if (n !== null)
 {
     var v = $(n).val();
     $(but).attr('onclick', 'deletePhotoInTable(this)');
     $(but).text('Удалить');
     $(n).val(addScobes(update_ids_array(getIdsArray(v),id)));
     $('#img_'+id).find('.addHashCode').show();
     $('#img_'+id).removeClass('del-photo');
 }

}
function themeObj()
	{
		th = new Object();
		th.name = 'none';
		th.topic = 'none';
		th.limit = 'none';
		th.getThemeQuery = function(){
									var getThemesList = "/get_themes_list?format=json", link='none';
								
									if (this.name != 'none' | this.topic != 'none' | this.limit != 'none')
									{
										link = getThemesList;
										if(this.name != 'none'){link=link+'&name='+this.name;}
										if(this.topic != 'none'){link=link+'&topic='+this.topic;}
										if(this.limit !='none'){link=link+'&limit='+this.limit;}
									}
									return link;
								  }
		return th;
	}
	
//Поиск и встраивание целевой темы end

function albumObj()
	{
		pa = new Object();
		pa.name = 'none';
		pa.category = 'none';
		pa.limit = 'none';
		pa.id = '';
		pa.hasNotMatches = true;
		pa.getAlbumQuery = function(){
									var getAlbumsList = "/get_albums_list?format=json", link='none';
								
									if (this.name != 'none' || this.category != 'none' || this.limit != 'none')
									{
										link = getAlbumsList;
										
										if(this.name != 'none'){link=link+'&name='+this.name;}
										if(this.category != 'none'){link=link+'&category_id='+this.category;}
										if(this.limit !='none'){link=link+'&limit='+this.limit;}
									}
									return link;
								  }
		
	pa.getAlbumNames = function()
		{

			$.getJSON(this.getAlbumQuery(), function(albums){var f=true;
															$('div#likebleNames').empty();
															$.each(albums, function(i, album){
															if (album.id != pa.id)
															{
																//if (album.name.toLowerCase() == pa.name) {f = false;}
																$('div#likebleNames').append('<div class = "likebleName" id = "ent_'+album.id+'" style = "width: 100%;position:relative;"><a title = "Открыть в новой вкладке" target = "_blank" href = "/photo_albums/'+album.id+'" class="b_link" style = "padding-left: 5px;">'+album.name + '</a></div>');
		
															}
															});													
															//pa.hasNotMatches = f;
														//	$('#test').text(pa.name + '; ' + pa.id + '; ' + pa.hasNotMatches +'; ');
														  });
		}
		return pa;
	}
function bbCodeObj(n, p) {
						this.name=n;
						this.params=p;
						this.sTagStart=0;
						this.eTagStart=0;
						this.tagsCollection = [{name: 'align-center', className: 'cnt-al-c'}, {name: 'align-right', className: 'cnt-al-r'}, {name: 'quote', className: 'cnt-quotes'}, {name: 'list-number', className: 'cnt-un-num'}];
						this.getContent = function(s)
						{
							if (this.sTagStart+1 == this.eTagStart)
							{
								return '';
							}else {
									return s.substring(this.sTagStart+this.tagName().start.length, this.eTagStart);
								  }
							
						} 
						this.tagName = function(){
													var p = (this.params == 'none') ? '':'='+this.params;
													var e = (this.name == 'list-number') ? '\n':''; 
													if (this.name == 'i') 
													{
														return {start: this.params +". ", end: ""};
													}
													else
													{
														return {start: (this.name == 'align-left') ? "":"["+this.name+p+"]" + e, end: (this.name == 'align-left') ? "": e + "[/"+this.name+"]"};};
													}
													
						this.initBb = function(a){
													var t;
													var cur = a.getCurAlignBbCode();											
													if (this.name != cur.name) 
														  {
															if (this.name != 'align-left' && cur.name != 'align-left')
															{
																if (cur.getContent(a.tArea.val()).length > 0)
																{
																cur.getContent(a.tArea.val()).length
																a.tArea.setCurretPosition(cur.eTagStart + cur.tagName().end.length);
																this.sTagStart = a.tArea.getSelection().start;
																this.eTagStart = a.tArea.getSelection().start + this.tagName().start.length;
																t = this.tagName().start+this.tagName().end;
																a.tArea.replaceSelection(t);
																a.tArea.setCurretPosition(this.eTagStart);																
																}else {
																		a.tArea.setCurretPosition(cur.sTagStart, cur.eTagStart + cur.tagName().end.length); 
																		t = this.tagName().start+this.tagName().end;
																		a.tArea.replaceSelection(t);
																		a.tArea.setCurretPosition(cur.sTagStart+this.tagName().start.length );																		
																		
																	  }
																
															} else if (this.name != 'align-left' && cur.name == 'align-left'){
																		this.sTagStart = a.tArea.getSelection().start;
																		this.eTagStart = a.tArea.getSelection().start + this.tagName().start.length;
																		t = this.tagName().start+this.tagName().end;
																		a.tArea.replaceSelection(t);
																		a.tArea.setCurretPosition(this.sTagStart+this.tagName().start.length );
																	  }
															 else if (this.name == 'align-left' && cur.name != 'align-left'){
																		if (cur.getContent(a.tArea.val()).length > 0)
																		{
																			a.tArea.setCurretPosition(cur.eTagStart + cur.tagName().end.length);
																		}else {
																				a.tArea.setCurretPosition(cur.sTagStart, cur.eTagStart + cur.tagName().end.length); 
																				a.tArea.replaceSelection('');
																				a.tArea.setCurretPosition(cur.sTagStart);
																			  }
																		
																	  }
															if (this.name == 'list-number')
																		{
																			var nItem = new bbCodeObj('i', '1');
																			nItem.initTBb(a);
																		}
														  }else{a.tArea.setCurretPosition(a.tArea.getSelection().start);}

												  }
						this.initTBb = function(a)
						{
							var t;
							this.sTagStart = a.tArea.getSelection().start;
							this.eTagStart = a.tArea.getSelection().start + this.tagName().start.length;
							t = this.tagName().start+this.tagName().end;
							a.tArea.replaceSelection(t);
							a.tArea.setCurretPosition(this.sTagStart+this.tagName().start.length );
						};
						this.getClassName = function() 
						{
							for (var i=0; i<this.tagsCollection.length; i++)
							{
								if (this.tagsCollection[i].name == this.name) return this.tagsCollection[i].className; 
							}
							return 'none';
						}
						
						this.getTagFromStr = function(str)
						{
							var s, e;
							if (str != null && str != undefined)
							{
								if ($.trim(str).length>0)
								{
									s = str.indexOf(this.tagName().start, 0);
									if (s > -1)
									{
										e = str.indexOf(this.tagName().end, s);
										if  (e > -1)
										{
											return {start: s, end: e};
										}
									}	 
								}
							}
							return {start: -1, end: -1};
							
						}
					 } 
function textEditor(el)
	{
		this.formElement = el.formElement;
		this.tArea = el.contentField;
        this.el = el;
		this.imgAddr = 'fi-';
		this.tAlignMenus = ['align-left', 'align-center', 'align-right', 'quote', 'list-number'];
		this.tAlignMenusDescription = ['Выравнивание по левому краю', 'Выравнивание по центру', 'Выравнивание по правому краю', 'Цитирование', 'Нумерованный список'];
		this.curFormat = 'none';
        this.editorPreview = document.getElementById('editorPreview');
		this.init = function(){     var t = initAPanel(this);
                                    t = (this.editorPreview == null)? t:t+'<li id = "updTextPrewiew" title = "Обновить поле предварительного просмотра">'+drawIcon("fi-refresh", "fi-largest", "fi-grey")+'</li>';
                                    return t;
                              };
		this.initListeners = function() {
											var el;
											el = this;
											this.formElement.find('#updTextPrewiew').click(function(){el.drawCode(); el.tArea.setCurretPosition(el.tArea.getSelection().start);});
											this.formElement.find('.alItem').click(function(){
																								for(var i=0; i<el.tAlignMenus.length; i++ )
																								{
																								if(this.id==el.tAlignMenus[i])
																								{
																									var bb = new bbCodeObj(el.tAlignMenus[i], 'none');
																									bb.initBb(el);
																									$('li#'+el.tAlignMenus[i]).addClass('sItem').removeClass('hItem');
                                                                                                    switchClasses("fi-blue", "fi-grey", $('li#'+el.tAlignMenus[i]).find('i'));

																									
																								}
																								else{
																										$('li#'+el.tAlignMenus[i]).addClass('hItem').removeClass('sItem');
																										switchClasses("fi-grey", "fi-blue", $('li#'+el.tAlignMenus[i]).find('i'));
                                                                                
																									}
																								}
																							  });
											this.tArea.keyup(function(e){
																			var c = updateAlignMenu(el);
																			if (c.name == 'list-number')
																			{
																				if (e.keyCode == 13)
																				{
																					el.addNextNumItem(c);
																				}
																			}
																	   });
											this.tArea.click(function(){updateAlignMenu(el);});
											//this.tArea.focus(function(){updateAlignMenu(el);});
										}
		this.addNextNumItem = function(c)
		{
			var s=c.getContent(this.tArea.val());
			var v;
			var re = /^\d+\.\s(.*)\n/gm;
			var newStr = '';
			var nItem = new bbCodeObj('i', '1');
			var j=0;
			if ($.trim(s).length > 0)
			{
				v = s.match(re);
				if (v.length>0)
				{
					for(var i=0;i<v.length;i++)
					{
						j = i+1;
						newStr += v[i].replace(/\d+\.\s/, j+". ");
					}
					this.tArea.setCurretPosition(c.sTagStart + c.tagName().start.length, c.eTagStart);
					this.tArea.replaceSelection(newStr);
					this.tArea.setCurretPosition(c.sTagStart + c.tagName().start.length + newStr.length);
				}
			}
			nItem.params = j+1;
			nItem.initTBb(this);
			
		}
		
		this.getCurAlignBbCode = function()
		{
			var str = this.tArea.val();
			var names = this.tAlignMenus;
			var b = new bbCodeObj('align-left', 'none');
			var j = 0;
            if (str !== undefined)
            {
    			for (var i=1; i<names.length; i++)
    			{
    				var c = 0;
    				b.name = names[i];
    				do
    				{
    						b.sTagStart = str.indexOf(b.tagName().start, c);
    						if (b.sTagStart == -1 )
    						{
    							break;
    						}else{	
    								b.eTagStart = str.indexOf(b.tagName().end, b.sTagStart);
    								if  (b.eTagStart == -1)
    								{
    									break;
    								}else{
										
    										if (this.tArea.getSelection().start > b.sTagStart && this.tArea.getSelection().end < b.eTagStart + b.tagName().end.length)
    										{
    											return b;
    										}else{c=b.eTagStart+b.tagName().end.length;}
    									 }
    							 }
    						j++;
    				}while(j<str.length);
    			}
    			b.name = 'align-left';
    			b.sTagStart = str.length;
    			b.eTagStart = str.length;
                
            }
	        return b;
			
		}
		this.escapeBbText = function()
		{
			var str=$.trim(this.tArea.val());
			var names = this.tAlignMenus;
			if (str.length > 0)
			{
				for(var i=1; i< names.length; i++)
				{
					str = str.replace(new RegExp("\\["+names[i]+"\\]",'g'), '');
					str = str.replace(new RegExp("\\[/"+names[i]+"\\]",'g'), '');
				}
				str = str.replace(new RegExp("\n",'g'), '');
				//str = str.replace(new RegExp("\\[\\]",'g'), '');
			}
			return str;	
		}
		this.drawCode = function()
		{
            var t = (this.el.type == "comment")? "message":this.el.type; //необходимо для того чтобы обновлять комметарии
            var url = "/"+t+"s/"+this.el.entityID;
            var arr = '';
            arr = this.formElement.serialize();
            $("#test").text(url + "?preview_mode=true #" + t[0] + "_" + el.entityID);
            $.ajax(
                    {
                        url: url,
                        dataType: "json",
                        type: "POST",
                        data: arr,
                        error: function(x, y, z){console.log(x)},
                        success: function(data){$("#editorPreview").load(url + "?preview_mode=true #" + t[0] + "_" + el.entityID);}
                    }
                  );

		}
		function initAPanel(e) //инициализация панели отступов
		{
			var v = '', cBCl, nImg, sImg,cImg;
			var curBbAlign = e.getCurAlignBbCode();
			for(var i=0; i<e.tAlignMenus.length; i++)
			{
				cBCl = (curBbAlign.name == e.tAlignMenus[i]) ? "sItem":"hItem";
				cImg = (curBbAlign.name == e.tAlignMenus[i]) ? 'fi-blue':'fi-grey';
				nImg = e.imgAddr+e.tAlignMenus[i];
                sImg = "fi-largest";
				v += '<li class = "alItem '+cBCl+'" title = "'+e.tAlignMenusDescription[i]+'" id = "'+e.tAlignMenus[i]+'">'+drawIcon(nImg, sImg, cImg)+'</li>';
			}
			return v;
		}
		function updateAlignMenu(el)
		{
			var c = el.getCurAlignBbCode();
			for(var i=0; i<el.tAlignMenus.length; i++ )
			{
			if(c.name==el.tAlignMenus[i])
			{
				$('li#'+el.tAlignMenus[i]).addClass('sItem').removeClass('hItem');
                switchClasses("fi-blue", "fi-grey", $('li#'+el.tAlignMenus[i]).find('i'));
			}
			else{
					$('li#'+el.tAlignMenus[i]).addClass('hItem').removeClass('sItem');
					switchClasses("fi-grey", "fi-blue", $('li#'+el.tAlignMenus[i]).find('i'));
				}
			}
			return c;
		}
		
	}

function drawIcon(n, s, c)
    {
        return "<i class = \""+n+" "+s+" "+c+"\"></i>";
    }
function switchClasses(cOn, cOff, e)
    {
        if (e.hasClass(cOff)) e.removeClass(cOff);
        if (!e.hasClass(cOn)) e.addClass(cOn);
    }

function bindCoordetecter() //поиск координат курсора в текстовом поле
{
    (function() {

    	var fieldSelection = {

    		getSelection: function() {

    			var e = (this.jquery) ? this[0] : this;

    			return (

    				/* mozilla / dom 3.0 */
    				('selectionStart' in e && function() {
    					var l = e.selectionEnd - e.selectionStart;
    					return { start: e.selectionStart, end: e.selectionEnd, length: l, text: e.value.substr(e.selectionStart, l) };
    				}) ||

    				/* exploder */
    				(document.selection && function() {

    					e.focus();

    					var r = document.selection.createRange();
    					if (r === null) {
    						return { start: 0, end: e.value.length, length: 0 }
    					}

    					var re = e.createTextRange();
    					var rc = re.duplicate();
    					re.moveToBookmark(r.getBookmark());
    					rc.setEndPoint('EndToStart', re);

    					return { start: rc.text.length, end: rc.text.length + r.text.length, length: r.text.length, text: r.text };
    				}) ||

    				/* browser not supported */
    				function() { return null; }

    			)();

    		},

    		replaceSelection: function() {

    			var e = (this.jquery) ? this[0] : this;
    			var text = arguments[0] || '';

    			return (

    				/* mozilla / dom 3.0 */
    				('selectionStart' in e && function() {
    					e.value = e.value.substr(0, e.selectionStart) + text + e.value.substr(e.selectionEnd, e.value.length);
    					return this;
    				}) ||

    				/* exploder */
    				(document.selection && function() {
    					e.focus();
    					document.selection.createRange().text = text;
    					return this;
    				}) ||

    				/* browser not supported */
    				function() {
    					e.value += text;
    					return jQuery(e);
    				}

    			)();

    		},
    		setCurretPosition: function(start, end) {
    														if(!end) end = start; 
    														return this.each(function() {
    																						if (this.setSelectionRange) {
    																							this.focus();
    																							this.setSelectionRange(start, end);
    																						} else if (this.createTextRange) {
    																															var range = this.createTextRange();
    																															range.collapse(true);
    																															range.moveEnd('character', end);
    																															range.moveStart('character', start);
    																															range.select();
    																														 }
    																					}
    																		);
    												}

    	};

    	jQuery.each(fieldSelection, function(i) { jQuery.fn[i] = this; });

    })();
}
//votes

//votes end