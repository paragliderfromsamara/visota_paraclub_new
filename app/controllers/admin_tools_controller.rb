class AdminToolsController < ApplicationController
  include AdminToolsHelper  
  before_action :check_admin
  def check_admin
    redirect_to '/404' if user_type != 'super_admin'
  end
  def functions_test
    @title = @header = 'Тест функций'
    #photosRebinding
    #album = PhotoAlbum.find(53)
    #sendNewAlbumMail(album)
    #video = Video.find(36)
    #sendNewVideoMail(video)
  end
   
  def hidden_entities #скрытые объекты
		@title = 'Скрытые объекты'
  end
  
  def deleted_entities #удалённые объекты
		@title = 'Удалённые объекты'
  end
  
  def deleted_albums #удалённые альбомы
		@title = 'Удалённые альбомы'
  end
  
  def deleted_photos #удалённые фотографии
		@title = 'Удалённые фотографии'
  end
  
  def deleted_themes #удалённые темы
		@title = 'Удалённые темы'
  end

  def deleted_messages #удалённые сообщения
		@title = 'Удалённые сообщения'
  end
  
  def deleted_articles #удалённые статьи
		@title = 'Удалённые статьи'
  end
  
  def hidden_messages #скрытые сообщения
		@title = 'Скрытые сообщения'
  end
  
  def hidden_themes #скрытые темы
		@title = 'Скрытые темы'
  end
  
  def hidden_albums #скрытые альбомы
		@title = 'Скрытые альбомы'
  end
  
  def hidden_photos #скрытые фотографии
		@title = 'Скрытые фотографии'
  end
  
  def hidden_articles #скрытые статьи
		@title = 'Скрытые статьи'
  end
  
  def site_images #изображения оформления сайта
		@title = 'Изображения оформления сайта'
  end
  
  def entities_recovery
	type = params[:e]
	id = params[:id]
	if type != '' and type != nil and id != '' and id != nil
		case type
		when 'ph'
			photo = Photo.find_by_id(id)
			photo.update_attributes(:status_id => 1) if photo != nil
			redirect_to :back 
		when 'th'
			theme = Theme.find_by_id(id)
			theme.update_attributes(:status_id => 1) if theme != nil
			redirect_to :back 
		end
	end
  end
  
  def disabled_events
		@title = 'Неактивные новости'
		@events = Event.find_all_by_status_id(1)
		render "events/index.html.erb"
  end
  def recreate_photo_versions
      photosUpdate
      redirect_to photo_albums_path
  end
   
  def adaptation_to_new #Создание тем из базы данных первой версии сайта.
		i = 0
		@fuck = []
		fuck = []
		topics = Topic.all		
		topics.each do |topic| 
			msgsWithoutTread = [] 
			frstMsgsWithName = topic.firstMessagesWithName
			frstMsgsWithoutName = topic.firstMessagesWithoutName
			if frstMsgsWithName != []
				frstMsgsWithName.each do |msg|
					theme = Theme.find_by(name: msg.name)
					if theme == nil
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
										:last_message_date => msg.created_at
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
										:last_message_date => msg.created_at
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
  												:last_message_date => msg.created_at
  											 ) 
              theme.save
            end
						msg.update_attributes(:theme_id => theme.id, :visibility_status_id => 1, :status_id => 1)
						theme.last_msg_upd
					end
				end
			end
		end
		albums = PhotoAlbum.all
		if albums != []
			albums.each do |album|
				album.update_attributes(:status_id => 1)
        steps = Step.where(part_id: 3, page_id: 1, entity_id: album.id)
        v = album.build_entity_view(counter: steps.count)
        v.save
			end
		end
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
		articles = Article.all
		if articles != []
			articles.each do |article|
				article.update_attributes(:status_id => 1, :visibility_status_id => 1, :accident_date => article.created_at)
        steps = Step.where(part_id: 7, page_id: 1, entity_id: article.id)
        v = article.build_entity_view(counter: steps.count)
        v.save
      end
		end
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

    stepsAdaption
    #photosUpdate
  end
  def make_themes_steps
    redirect_to '/404' if !is_super_admin?
    makeThemesSteps
    redirect_to topics_path
  end
end
