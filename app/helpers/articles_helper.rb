module ArticlesHelper
	def article_show_block
			html = "   
           <table style = 'width: 100%;'>
						<tr>
							<td align='left' valign='middle'>
								#{articleInformation(@article)}
							</td>
							<td align = 'right' valign='middle'>
								<p class = 'istring_m norm medium-opacity'>Размещён #{@article.alter_date.strftime("%d.%m.%Y")}</p>
							</td>
						</tr>
						<tr>
							<td align = 'left' valign='middle' style = 'height:30px;'>
								<p class = 'istring_m norm medium-opacity'>
									Автор #{link_to @article.user.name, @article.user, :class => 'b_link_i'}
								</p>
								<p class = 'istring_m norm medium-opacity'>
									Категория #{link_to @article.type[:multiple_name], articles_path(:c => @article.type[:link]), :class => 'b_link_i'}
								</p>
							</td>
							<td align = 'right' valign='middle'>
								
							</td>
						</tr>
						<tr>
							<td colspan = '2' align = 'left' valign='top'>
									<span id = 'content' class = 'mText'>#{@article.content_html}</span>
							</td>
						</tr>
						<tr>
							<td colspan = '2'>
								#{article_list_photos(@article)}
                #{"<br />#{list_attachments(@article.attachment_files)}" if @article.attachment_files != []}
							</td>
						</tr>
				   </table>
				  "
		p = {
				:tContent => html, 
				:idLvl_2 => "b_middle",
				:parity => 0
			}
		return c_box_block(p).html_safe
	end
	def top_article_buttons
		buttons = [
                {:name => 'К списку материалов', :access => true, :type => 'arrow-right', :link => "/media?t=#{@article.type[:link]}"},
                {:name => 'К материалам пользователя', :access => true, :type => 'arrow-right', :link => "/users/#{@article.user_id}/articles"},
				        {:name => 'Редактировать', :access => userCanEditArtilcle?(@article), :type => 'pencil', :link => edit_article_path(@article, :v => @article.article_type_id)},
                {:name => 'Удалить', :access => userCanDeleteArticle(@article), :type => 'trash', :link => article_path(@article), :data_method => 'delete', :rel => 'no-follow', :data_confirm => 'Вы уверены, что хотите удалить данный материал?'}
                	
				      ]
		return "<div class = 'c_box'><div class = 'm_1000wh'>#{control_buttons(buttons)}</div></div>"
	end
