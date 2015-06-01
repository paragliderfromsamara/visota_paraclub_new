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
    @topImage = '4.jpg'
  end
	
  def contacts
    @title = "Контакты"
    @topImage = '3.jpg'
  end

  def about_us
    @topImage = '2.jpg'
	  @title = "О клубе"
    
  end
  
  def paragliding
	  @title = "Немного о парапланеризме"
    @topImage = '5.jpg'
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
		@events = Event.find_all_by_display_area_id(([2, 3]), :order => 'post_date DESC', :limit => 3)
		if current_feed_part[:en_name] == 'answers'
			@entity_on_page = 15
		elsif current_feed_part[:en_name] == 'themes' # or current_feed_part[:en_name] == 'comments'
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
  
  def visota_life
	@title = "Клубная жизнь"
  end
  
  def search
	visota_search("Нет ничего лучше борща с грибами, Shit'a Fuck'a", 'all')
  end
end
