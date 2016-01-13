module PagesHelper
#parallaxFunctions

def parallaxItems
	[
		#{:id => 'pBlock_1', :actioClass => 'pB-top-to-bot', :bg_img => false, :html => parralaxItem_1, :style=>'height: 300px;background-color: green;'},
		{:id => 'pBlock_2', :actioClass => 'pB-top-to-bot', :bg_img => true, :html => parralaxItem_2, :style=>'height: 300px; background-color: black;', :speed => '1.3', :startPosition => 'out', :backgroundStyle => 'background-image: url("/parallax_imgs/pBlock_1.jpg"); height:800px;'},
		{:id => 'pBlock_3', :actioClass => 'pB-bot-to-top', :bg_img => false, :html => parralaxItem_3, :style=>'height: 250px; background-color: black;', :speed => '1.0', :startPosition => 'over', :backgroundStyle => 'background-image: url("/parallax_imgs/pBlock_2.jpg"); height:650px;'},
		{:id => 'pBlock_4', :bg_img => false, :html => parralaxItem_4, :style=>'height: 450px; background-color: grey;'},
		{:id => 'pBlock_5', :actioClass => 'pB-top-to-bot', :bg_img => true, :html => parralaxItem_5, :style=>'height: 400px; background-color: #3084c9;', :speed => '1.0', :startPosition => 'out', :backgroundStyle => 'background-image: url("/parallax_imgs/pBlock_3.jpg"); height:2200px;'},
		{:id => 'pBlock_6', :bg_img => false, :html => parralaxItem_6, :style=>'height: 370px; background-color: black;', :backgroundStyle => 'background-image: url("/parallax_imgs/pBlock_6.jpg"); height:1000px;'}
	]
end

def parralaxItem_1
	"
		<div class = 'central_field' style = 'width: 500px; height: 100%;'>
			<table style = 'width: 100%; height: 100%; color: white; font-size: 36pt;'>
				<tr>
					<td align = 'center' valign = 'middle'>
						Сущность №1
					</td>
				</tr>
			</table>
		</div>
	"
end

def parralaxItem_2
	"
		<div class = 'central_field' style = 'width: 500px; height: 100%;'>
			<table style = 'width: 100%; height: 100%; color: white; font-size: 36pt;'>
				<tr>
					<td align = 'center' valign = 'middle'>
						Сущность №2
					</td>
				</tr>
			</table>
		</div>
	"
end

def parralaxItem_3
	"
		<div class = 'central_field' style = 'width: 500px; height: 100%;'>
			<table style = 'width: 100%; height: 100%; color: white; font-size: 36pt;'>
				<tr>
					<td align = 'center' valign = 'middle'>
						Сущность №3
					</td>
				</tr>
			</table>
		</div>
	"
end

def parralaxItem_4
	"
		<div class = 'central_field' style = 'width: 500px; height: 100%;'>
			<table style = 'width: 100%; height: 100%; color: white; font-size: 36pt;'>
				<tr>
					<td align = 'center' valign = 'middle'>
						Сущность №4
					</td>
				</tr>
			</table>
		</div>
	"
end
def parralaxItem_5
	"
		<div class = 'central_field' style = 'width: 500px; height: 100%;'>
			<table style = 'width: 100%; height: 100%; color: white; font-size: 36pt;'>
				<tr>
					<td align = 'center' valign = 'middle'>
						Сущность №5
					</td>
				</tr>
			</table>
		</div>
	"
end
def parralaxItem_6
	"
		<div class = 'central_field' style = 'width: 500px; height: 100%;'>
			<table style = 'width: 100%; height: 100%; color: white; font-size: 36pt;'>
				<tr>
					<td align = 'center' valign = 'middle'>
						Сущность №6
					</td>
				</tr>
			</table>
		</div>
	"