#	def top_article_buttons
#		buttons = []
#		return control_buttons(buttons)
#	end
	def articleInformation(article)
		''
	end
	def articles_path_buttons
		art = Article.new
		buttons = []
		v_status_id = 1 if is_not_authorized?
		v_status_id = [1,2] if !is_not_authorized?
    link = (@user == nil)? articles_path: "\/users\/#{@user.id}\/articles"
		art.types.each do |t|
			articles = Article.where(article_type_id: t[:value], status_id: 1, visibility_status_id: v_status_id)
			but = {:name => "#{t[:multiple_name]} [#{articles.count}]", :access => true, :type => 'b_grey', :link => "#{link}?c=#{t[:link]}"}
			but[:selected] = true if t == @curArtCat
			buttons[buttons.length] = but
		end
		return buttons_in_line(buttons)
	end
	def article_type_part(type)
		articles = Article.where(article_type_id: type[:value]).limit(3)
		articles_block = '<p class = "istring">В данной категории ничего нет...</p>'
		part = ''
		if articles != []
			articles_block = '<table id = "article_table"  class = "v_table">'
			if type[:value] != 2
				articles_block += "<tr>
										<th> 
											Название
										</th>
										<th> 
											Разместил
										</th>
										<th> 
											Дата размещения
										</th>
								  </tr>"
				articles.each do |article|
					articles_block += "
										<tbody class = 't_link' link_to = '#{article_path(article)}'>
											<tr>
												<td class = 't_name'> 
													#{article.alter_name}
												</td>
												<td class = 'usr'> 
													#{article.user.name}
												</td>
												<td class = 'date'> 
													#{article.created_at.strftime("%d.%m.%Y")}
												</td>
											</tr>
										</tbody>
										"
				end	
			else
				articles.each do |article|
				articles_block += "<tr>
										<th> 
											Название
										</th>
										<th> 
											Разместил
										</th>
										<th> 
											Размер
										</th>
										<th> 
											Дата размещения
										</th>
								  </tr>"
				  articles_block += "
										<tbody class = 't_link' link_to = '#{article_path(article)}'>
											<tr>
												<td class = 't_name'> 
													#{article.alter_name}
												</td>
												<td class = 'usr'> 
													#{article.user.name}
												</td>
												<td>
													#{article.attachment_files.first.alter_size}
												</td>
												<td class = 'date'> 
													#{article.created_at.strftime("%d.%m.%Y")}
												</td>
											</tr>
										</tbody>
									"
				end
			end
			
			articles_block += '</table>'
		end	
			
			part = "
					<div class = 'c_box'>
						<div class = 'central_field' style = 'width: 98%;'>#{link_to type[:multiple_name], type[:link], :class => 'b_link_bold'}</div>
					
						<div class = 'central_field' style = 'width: 98%;'>
								#{articles_block}
							<br />
						</div>
					</div>
				   "

		return part.html_safe
	end
	
	def table_header(type)
		case type
		when 1 #Лётные происшествия
		when 2 #Документ
		when 3 #Отчёт
		when 4 #Статья
		when 5 #Отзыв
		when 6 #Восставшие из руин
		end
	end
	def article_block(article)
			    "
					<tbody class = 't_link' link_to = '#{article_path(article)}'>
						<tr>
							<td class = 't_name'> 
								#{article.alter_name}
							</td>
							<td class = 'usr'> 
								#{article.user.name}
							</td>
							<td class = 'date'> 
								#{article.created_at.strftime("%d.%m.%Y")}
							</td>
						</tr>
					</tbody>
				"
	end
	def report_block(article)

		value = "
	
							#{article.user.name}<hr />
							#{image_tag article.photos.first.link.thumb if article.photos != []}
							#{truncate(article.content, :length => 600)}

				"
	end
	def document_block(article)
		body = ''
		if article.attachment_files != []
			links = list_attachments(article.attachment_files)
			body = "
						<p>#{article.name}</p>
			"
		end
		return body
	end
	
	def no_articles
	case @type[:value]
	when 1
		return "Нет ни одного отчёта о лётных происшествиях"
	when 2
		return "Нет ни одного документа"
	when 3
		return "Нет ни одного отчёта"
	when 5
		return "Нет ни одного отзыва"
	else
		return "Нет ни одной статьи"
	end
	end
	
	def new_article_button
		buttons = [
			          {:name => "Добавить #{@curArtCat[:add_but_name]}", :access => userCanCreateArticle?, :type => 'plus', :link => new_article_path(:c => @curArtCat[:value])}
				      ]
		return control_buttons(buttons)
	end
  def new_article_button(type) #для страницы media
    {:name => "Добавить #{type[:add_but_name]}", :access => userCanCreateArticle?, :type => 'plus', :link => new_article_path(:c => type[:value])}
  end
	def article_errors
		@content_error = ''
		@content_f_color = ''
		@name_error = ''
		@name_f_color = ''
		@attachment_files_error = ''
		@attachment_files_f_color = ''
		if @formArticle.errors[:content] != [] and @formArticle.errors[:content] != nil
			@content_f_color = "err"
			@formArticle.errors[:content].each do |err|
				@content_error += "#{err}; <br />"
			end
		end
		if @formArticle.errors[:attachment_files] != [] and @formArticle.errors[:attachment_files] != nil
			@attachment_files_f_color = "err"
			@formArticle.errors[:attachment_files].each do |err|
				@attachment_files_error += "#{err}; <br />"
			end
		end
		if @formArticle.errors[:name] != [] and @formArticle.errors[:name] != nil
			@name_f_color = "err"
			@formArticle.errors[:name].each do |err|
				@name_error += "#{err}; <br />"
			end
		end
	end
	
	def article_albums_block(i)
		albums = ''
		if @article.photo_albums != []
			albums = '<div class = "cBoxSplitter"><div class = "m_1000wh"><h3>Вложенные альбомы</h3></div></div>'
			@article.photo_albums.each do |album|
				if album.photos != []
					albums += "#{album_index_block(album, i, "index")}"
					i += 1
				end
			end
		end
		return albums.html_safe
	end
	
	def article_videos_block(i)
		videos = ''
		if @article.videos != []
			@article.videos.each do |video|
				videos += "#{video_index_block(video)}"
			end
			videos = "<div>#{videos}</div>"
			p = {
				:tContent => videos, 
				:idLvl_1 => "b_middle",
				:parity => i
			}
			videos = "<div class = 'cBoxSplitter'><div class = 'm_1000wh'><h3>Вложенные видео</h3></div></div>#{c_box_block(p)}"
		end
		return videos.html_safe
	end
	
	def light_box_article_photo_block(photo, link, style)
		"
			<a data-lightbox='article_#{ @article.id.to_s }' href = '#{ photo.link }' title = '#{photo.description}' ><img src = '#{link}' #{style} class = 'album_thumb_photo'/></a>
			
		"#<span id = 'album_#{ photo.photo_album.id.to_s }_#{i}' style = 'display: none;'><a class = 'b_link' href = '#{photo_path(photo)}'>Комментарии</a></span>
	end
	
  def article_types_list(form_name = 'article', t = {} , el_name = 'article_type_id')
    art = Article.new
    return my_collection_select(art.types, el_name, form_name, t, 'Выберите тип статьи из списка').html_safe
  end
end
