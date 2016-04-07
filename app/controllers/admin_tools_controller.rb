class AdminToolsController < ApplicationController
  include AdminToolsHelper  
  before_action :check_admin
  def check_admin
    redirect_to '/404' if user_type != 'super_admin'
  end
  def functions_test
    @title = @header = 'Тест функций'
    message = Message.find(2936)
    user = User.find(1)
    MessageMailer.new_message_in_theme_mailer(message, user)
    #photosRebindings
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
      #photosUpdate
      redirect_to photo_albums_path
  end
# Шаги для адаптации базы данных
# 1. Запусаем миграцию 
# 2. Закомменчиваем скоупы в topic.rb для messages и themes  
# 3. Обязательно чистим cache
# 4. adaptation_to_new
# 5. Раскомменчиваем скоупы в topic.rb для messages и themes  
  def adaptation_to_new #Создание тем из базы данных первой версии сайта.
    #makeThemesFromMessages #адаптируем старую гостевую под новую
		#adaptationAlbums
		#adaptationPhotos
		#adaptationArticles
    #adaptationVideos
    #photosUpdate
    redirect_to '/visota_life'
  end
  def make_themes_steps
    #redirect_to '/404' if !is_super_admin?
    #stepsAdaption
    #makeThemesSteps
    redirect_to topics_path
  end
end