end
#parallaxFunctions end
#feed functions-----------------------------------------------------------------------------------------------------
	def feed_parts
		[
		#	{:en_name => 'answers', :ru_name => 'Ответы', :description => 'Ответы на сообщения и комментарии', :path => '/feed?part=answers'},
      {:en_name => 'themes', :ru_name => 'Темы', :description => 'Новые темы в интересующих разделах', :path => '/feed?part=themes'},
      {:en_name => 'messages', :ru_name => 'Сообщения', :description => 'Новые сообщения в отслеживаемых разделах', :path => '/feed?part=messages'},
			{:en_name => 'comments', :ru_name => 'Комментарии', :description => 'Комментарии к фото и видео', :path => '/feed?part=comments'},
			{:en_name => 'videos', :ru_name => 'Видео', :description => 'Новые видео', :path => '/feed?part=videos'},
			{:en_name => 'albums', :ru_name => 'Фотоальбомы', :description => 'Новые альбомы и обновления в альбомах', :path => '/feed?part=albums'},
			{:en_name => 'articles', :ru_name => 'Материалы', :description => 'Новые статьи', :path => '/feed?part=articles'}
			
		]
	end
	def default_part
		feed_parts.first
	end
	def current_feed_part
		val = default_part
		feed_parts.each do |part|
			val = part if params[:part] == part[:en_name]
		end
		return val
	end
	
	def feed_nav_buttons
	    buttons = []
		feed_parts.each do |part|
			s = true if part == current_feed_part
			s = false if part != current_feed_part
			buttons[buttons.length] = {:name => part[:ru_name], :access => true, :selected => s, :link => part[:path]} 
		end
		return buttons_in_line_b(buttons).html_safe
	end
	
	def feed_part_name
		current_feed_part[:ru_name]
	end
	def feed_blocks
		case current_feed_part[:en_name]
		when 'videos'
			make_entities_for_videos_part
		when 'albums'
			make_entities_for_album_part
		when 'themes'
			make_entities_for_theme_part
		when 'messages'
			make_entities_for_message_part
		when 'answers'
			make_entities_for_answer_part
		when 'articles'
			make_entities_for_article_part
		when 'comments'
			make_entities_for_comments_part
		end
	end
	def make_entities_for_theme_part #
		result_arr = []
		topicsNtfs = current_user.topic_notifications.select(:topic_id)
		if topicsNtfs != []
			v_status_id = 1 if is_not_authorized?
			v_status_id = [1,2] if !is_not_authorized?
			themes = Theme.where(status_id: [1,3], visibility_status_id: v_status_id, topic_id: topicsNtfs).order('created_at DESC').where.not(user_id: current_user.id).limit(30)
			if themes != []
				themes.each do |theme|
					last_message = theme.last_message
					date_for_sort = theme.created_at
					result_arr[result_arr.length] = [date_for_sort, theme]
				end
				result_arr.sort!{|a,b|b<=>a}
			end
		end
		return result_arr
	end
	def make_entities_for_message_part
		result_arr = []
    messages = Message.where(theme_id: current_user.theme_notifications.select(:theme_id), status_id: 1).order('created_at DESC').where.not(user_id: current_user.id).limit(50)
    if messages != []
			messages.each do |message|
				result_arr[result_arr.length] = [message.created_at, message]
			end
      result_arr.sort!{|a,b|b<=>a}
    end
    return result_arr
	end
	def make_entities_for_answer_part
		result_arr = []
			messages = current_user.answerMessages(is_not_authorized?)
			if messages != []
				messages.each do |message|
					result_arr[result_arr.length] = [message.created_at, message]
				end
				result_arr.sort!{|a,b|b<=>a}
			end
		return result_arr 
	end
	
	def make_entities_for_album_part
		result_arr = []
			albums = PhotoAlbum.all
			if albums != []
				albums.each do |album|
					album_photos = album.photos(:order => 'created_at ASC')
					if album_photos != []
						date = album.created_at + 1.days
						entity_date = album_photos.first.created_at
						alb_photos = []
						alb_photos_count = 0
						album_photos.each do |photo|
							if photo == album_photos.last
								if date >= photo.created_at
									alb_photos[alb_photos.length] = photo if alb_photos.size < 18
									alb_photos_count += 1
									result_arr[result_arr.length] = [entity_date, album, alb_photos, alb_photos_count] if alb_photos != []
								elsif date < photo.created_at
									result_arr[result_arr.length] = [entity_date, album, alb_photos, alb_photos_count] if alb_photos != []
									result_arr[result_arr.length] = [photo.created_at, album, [photo], 1]
								end
							else
								if date >= photo.created_at
									alb_photos_count += 1
									alb_photos[alb_photos.length] = photo if alb_photos.size < 18
								elsif date < photo.created_at
									result_arr[result_arr.length] = [entity_date, album, alb_photos, alb_photos_count] if alb_photos != []
									entity_date = photo.created_at
									date = photo.created_at + 1.days
									alb_photos = []
									alb_photos_count = 1
									alb_photos[alb_photos.length] = photo
								end
							end

						end
					end
				end
				result_arr.sort!{|a,b|b<=>a}
			end
		return result_arr 
	end
	def make_entities_for_videos_part
		Video.all
	end
	def make_entities_for_article_part
		Article.find(:all, :order => 'created_at DESC')
	end
	def feed_html_block(content, i) #Блок для содержимого сообщений в темах, ленте
		#p = {:tContent => '', :fContent =>'', :classLvl_1 => '', :idLvl_1 => '', :classLvl_2 => '', :idLvl_2 => '', :classBg => '', :parity => integer}
		html = "
				<table style = 'width: 100%; height: 95%'>
						<tr>
							<td align = 'left' valign='middle' colspan = '2' style = 'height: 40px; '> 
								<span style = 'float: left;'>#{content[:head_link]}</span>
								<span style = 'float: right;'><p class = 'istring medium-opacity'>#{my_time(content[:event_date])}</p></span>
							</td>
						</tr>
						<tr>
							<td colspan = '2'>
								#{content[:header]}
								#{content[:head_info]}
							</td>
						</tr>
						<tr>
							<td align = 'left' valign = 'top' style = 'width: 50px;'>
								<img width = '50px' src = '#{content[:user_image_link]}'>
							</td>
							<td align = 'left' valign = 'top'>
								#{content[:main_content]}
							</td> 
						</tr>
						<tr>
							<td>
							</td>
							<td  align = 'left' valign = 'top'>
								#{content[:bottom_links]}
							</td>
						</tr>
				</table>"
		p = {
				:tContent => html,  
				:classLvl_2 => 'tb-pad-m', 
				:parity => i
			}
		return c_box_block(p)
	end
	def make_entities_for_comments_part
		result_array = []
		my_videos = current_user.videos
		my_photos = current_user.photos.where("photo_album_id not Null")
		not_my_videos = []
		not_my_photos = []
		my_comments_to_photo = current_user.messages.where("photo_id not Null")
		my_comments_to_video = current_user.messages.where("video_id not Null")
		if my_photos != []
			my_photos.each do |ph|
				ph_comments = ph.messages.where('status_id != 3').order("created_at DESC")
				if ph_comments != []
					result_array[result_array.length] = [ph_comments.first.created_at, 'photo_comment', ph_comments.first]
				end
			end
		end
		if my_videos != []
			my_videos.each do |video|
				video_comments = video.messages.order("created_at DESC")
				if video_comments != []
					result_array[result_array.length] = [video_comments.first.created_at, 'video_comment', video_comments.first]
				end
			end
		end
		if my_comments_to_photo != []
			my_comments_to_photo.each do |c|
				not_my_photos[not_my_photos.length] = c.photo if c.photo.user != current_user
			end
			not_my_photos.uniq!
			not_my_photos.each do |ph|
				result_array[result_array.length] = [ph.messages.last.created_at, 'photo_comment', ph.messages.last]
			end
		end
		if my_comments_to_video != []
			my_comments_to_video.each do |c|
				not_my_videos[not_my_videos.length] = c.video if c.video.user != current_user
			end
			not_my_videos.uniq!
			not_my_videos.each do |vd|
				result_array[result_array.length] = [vd.messages.last.created_at, 'video_comment', vd.messages.last]
			end
		end
		result_array.sort!{|a,b|b<=>a}
		return result_array
	end
	
	
	def build_as_comments_block(c, i)
		date = c[0]
		comment_type = c[1]
		comment = c[2]
		head_link = ''
		header = ''
		main_content = ''
		head_info = ''
		bottom_links = ''
		if comment_type == 'photo_comment'
			bottom_links = "#{link_to 'Все комментарии', comment.photo, :class => 'b_link'} | #{link_to 'Перейти к альбому', comment.photo.photo_album, :class => 'b_link'}"
			header = comment.photo.photo_album.name
			main_content = "#{comment.content_html} <div class = 'central_field' style = 'width: 400px;'>#{image_tag comment.photo.link, :width => '400px'}</div>"
			if comment.user == current_user
				if comment.photo.user == current_user
					if comment.message != nil
						head_link = "Вы ответили на комментарий к своей фотографии от #{comment.message.user.name}" if comment.message.user != current_user
						head_link = "Вы добавили комментарий к своей фотографии" if comment.message.user == current_user
					else
						head_link = "Вы добавили комментарий к своей фотографии"
					end
				else
					if comment.message != nil
						head_link = "Вы ответили на комментарий от #{comment.message.user.name} к фото коллеги" if comment.message.user != current_user
						head_link = "Вы добавили комментарий к фото #{comment.photo.user.name}" if comment.message.user == current_user
					else
						head_link = "Вы добавили комментарий к фото #{comment.photo.user.name}"
					end
				end
			else 
				if comment.photo.user == comment.user
					if comment.message != nil
						head_link = "#{comment.user.name} ответил на комментарий #{comment.message.user.name} к своей фотографии" if comment.message.user != current_user and comment.message.user != comment.user
						head_link = "#{comment.user.name} добавил комментарий к своей фотографии" if comment.message.user != current_user and comment.message.user == comment.user						
						head_link = "#{comment.user.name} ответил на Ваш комментарий к своей фотографии" if comment.message.user == current_user
					else
						head_link = "#{comment.user.name} добавил комментарий к своей фотографии"
					end
				elsif comment.photo.user == current_user
					if comment.message != nil
						head_link = "#{comment.user.name} ответил на комментарий от #{comment.message.user.name} к Вашей фотографии" if comment.message.user != comment.user and comment.message.user != current_user
						head_link = "#{comment.user.name} ответил на Ваш комментарий к Вашей фотографии" if comment.message.user != comment.user and comment.message.user == current_user
						head_link = "#{comment.user.name} добавил комментарий к Вашей фотографии" if comment.message.user == comment.user
					else
						head_link = "#{comment.user.name} добавил комментарий к Вашей фотографии"
					end
				else
					if comment.message != nil
						head_link = "#{comment.user.name} ответил на комментарий от #{comment.message.user.name} к фото коллеги" if comment.message.user != comment.user and comment.message.user != current_user
						head_link = "#{comment.user.name} ответил на Ваш комментарий к фото коллеги" if comment.message.user != comment.user and comment.message.user == current_user
						head_link = "#{comment.user.name} добавил комментарий к фото от #{comment.photo.user.name}" if comment.message.user == comment.user
					else
						head_link = "#{comment.user.name} добавил комментарий к фото #{comment.photo.user.name}"
					end
				end
			end
		elsif comment_type == 'video_comment'
			main_content = "#{comment.content_html}<div class = 'central_field' style = 'width: 640px;'>#{comment.video.link_html}</div>"
			header = comment.video.name
			if comment.user == current_user
				if comment.video.user == current_user
					if comment.message != nil
						head_link = "Вы ответили на комментарий к своему видео от #{comment.message.user.name}" if comment.message.user != current_user
						head_link = "Вы добавили комментарий к своему видео" if comment.message.user == current_user
					else
						head_link = "Вы добавили комментарий к своему видео"
					end
				else
					if comment.message != nil
						head_link = "Вы ответили на комментарий от #{comment.message.user.name} к видео коллеги" if comment.message.user != current_user
						head_link = "Вы добавили комментарий к видео #{comment.video.user.name}" if comment.message.user == current_user
					else
						head_link = "Вы добавили комментарий к видео #{comment.video.user.name}"
					end
				end
			else 
				if comment.video.user == comment.user
					if comment.message != nil
						head_link = "#{comment.user.name} ответил на комментарий к своему видео от #{comment.message.user.name}" if comment.message.user != current_user and comment.message.user != comment.user
						head_link = "#{comment.user.name} добавил комментарий к своему видео" if comment.message.user != current_user and comment.message.user == comment.user						
						head_link = "#{comment.user.name} ответил на Ваш комментарий к своему видео" if comment.message.user == current_user
					else
						head_link = "#{comment.user.name} добавил комментарий к своему видео"
					end
				elsif comment.video.user == current_user
					if comment.message != nil
						head_link = "#{comment.user.name} ответил на комментарий от #{comment.message.user.name} к Вашему видео" if comment.message.user != comment.user and comment.message.user != current_user
						head_link = "#{comment.user.name} ответил на Ваш комментарий к Вашему видео" if comment.message.user != comment.user and comment.message.user == current_user
						head_link = "#{comment.user.name} добавил комментарий к Вашему видео" if comment.message.user == comment.user
					else
						head_link = "#{comment.user.name} добавил комментарий к Вашему видео"
					end
				else
					if comment.message != nil
						head_link = "#{comment.user.name} ответил на комментарий от #{comment.message.user.name} к своему видео" if comment.message.user != comment.user and comment.message.user != current_user
						head_link = "#{comment.user.name} ответил на Ваш комментарий к видео коллеги" if comment.message.user != comment.user and comment.message.user == current_user
						head_link = "#{comment.user.name} добавил комментарий к видео от #{comment.video.user.name}" if comment.message.user == comment.user
					else
						head_link = "#{comment.user.name} добавил комментарий к видео #{comment.video.user.name}"
					end
				end
			end
		end
		content = {
					:event_date => date,
					:head_link => head_link,
					:header => header,
					:user_image_link => comment.user.alter_avatar,
					:main_content => main_content,
					:bottom_links => bottom_links
				  }
		return feed_html_block(content, i)
	end
	def build_as_answer_block(v, i)
		message = v[1]
		head_info = ''#"#{theme.user.name} разместил тему в разделе #{theme.topic.name}" if theme.user != current_user
		#head_info = "Вы разместили тему в разделе #{theme.topic.name}" if theme.user == current_user
		bottom_links = ''#control_buttons([{:name => 'Перейти к теме', :access => userCanSeeTheme?(theme), :type => 'follow',  :link => "/themes/#{theme.id}"}])
		if message.theme != nil
			if message.theme.user == current_user
				head_info = "Ответ в вашей теме \"#{message.theme.name}\""
			else
				if message.message != nil
					if message.message.user == current_user
						head_info = "Ответ на Ваше сообщение в теме \"#{message.theme.name}\""
					else
						head_info = "Ответ в теме \"#{message.theme.name}\""
					end
				else
					head_info = "Ответ в теме \"#{message.theme.name}\""
				end
			end
			bottom_links = control_buttons([{:name => 'Перейти к теме', :access => userCanSeeTheme?(message.theme), :type => 'follow',  :link => "/themes/#{message.theme.id}#msg_#{message.id}"}])
		elsif message.photo != nil
			if message.photo_album != nil
				head_info = "Ответ на Ваш комментарий к фотографии в альбоме \"#{message.photo_album.name}\""
			else
				head_info = "Ответ на Ваш комментарий к фотографии"
			end
			
			bottom_links = control_buttons([{:name => 'Перейти к фотографии', :access => userCanSeePhoto?(message.photo), :type => 'follow',  :link => "/photos/#{message.photo.id}#msg_#{message.id}"}])
		elsif message.photo_album != nil and message.photo == nil
			head_info = "Ответ на Ваш комментарий к альбому \"#{message.photo_album.name}\""
			bottom_links = control_buttons([{:name => 'Перейти к фотоальбому', :access => userCanSeeAlbum?(message.photo_album), :type => 'follow',  :link => "/photo_albums/#{message.photo_album.id}#msg_#{message.id}"}])
		elsif message.video != nil
			head_info = "Ответ на Ваш комментарий к видео \"#{message.video.alter_name}\""
			bottom_links = control_buttons([{:name => 'Перейти к видео', :access => true, :type => 'follow',  :link => "/videos/#{message.video.id}#msg_#{message.id}"}])
		end
		p = {
				:tContent => "<br /><p class = 'istring medium-opacity'>#{head_info}</p>" + message_body(message, false) + "<br />" + bottom_links, 
				:classLvl_1 => 'msgs', 
				:classLvl_2 => 'tb-pad-m',
				:parity => i
			}
		return c_box_block(p)
	end
	def build_as_theme_block(v, i)
		date = v[0]
		theme = v[1]

		head_info = "#{theme.user.name} разместил тему в разделе <span class = 'bi-string'>#{theme.topic.name}</span>" # if theme.user != current_user
		#head_info = "Вы разместили тему в разделе #{theme.topic.name}" if theme.user == current_user
		bottom_links = control_buttons([{:name => 'Перейти к теме', :access => userCanSeeTheme?(theme), :type => 'arrow-right',  :link => "/themes/#{theme.id}"}])
		p = {
				:tContent => "<p class = 'istring medium-opacity'>#{head_info}</p><h3 class = 'tb-pad-s'>#{theme.name}</h3>" + theme_body(theme, false) + bottom_links, 
				:classLvl_1 => 'mainEntity', 
				:classLvl_2 => 'tb-pad-m',
				:parity => i
			}
		return c_box_block(p)
	end
	def build_as_message_block(v, i)
		#date = v[0]
		message = v[1]
		head_info = "Сообщение в теме <span class = 'bi-string'>#{message.theme.name}</span>"
		bottom_links = control_buttons([{:name => 'Перейти к теме', :access => userCanSeeTheme?(message.theme), :type => 'arrow-right',  :link => "/themes/#{message.theme.id}##{message.id}"}])
		p = {
				:tContent => "<p class = 'istring medium-opacity'>#{head_info}</p>" + message_body(message, false) + bottom_links, 
				:classLvl_1 => 'msgs', 
				:classLvl_2 => 'tb-pad-m',
				:parity => i
			}
		return c_box_block(p)
	end
	def build_as_album_block(v, i)
		date = v[0]
		album = v[1]
		photos = v[2]
		photos_count = v[3]
		head_link = link_to("#{album.user.name} добавил новый альбом в категорию #{album.category_name}", album, :class => 'b_link') if photos.last.created_at <= album.created_at + 1.days 
		head_link = link_to("#{album.user.name} добавил #{photos.count} фото в альбом", album, :class => 'b_link') if photos.last.created_at > album.created_at + 1.days 
		bottom_link = link_to "Перейти в альбом", album, :class => 'b_link'
		main_content = ''
		main_content = "Показано <b>#{photos.length}</b> из <b>#{photos_count}</b> (#{link_to "Смотреть все", album, :class => 'b_link'})<br /><br />" if photos.count < photos_count
		photos.each do |photo|
			main_content += "<a data-lightbox='album_#{ photo.photo_album.id.to_s }' href = '#{ photo.link }' title = '#{photo.description}' alt = '#{photo_path(photo)}' >#{image_tag photo.link.thumb, :class => 'album_thumb_photo', :width => '130px'}</a>"
		end
		content = {
					:event_date => date,
					:head_link => head_link,
					:header => "#{album.name}",
					:head_info => "<br />Фотографий в альбоме <b>#{album.photos.count}</b>",
					:user_image_link => album.user.alter_avatar,
					:main_content => main_content,
					:bottom_links => bottom_link
				  }
		return feed_html_block(content)
	end
	
	def build_as_video_block(v, i)
		head_info = "Видео в категории <span class = 'bi-string'>#{v.category_name}</span>"
		p = {
				:tContent => "<p class = 'istring medium-opacity'>#{head_info}</p>" + video_show_body(v, true), 
				:classLvl_1 => 'msgs', 
				:classLvl_2 => 'tb-pad-m',
				:parity => i
			}
		return c_box_block(p)
	end
	
	def build_as_article_block(article, i)
	type = article.get_type_by_id(article.article_type_id)
	head_link = "#{article.user.name} добавил отчёт о Лётном происшествии" if type[:value] == 1
	head_link = "#{article.user.name} добавил документ" if type[:value] == 2 
	head_link = "#{article.user.name} добавил отчёт" if type[:value] == 3 
	head_link = "#{article.user.name} добавил статью" if type[:value] == 4
	head_link = "#{article.user.name} добавил отзыв" if type[:value] == 5
	head_link = "#{article.user.name} добавил статью в категорию 'Восставшие из Руин'" if type[:value] == 6
		  content = {
						:event_date => article.created_at,
						:head_link => link_to(head_link, article, :class => 'b_link'),
						:header => "#{article.name}",
						:user_image_link => article.user.alter_avatar,
						:main_content => "#{article.content_html} <br /> #{article_photos(article)} #{list_attachments(article.attachment_files)}",
						:bottom_links => link_to("Перейти к статье", article, :class => 'b_link')
					  }
		return feed_html_block(content)
	end
	def article_photos(article)
		photos = ''
		if article.photos != []
			photos += '<br /><br />'
			article.photos.each do |photo|
				photos += "<a data-lightbox='article_#{ article.id.to_s }' href = '#{ photo.link }' title = '#{photo.description}' ><img src = '#{photo.link.thumb}' width = '130px' class = 'album_thumb_photo'/></a>" if photo.status_id != 2 and photo.status_id != 3
			end
		end
		return photos
	end
