class PagesController < ApplicationController
include PagesHelper
#include EventsHelper
#include PhotoAlbumsHelper
#include VideosHelper

  def index
	  #@title = "Главная"
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
    redirect_to '/404' if user_type != 'super_admin'
  	@title = @header = "Лента событий"
    
  end
  
  def media
    setMediaSessionHash  #обновление перменных сессии
    @mediaPartHash = makeMediaPartHash 
	  @title = @header = "Медиа"
    category = session[:media_category]
    @entities = []
    if @mediaPartHash[:typeName] == 'videos'
      if category == 'all'
        @entities = Video.paginate(:page => params[:page], :per_page => 12).all.order('created_at DESC')
      else
        @entities  = Video.paginate(:page => params[:page], :per_page => 12).where(category_id: category).order('created_at DESC')
      end
    elsif @mediaPartHash[:typeName] == 'albums'
      if category == 'all'
        @entities = PhotoAlbum.paginate(:page => params[:page], :per_page => 6).where(status_id: 1).order('created_at DESC')
      else
        @entities = PhotoAlbum.paginate(:page => params[:page], :per_page => 6).where(category_id: category, status_id: 1).order('created_at DESC')
      end
    elsif @mediaPartHash[:typeName] == 'articles'
      article = Article.new
      v_status = (is_not_authorized?)? 1 : [2,1]
      @articleType = article.getTypeIdByLink(session[:media_type]) 
      @entities = Article.paginate(:page => params[:page], :per_page => 12).where(status_id: 1, :visibility_status_id => v_status, article_type_id: @articleType[:value]).order('created_at DESC')
    end
  end
  
  def search
    redirect_to '/404' if user_type != 'super_admin'
    @header = @title = "Поиск по темам"
    @themes = []
    @messages = []
    @entity_on_page = 15
    @search_string = params[:search_query] == nil ? "" : params[:search_query]
    if !@search_string.blank? != ""
      @header = @title = "Результат поиска по запросу: \"#{@search_string}\""
      searchResult = search_in_themes
      @messages = searchResult[:messages]
      @messages += search_in_old_messages
      @themes = searchResult[:themes]
      @entity_array = @themes
    else
      flash.now[:alert] = "Введите поисковую фразу" if params[:search_query] == ""
      flash.now[:alert] = "Не выбраны разделы для поиска" if params[:search_query] != nil
    end
  end
  
  def wheather
    @header = @title = "Прогноз погоды в Самаре и окрестностях"
  end
  
end
