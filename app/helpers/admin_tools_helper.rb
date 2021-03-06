module AdminToolsHelper
	def entities_control_buttons(type)
		s_id = 2 if type == 'hidden'
		s_id = 3 if type == 'deleted'
		buttons = []
		themes = Theme.find_all_by_status_id(s_id)
		messages = Message.find_all_by_status_id(s_id)
		albums = PhotoAlbum.find_all_by_status_id(s_id)
		photos = Photo.find_all_by_status_id(s_id)
		articles = Article.find_all_by_status_id(s_id)
		buttons[buttons.length] = {:name => "Темы(#{themes.count})", :access => ['super_admin', 'admin'], :type => 'b_green', :link => "/admin_tools/#{type}_themes"} if themes.count != 0
		buttons[buttons.length] = {:name => "Сообщения(#{messages.count})", :access => ['super_admin', 'admin'], :type => 'b_green', :link => "/admin_tools/#{type}_messages"} if messages.count != 0
		buttons[buttons.length] = {:name => "Альбомы(#{albums.count})", :access => ['super_admin', 'admin'], :type => 'b_green', :link => "/admin_tools/#{type}_albums"} if albums.count != 0
		buttons[buttons.length] = {:name => "Фотографии(#{photos.count})", :access => ['super_admin', 'admin'], :type => 'b_green', :link => "/admin_tools/#{type}_photos"} if photos.count != 0
		buttons[buttons.length] = {:name => "Материалы(#{articles.count})", :access => ['super_admin', 'admin'], :type => 'b_green', :link => "/admin_tools/#{type}_articles"} if articles.count != 0
		return buttons
	end
	
	def themes_list(type)
		s_id = 2 if type == 'hidden'
		s_id = 3 if type == 'deleted'
		text = 'скрытых' if type == 'hidden'
		text = 'удалённых' if type == 'deleted'
		value = "Нет #{text} тем"
		themes = Theme.find_all_by_status_id(s_id)
		if themes != []
			value = "<table><tr><th>id</th><th>Автор</th><th>Название</th><th>Раздел</th><th>Сообщений</th><th></th></tr>"
			themes.each do |theme|
				value += "<tr>
							<td align = 'center'>#{theme.id}</td>
							<td align = 'center'><span title = '#{theme.user.name}'>#{truncate(theme.user.name, :length => 60)}</span></td>
							<td align = 'center'><span title = '#{theme.name}'>#{truncate(theme.name, :length => 30)}</span></td>
							<td align = 'center'><span title = '#{theme.topic.name}'>#{truncate(theme.topic.name, :length => 60)}</span></td>
							<td align = 'center'>#{theme.messages.count}</td>
							<td align = 'center'>#{link_to 'Перейти', theme, :class => 'b_link'}</td>
						 </tr>"
			end
			value += "</table>"
		end
		return value
	end
	
	def photos_list(type)
		s_id = 2 if type == 'hidden'
		s_id = 3 if type == 'deleted'
		text = 'скрытых' if type == 'hidden'
		text = 'удалённых' if type == 'deleted'
		value = "Нет #{text} фотографий"
		photos = Photo.find_all_by_status_id(s_id)
		if photos != []
			value = "<table><tr><th>id</th><th>Изображение</th><th>Тип родителя</th><th></th><th></th></tr>"
			photos.each do |photo|
				value += "<tr>
							<td align = 'center'>#{photo.id}</td>
							<td align = 'center'>#{image_tag photo.link.thumb}</td>
							<td align = 'center'>#{photo.parent_type}</td>
							<td align = 'center'>#{link_to 'Перейти', photo, :class => 'b_link'}</td>
							<td align = 'center'>#{link_to 'Восстановить', "/admin_tools/entities_recovery?e=ph&id=#{photo.id}", :class => 'b_link'}</td>
						 </tr>"
			end
			value += "</table>"
		end
		return value
	end
	
	def do_visible_messages(messages)
		if messages != []
			messages.each do |msg|
				msg.update_attributes(:visibility_status_id => 1, :status_id => 1) if msg.visibility_status_id != 1 && msg.status_id != 1 
			end
		end
	end
  
  def stepsAdaption
    users = User.all
    if users != []
      users.each do |u|
        t = Digest::SHA2.hexdigest(u.created_at.to_s)
        u.update_attribute(:guest_token, t)
        steps = u.steps 
        if steps != []
          steps.each {|s| s.update_attribute(:guest_token, t)}
        end
      end
    end
    guestSteps = Step.where(user_id: 0)
    guestSteps.delete_all if !guestSteps.blank?
  end
  
  def makeThemesFromMessages
		i = 0
		@fuck = []
		fuck = []
		topics = Topic.all		
		topics.each do |topic| 
			msgsWithoutTread = []
      msgs = topic.firstMessages
			frstMsgsWithName = topic.firstMessagesWithName(msgs[:withName])
			frstMsgsWithoutName = topic.firstMessagesWithoutName(msgs[:withoutName])
			if frstMsgsWithName != []
				frstMsgsWithName.each do |msg|
					theme = Theme.find_by(name: msg.name)
					if theme.nil?
            theme = Theme.new(
										:name => msg.name, 
										:content => msg.content, 
										:status_id => 1, 
										:user_id => msg.user_id, 
										:topic_id => topic.id, 
										:created_at => msg.created_at,  
										:updated_at => msg.updated_at,
										:updater_id => msg.updater_id,
										:visibility_status_id => 1,
										:last_message_date => msg.created_at,
                    theme_type_id: 1
									) #Создаём новую тему на базе текущего первого сообщения
						if theme.save
						  msg.bind_child_messages_to_theme_from_first_message(theme)
						  msg.bind_photos_to_theme(theme)
						  msg.bind_attachments_to_theme(theme)
						  msg.destroy
            end
					else	
						msg.update_attributes(:theme_id => theme.id, :status_id => 1)
						msg.bind_child_messages_to_theme_from_first_message(theme)
					end
					theme.last_msg_upd
				end
			end
			if frstMsgsWithoutName != []
				frstMsgsWithoutName.each do |msg|
					if msg.get_tread != []
						i+=1
            theme = Theme.new(
										:name => "Обсуждение без имени #{i}", 
										:content => msg.content, 
										:status_id => 1, 
										:user_id => msg.user_id, 
										:topic_id => topic.id, 
										:created_at => msg.created_at,  
										:updated_at => msg.updated_at,
										:updater_id => msg.updater_id,
										:visibility_status_id => 1,
										:last_message_date => msg.created_at,
                    theme_type_id: 1
									)  #Создаём новую тему на базе текущего первого сообщения
            if theme.save
						  msg.bind_child_messages_to_theme_from_first_message(theme)
						  msg.bind_photos_to_theme(theme)
						  msg.bind_attachments_to_theme(theme)
						  theme.last_msg_upd
						  msg.destroy
            end
					else
						theme = Theme.find_by(name: 'Сообщения без темы', topic_id: topic.id)
						if theme == nil
              theme = Theme.new(
  												:user_id => 1, 
  												:name => 'Сообщения без темы', 
  												:content => "Здесь собраны сообщения без темы для раздела '#{topic.name}'", 
  												:topic_id => topic.id, 
  												:created_at => msg.created_at, 
  												:updated_at => msg.updated_at, 
  												:status_id => 1,
  												:visibility_status_id => 1,
  												:last_message_date => msg.created_at,
                          theme_type_id: 1
  											 ) 
              theme.save
            end
						msg.update_attributes(:theme_id => theme.id, :visibility_status_id => 1, :status_id => 1)
						theme.last_msg_upd
					end
				end
			end
		end
  end
  
  def adaptationAlbums
		albums = PhotoAlbum.all
		if albums != []
			albums.each do |album|
				album.update_attributes(:status_id => 1)
        steps = Step.where(part_id: 3, page_id: 1, entity_id: album.id)
        v = album.build_entity_view(counter: steps.count)
        v.save
			end
		end
  end
  
  def adaptationPhotos
		photos = Photo.all
		if photos != []
			photos.each do |photo|
				#photo.update_attributes(:visibility_status_id => 1)
        steps = Step.where(part_id: 4, page_id: 1, entity_id: photo.id)
        v = photo.build_entity_view(counter: steps.count)
        v.save
        if photo.messages != []
          photo.messages.each do |m|
            m.update_attributes(status_id: 1)
          end
        end
			end
		end
  end
  
  def adaptationArticles
		articles = Article.all
		if articles != []
			articles.each do |article|
				article.update_attributes(:status_id => 1, :visibility_status_id => 1, :accident_date => article.created_at)
        steps = Step.where(part_id: 7, page_id: 1, entity_id: article.id)
        v = article.build_entity_view(counter: steps.count)
        v.save
      end
		end
  end
  
  def adaptationVideos
    videos = Video.all
    if videos != []
      videos.each do |v|
        if v.messages != []
          v.messages.each do |m|
            m.update_attributes(status_id: 1)
          end
        end
      end
    end
  end
  
  def makeThemesSteps
    users = User.all
    if !users.blank?
      users.each do |u|
        #Step.find_by(part_id: 9, page_id: 1, entity_id: self.id, user_id: user.id)
        uThemes = u.themes
        notUThemes = Theme.all - u.themes
        if !uThemes.blank?
          uThemes.each do |th|
            step = Step.find_by(part_id: 9, page_id: 1, entity_id: th.id, user_id: u.id)
            if step.nil?
          		step = Step.create(
          					            :user_id => u.id, 
          						          :part_id => 9,
          						          :page_id => 1,
          						          :entity_id => th.id,
          						          :host_name => '',
          						          :ip_addr => '0.0.0.0',
          						          :visit_time => th.last_message_date,
                                :guest_token => u.guest_token,
                                online_flag: true
          						          )
            else
              step.update_attribute(:visit_time, th.last_message_date) if !th.last_message.nil?
            end
          end
        end
        if !notUThemes.blank?
          notUThemes.each do |th|
            step = Step.find_by(part_id: 9, page_id: 1, entity_id: th.id, user_id: u.id)
            if step.nil? && !th.messages.where(user_id: u.id).last.nil?
          		step = Step.create(
          					            :user_id => u.id, 
          						          :part_id => 9,
          						          :page_id => 1,
          						          :entity_id => th.id,
          						          :host_name => '',
          						          :ip_addr => '0.0.0.0',
          						          :visit_time => th.messages.where(user_id: u.id).last.created_at,
                                :guest_token => u.guest_token,
                                online_flag: true
          						          )
            end
          end
        end
      end
    end
  end
  
  def photosUpdate
    photos = Photo.all
    if photos != []
      photos.each do |p|
         p.theme.entity_photos.create(photo_id: p.id, visibility_status_id: 1) if p.theme != nil
         p.message.entity_photos.create(photo_id: p.id, visibility_status_id: 1) if p.message != nil
         p.article.entity_photos.create(photo_id: p.id, visibility_status_id: 1) if p.article != nil
         p.event.entity_photos.create(photo_id: p.id, visibility_status_id: 1) if p.event != nil
         p.photo_album.entity_photos.create(photo_id: p.id, visibility_status_id: 1) if p.photo_album != nil
         p.update_attributes(theme_id: nil, message_id: nil, event_id: nil, article_id: nil, photo_album_id: nil)
        #p.link.recreate_versions!(:small_thumb, :in_content, :big_thumb) if p.link?
      end
    end
    #users = User.all
   # users.each {|u| u.avatar.recreate_versions!(:sq_thumb) if u.avatar?} 
  end

   
end