# Пагинация новостной ленты
# -------------- Текст пагинации отображаемый вверху и внизу страницы ----------------------------------------------------------------------------------------------	
	
	def array_to_view
		sorted_array = @entity_array.sort{|a,b|b<=>a}
		range_start = current_page*@entity_on_page - @entity_on_page
		range_end = range_start + @entity_on_page - 1
		array = sorted_array[range_start..range_end]
		return array
	end
	
	def feed_pagination
		cur_index = current_page - 1 #Текущий элемент
		max_number_in_line = 9 #Максимальное количесво номеров в ряд (ДОЛЖНО БЫТЬ НЕЧЁТНЫМ!!!)
		max_index = pages_count #Номер последнего элемента
		pages_string = ""
		numbers_string = ""
		first_number = " <a href = '#{@paginationLink}&page=1'>1</a> ..."
		last_number = " ... <a href = '#{@paginationLink}&page=#{pages_count}'>#{pages_count}</a>"
		if max_index > max_number_in_line
			offset = (max_number_in_line - 1)/2 #смещение относительно текущей точки
			if (cur_index) <= offset + 1 #in case 123456789..90
				max_number = cur_index + offset + 1 if cur_index > offset
				max_number = max_number_in_line if cur_index <= offset
				numbers_string = make_numbers_string_on_feed(0, max_number, cur_index)
				numbers_string += last_number
			elsif (cur_index) >= (max_index - offset) #in case 1..82 83 84 85 86 87 88 89 90
				numbers_string += first_number
				numbers_string += make_numbers_string_on_feed(max_index - max_number_in_line, max_index, cur_index)
			elsif (cur_index) > (offset) and (cur_index) < (max_index - offset + 1) #in case 1.. 21 22 23 24 25 26 27 28 29 ..90
				numbers_string += first_number
				numbers_string += make_numbers_string_on_feed(cur_index - offset, cur_index + offset + 1, cur_index)
				numbers_string += last_number if cur_index + offset + 1 != max_index
			end 
		else	
				numbers_string = make_numbers_string_on_feed(0, max_index, cur_index)
		end
		return "#{link_to '<', "#{@paginationLink}&page=#{cur_index}" if cur_index > 0} #{'<' if cur_index == 0}  #{numbers_string}  #{link_to '>', "#{@paginationLink}&page=#{cur_index + 2}" if cur_index < (max_index - 1)} #{'>' if cur_index == (max_index - 1)}".html_safe
	end
	def make_numbers_string_on_feed(start_index, end_index, cur_index)
		value = ''
		i = start_index
		begin
			if i == cur_index
				value += " #{i+1}"
			else
				value += " <a href = '#{@paginationLink}&page=#{i+1}'}'>#{i+1}</a>"
			end
			i += 1
		end until(i == end_index or i == pages_count)
		return value
	end
	def current_page
		if params[:page] != nil and params[:page] != "" and params[:page] != "1"
			return (params[:page]).to_i 
		else
			return 1
		end
	end
	
	def pages_count # Подсчет количества страниц 
		result = 0
		if @entity_array.length <= @entity_on_page
			result = 1
		else
			div_res = @entity_array.length.divmod @entity_on_page
			result = div_res[0]
			result += 1 if div_res[1] != 0
		end
		return result
	end
