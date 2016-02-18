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
         # p.theme.entity_photos.create(photo_id: p.id, visibility_status_id: 1) if p.theme != nil
         # p.message.entity_photos.create(photo_id: p.id, visibility_status_id: 1) if p.message != nil
         # p.article.entity_photos.create(photo_id: p.id, visibility_status_id: 1) if p.article != nil
         # p.event.entity_photos.create(photo_id: p.id, visibility_status_id: 1) if p.event != nil
         # p.photo_album.entity_photos.create(photo_id: p.id, visibility_status_id: 1) if p.photo_album != nil
         # p.update_attributes(theme_id: nil, message_id: nil, event_id: nil, article_id: nil, photo_album_id: nil)
          p.link.recreate_versions!(:small_thumb, :in_content, :big_thumb) if p.link?
      end
    end
    users = User.all
    users.each {|u| u.avatar.recreate_versions!(:sq_thumb) if u.avatar?} 
  end

   
end
