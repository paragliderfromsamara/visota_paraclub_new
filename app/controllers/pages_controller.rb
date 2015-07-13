class PagesController < ApplicationController
include PagesHelper
#include EventsHelper
#include PhotoAlbumsHelper
#include VideosHelper

  def index
	@title = "Главная"
	@topSlider = true
	@add_functions = "myParalaxes();"
	@events = Event.where(display_area_id: ([1, 3]), occupation: 'Code Artist').order('post_date DESC').limit(5)
	@albums = PhotoAlbum.where(status_id: 1).order("created_at DESC").limit(5)
	@videos = Video.all.order('created_at DESC').limit(3)
  end

  def school
	@title = "Обучение"
  end

  def equipment
	  @title = 'Снаряжение'
  end
	
  def contacts
    @title = "Контакты"
  end

  def about_us
	  @title = "О клубе"
    
  end
  
  def paragliding
	  @title = "Немного о парапланеризме"
  end
  
  def new_template
	render :layout => 'new_layout' 
  end 
  
  def feed
	if user_type != 'guest'
		@title = "Лента событий"
		@title_2 = feed_part_name
		@entity_array = feed_blocks
		@photos = Photo.select(:id)
		@events = Event.where(display_area_id: [2, 3]).order('post_date DESC').limit(3)
		if current_feed_part[:en_name] == 'answers'
			@entity_on_page = 15
		elsif current_feed_part[:en_name] == 'themes' # or current_feed_part[:en_name] == 'comments'
			@entity_on_page = 15
		elsif current_feed_part[:en_name] == 'messages' # or current_feed_part[:en_name] == 'comments'
			@entity_on_page = 15
		elsif current_feed_part[:en_name] == 'albums'
			@entity_on_page = 10
		elsif current_feed_part[:en_name] == 'videos'
			@entity_on_page = 10
		elsif current_feed_part[:en_name] == 'articles' 
			@entity_on_page = 5
		elsif current_feed_part[:en_name] == 'comments' 
			@entity_on_page = 10
		end
	else
		redirect_to '/404'
	end
  end
  
  def media
    setMediaSessionHash
	  @title = @header = "Фото и видео"
    category = session[:media_category]
    if session[:media_photo_albums] == true
      if category == 'all'
        @albums = PhotoAlbum.where(status_id: 1).order('created_at DESC')
      else
        @albums = PhotoAlbum.where(category_id: category, status_id: 1).order('created_at DESC')
      end
    end
    if session[:media_videos] == true
      if category == 'all'
        @videos = Video.all.order('created_at DESC')
      else
        @videos = Video.where(category_id: category).order('created_at DESC')
      end
    end
  end
  
  def search
	  visota_search("Нет ничего лучше борща с грибами, Shit'a Fuck'a", 'all')
  end
end