#----- end пагинация новостной ленты -------------------------------------------------------------------------------------------------------------------
#feed functions	end-------------------------------------------------------------------------------------------
#index functions----------------------------------------------------------------------------------------------
	
#-------------------------------------------------------------------------------------------------------------

#поиск по сайту--------------------------------------------------------------------------------------------------------------------------------------------------------
def visota_search(txt, part)
	@s_albums = []
	@s_themes = []
	@s_messages = []
	txt = txt.ru_downcase
	@words_arr = make_word_arr(txt)
	if part == ['all'] || part == ['themes'] || part == ['messages']
		@s_themes = search_in_themes(txt)
	elsif part == ['all'] || part == ['albums']
		@s_albums = search_in_albums(txt)
	elsif part == ['all'] || part == ['messages'] || part == ['themes']
		@s_messages = search_in_messages(txt)
	end
end

def is_predlog?(w)
	miniWords = ['в', 'без', 'до', 'из', 'к', 'на', 'по', 'о', 'от', 'перед', 'при', 'через', 'с', 'у', 'за', 'над', 'об', 'под', 'про', 'для', 'a', 'но', 'бы', 'из-под', 'из-за', 'да', 'нет']
	miniWords.each do |i|
		return true if i == w
	end
	return false
end

def make_word_arr(txt)
	arr = []
	txt.strip!
	arr[arr.length] = txt
	@l = txt.my_length
	@fuck = ''
	if txt.index(' ') != -1
		wrd = ''
		i = 0
		txt.chars do |ch|
			i += 1
			if ch == ' ' || ch == '.' || ch == ','
				arr[arr.length] = wrd if wrd != '' and !is_predlog?(wrd)
				wrd = ''
			else 
				wrd += ch
			end	
			if i == @l
				arr[arr.length] = wrd if !is_predlog?(wrd)
			end

			@fuck += "#{i.to_s} #{ch.ru_downcase}<br />"
		end
	end
	return arr
