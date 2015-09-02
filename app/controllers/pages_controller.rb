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
	  @title = @header = "Медиа"
    category = session[:media_category]
    @entities = []
    if session[:media_type] == 'videos'
      if category == 'all'
        @entities = Video.paginate(:page => params[:page], :per_page => 12).all.order('created_at DESC')
      else
        @entities  = Video.paginate(:page => params[:page], :per_page => 12).where(category_id: category).order('created_at DESC')
      end
    else
      if category == 'all'
        @entities = PhotoAlbum.paginate(:page => params[:page], :per_page => 5).where(status_id: 1).order('created_at DESC')
      else
        @entities = PhotoAlbum.paginate(:page => params[:page], :per_page => 5).where(category_id: category, status_id: 1).order('created_at DESC')
      end
    end
  end
  
  def search
    @header = @title = "Поиск по сайту"
    @themes = []
    @messages = []
    @articles = []
    @events = []
    @entity_array = []
    @add_functions = "initSearchForm();"
    @entity_on_page = 15
    makeSearchParameters
    if @searchHashParams[:search_query].strip != "" and searchParamsIsNotEmpty?
      @header = @title = "Результат поиска по запросу: \"#{@searchHashParams[:search_query]}\""
      @searchHashParams[:search_query] = @searchHashParams[:search_query].mb_chars.downcase
      @paginationLink = build_search_pagination_link
      if isSearchInTopics?
        searchResult = search_in_themes
        @messages = searchResult[:messages]
        @messages += search_in_old_messages if @searchHashParams[:o_gb]
        @themes = searchResult[:themes]
      end
      @entity_array = @messages + @themes + @articles + @events
      
    else
      flash.now[:alert] = "Введите поисковую фразу" if searchParamsIsNotEmpty? and params[:search_query] == ""
      flash.now[:alert] = "Не выбраны разделы для поиска" if !searchParamsIsNotEmpty? and params[:search_query] != nil
    end
  end
end