end

def search_in_events
	#@events = Event.
end

def search_in_old_messages
  old_messages = OldMessage.all
  oldMsgsResult = []
  if old_messages != []
    old_messages.each do |msg|
      dwnCaseMsgText = msg.content.mb_chars.downcase
      oldMsgsResult[oldMsgsResult.length] = [msg.created_when, msg] if isLikebleText?(dwnCaseMsgText, @search_string)
    end
  end
  return oldMsgsResult
end


def search_in_themes
  if is_not_authorized?
    vsId = 1
  else
    vsId = [1,2]
  end 

  resultThemes = []
  resultMessages = []
  #if themes != []
  #  themes.each do |th| #ищем в темах
  #    dwnCaseThText = th.name.mb_chars.downcase
  #    if isLikebleText?(dwnCaseThText, @search_string)
  #      resultThemes[resultThemes.length] = [th.created_at, th]
  #    else
  #      dwnCaseThText = th.content.mb_chars.downcase
  #      if isLikebleText?(dwnCaseThText, @search_string)
  #        resultThemes[resultThemes.length] = [th.created_at, th]
  #      else #если не находим в темах листаем сообщения и ищем в них
  #        msgs = th.visible_messages
  #        if msgs != []
  #          msgs.each do |msg|
  #            dwnCaseThText = msg.content.mb_chars.downcase
  #            resultMessages[resultMessages.length] = [msg.created_at, msg] if isLikebleText?(dwnCaseThText, @search_string)
  #          end
  #        end
  #      end
  #    end
  #  end
  #end
	return {:themes => resultThemes, :messages => resultMessages}
end

def theme_block_for_search_result(theme, i)
  html = "<h3>Тема в разделе #{theme.topic.name}</h3>
	<table style = 'width: 100%;'>
		<tr>
			<td valign = 'middle' align = 'left'  style='height: 45px;'>
				#{themeInformation(theme)}
			</td>
			<td valign = 'middle' align = 'right' style='height: 45px;'>
				<p class = 'istring_m norm'>Тема создана #{my_time(theme.created_at)}</p>
			</td>
		</tr>
		<tr>
			<td valign = 'middle' align = 'left'  style='height: 45px;'>
				<span class = 'istring_m norm'>Заголовок темы:</span> <span istring_m norm>#{theme.name}</span>
			</td>
			<td valign = 'middle' align = 'right' style='height: 45px;'>
				
		</tr>
		<tr>
			<td valign = 'middle' align = 'left' colspan = '2'>
				<span class = 'istring_m norm'>Автор темы: </span>#{link_to theme.user.name, theme.user, :class => 'b_link_i'}
			</td>
		</tr>
		<tbody id = 'middle'>
			<tr>
			<td  colspan = '2'>
					<span id = 'content' class = 'mText'>#{theme.content_html}</span>
					#{theme.updater_string}
					#{"<br /><div class = 'central_field' style = 'width: 1000px;'>#{theme_list_photos(theme)}</div>" if theme.photos != []}
					#{"<br />#{list_attachments(theme.attachment_files)}" if theme.attachment_files != []}
			</td>
			</tr>
		</tbody>
		<tr>
			<td colspan = '2'>
				<div>
					 #{control_buttons([{:name => "Перейти", :access => true, :type => 'arrow-right', :link => theme_path(theme)}])}
				</div>
			</td>
		</tr>
	</table>		
	"
         
	p = {
			:tContent => html, 
			:idLvl_2 => 'thBody',
			:classLvl_2 => 'tb-pad-m',
			:parity => i
		}
    return c_box_block(p)
end
#поиск по сайту-end----------------------------------------------------------------------------------------------------------------------------------------------------
def mediaTypes 
  article = Article.new
  album = PhotoAlbum.new
  video = Video.new
  val = [
           {ru_name: "Фотоальбомы", en_name: "albums", className: "albums", categories: album.categories}, 
           {ru_name: "Видео", en_name: "videos", className: "videos", categories: video.categories}
        ]
  article.types.each do |t|
    val[val.length] = {ru_name: t[:media_name], en_name: t[:link], className: "articles", categories: []}
  end
  return val
end 

def makeMediaPartHash
  mHash = {
            typeName: "",
            cTypeName: "",
            typeButtons: [], 
            categoryButtons: []
          }
  mTypes = mediaTypes
  flag = false
  type = mTypes.first
  typeButtons = []
  categoryButtons = []
  mTypes.each do |t|
    typeButtons[typeButtons.length] = {:name => t[:ru_name], :access => true, :type => 'b_grey', :link => "/media?t=#{t[:en_name]}", :data_remote => true}
    if t[:en_name] == session[:media_type]
      type = t
      typeButtons.last[:selected] = true
      flag = true
      if t[:categories] != [] and t[:categories] != nil
        cFlag = false
        categoryButtons[categoryButtons.length] = {:name => "Все категории", :access => true, :type => 'b_grey', :link => "/media?c=all", :data_remote => true}
        categoryButtons.first[:selected] = true if session[:media_category] == 'all'
        t[:categories].each do |c|
            categoryButtons[categoryButtons.length] = {:name => c[:name], :access => true, :type => 'b_grey', :link => "/media?c=#{c[:value]}", :data_remote => true}
            if session[:media_category] == c[:value]
              categoryButtons.last[:selected] = true  
              mHash[:cTypeName] = c[:name]
              cFlag = true
            end
        end
        if !cFlag
          categoryButtons.first[:selected] = true
          session[:media_category] = "all"
        end
        mHash[:categoryButtons] = categoryButtons
      end
    end
  end 
  if !flag
    typeButtons.first[:selected] = true
    session[:media_type] = type[:en_name]
    session[:media_year] = 'all'
    session[:media_category] = 'all'
    if type[:categories] != [] and type[:categories] != nil
      categoryButtons[categoryButtons.length] = {:name => "Все категории", :access => true, selected: true,:type => 'b_grey', :link => "/media?c=all", :data_remote => true}
      type[:categories].each do |c|
         categoryButtons[categoryButtons.length] = {:name => c[:name], :access => true, :type => 'b_grey', :link => "/media?c=#{c[:value]}", :data_remote => true}
      end
      mHash[:categoryButtons] = categoryButtons
    end 
  end
  mHash[:typeButtons] = typeButtons  
  mHash[:typeName] = type[:className]
  return mHash   
end

def setDefaultSessionMediaHash
  session[:media_type] = 'albums'
  session[:media_year] = 'all'
  session[:media_category] = 'all'
end



  def mediaCategoryMenu
    if session[:media_type] == 'videos' || session[:media_type] == 'albums'
      album = PhotoAlbum.new
      buttons = [{:name => "Все категории", :access => true, :type => 'b_grey', :link => "/media?c=all", :data_remote => true}]
      buttons.first[:selected] = true if session[:media_category] == 'all'
      i = 0
      album.categories.each do |c|
        i += 1
        buttons[i] = {:name => c[:name], :access => true, :type => 'b_grey', :link => "/media?c=#{c[:value]}", :data_remote => true}
        buttons[i][:selected] = true if session[:media_category] == c[:value]
      end
    elsif session[:media_type] == 'articles'
      article = Article.new
      buttons = []
      i = 0
      article.types.each do |c|
        buttons[i] = {:name => c[:multiple_name], :access => true, :type => 'b_grey', :link => "/media?c=#{c[:value]}", :data_remote => true}
        buttons[i][:selected] = true if session[:media_category] == c[:value]
        i += 1
      end
      buttons.first[:selected] = true if session[:media_category] == 'all'
    end
    return buttons_in_line(buttons).html_safe
  end
  def mediaYearsMenu
    '<br />YearsMenu'.html_safe
  end

  def setMediaSessionHash
    #заполняем если хэш пустой
    session[:media_type] = 'albums' if session[:media_type] == nil
    session[:media_year] = 'all' if session[:media_year] == nil
    session[:media_category] = 'all' if session[:media_category] == nil 
    #обновляем хэш если параметры новые
    session[:media_type] = params[:t] if params[:t] != nil
    #if params[:year] != nil
    #  session[:media_year] = params[:year]
    # end
    if params[:c] != nil
      session[:media_category] = params[:c].to_i if params[:c] != 'all'
      session[:media_category] = params[:c] if params[:c] == 'all'
    end
  end
  
  def newMediaPanel
    if is_not_authorized?
      ''
    else
      if @mediaPartHash[:typeName] == 'videos'
        p = [{:name => 'Добавить видео', :access => true, :type => 'plus', :link => new_video_path}]
      elsif @mediaPartHash[:typeName] == 'albums'
        p = [{:name => 'Добавить альбом', :access => true, :type => 'plus', :link => new_photo_album_path}]
      elsif @mediaPartHash[:typeName] == 'articles'
        p = [new_article_button(@articleType)]  
      end
      v = "<div class = 'c_box'><div class = 'm_1000wh'>#{control_buttons(p)}</div></div>"
      return v.html_safe 
    end 
  end
end