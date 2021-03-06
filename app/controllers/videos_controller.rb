class VideosController < ApplicationController
include MessagesHelper
include ApplicationHelper
  # GET /videos
  # GET /videos.json
  def index
    redirect_to "/media?t=videos" and return
  @videos = Video.all
	@title = 'Видео'
	@per_page = 18
	@video = Video.new
	case params[:c]
	when 'paragliding'
		@videos = Video.paginate(:page => params[:page], :per_page => @per_page).where(category_id: 5).order('created_at DESC')
		@category_name = 'Свободные полёты'
	when 'power_paragliding'
		@videos = Video.paginate(:page => params[:page], :per_page => @per_page).where(category_id: 4).order('created_at DESC')
		@category_name = 'Моторные полёты'
	when 'kiting'
		@videos = Video.paginate(:page => params[:page], :per_page => @per_page).where(category_id: 2).order('created_at DESC')
		@category_name = 'Кайтинг'		
	when 'club_events'
		@videos = Video.paginate(:page => params[:page], :per_page => @per_page).where(category_id: 3).order('created_at DESC')
		@category_name = 'Клубные мероприятия'
	when 'another'
		@videos = Video.paginate(:page => params[:page], :per_page => @per_page).where(category_id: 1).order('created_at DESC')
		@category_name = 'Разное'
	else
		@videos = Video.paginate(:page => params[:page], :per_page => @per_page).all.order('created_at DESC')
		@category_name = 'Все'
	end
  @header = "#{@title}: #{@category_name}"
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @videos }
    end
  end
  
  # GET /videos/1
  # GET /videos/1.json
  def show
    @video = Video.find_by(id: params[:id])
  	if @video != nil
  		@title = @header = @video.alter_name
  		@return_to = video_path(@video)
  		@page_params = {:part_id => 5, :page_id => 1, :entity_id => @video.id}
  		@path_array = [
                      {:name => 'Медиа', :link => '/media'},
  						        {:name => 'Видео', :link => '/media?t=videos&c=all'},
  						        {:name => @video.category_name, :link => "/media?t=videos&c=#{@video.category_id}"},
  						        {:name => @video.alter_name, :link => '/'}
  					        ]
  		@comments = @video.messages.where(:status_id => 1).order('created_at ASC')
  		respond_to do |format|
  		  format.html # show.html.erb
  		  format.json { render :json => @video }
  		end
    else 
      redirect_to '/404'
  	end
  end

  # GET /videos/new
  # GET /videos/new.json
  def new
  	if !is_not_authorized?
  		@video = Video.new
      @video.mini_link = params[:link] if params[:link] != nil
  		@path_array = [
                      {:name => 'Медиа', :link => '/media'},
          						{:name => 'Новое видео'}
  					        ]
  		@title = @header = 'Новое видео'
  		respond_to do |format|
  		  format.html # new.html.erb
  		  format.json { render :json => {:link_html => @video.mini_link_html} }
  		end
  	else
  		redirect_to '/404'
  	end
  end

  # GET /videos/1/edit
  def edit
    @video = Video.find(params[:id])
    @title = @header = "Изменение видео"
    @users = User.order("name ASC") if is_super_admin?
		@path_array = [
                    {:name => 'Медиа', :link => '/media'},
        						{:name => 'Видео', :link => '/media?t=videos&c=all'},
        						{:name => @video.category_name, :link => "/media?t=videos&c=#{@video.category_id}"},
        						{:name => @video.alter_name, :link => video_path(@video)},
        						{:name => @title}
					        ]
  	redirect_to '/404' if !isEntityOwner?(@video) 
  end

  # POST /videos
  # POST /videos.json
  def create
	if !is_not_authorized?
		params[:video][:user_id] = current_user.id
		@video = Video.new(params[:video])
		respond_to do |format|
		  if @video.save
      sendNewVideoMail(@video)
      alter_text = (@video.description.blank?)? "#{@video.user.name} добавил новое видео" : @video.description
      @video.create_event(post_date: Time.now, content: alter_text, status_id: 1, title: @video.alter_name)
			format.html { redirect_to @video, :notice => 'Видео успешно добавлено' }
			format.json { render :json => @video, :status => :created, :location => @video }
		  else
        	@title = @header = 'Новое видео'
          @path_array = [
                          {:name => 'Медиа', :link => '/media'},
            						  {:name => 'Новое видео'}
    					          ]
			format.html { render :action => "new" }
			format.json { render :json => @video.errors, :status => :unprocessable_entity }
		  end
		end
	else
		redirect_to '/404'
	end
  end

  # PUT /videos/1
  # PUT /videos/1.json
  def update
    @video = Video.find(params[:id])
  	if isEntityOwner?(@video) 
  		respond_to do |format|
  		  if @video.update_attributes(params[:video])
  			  format.html { redirect_to @video, :notice => 'Видео успешно обновлено' }
  			  format.json { head :no_content }
  		  else
          @title = @header = "Изменение видео"
      		@path_array = [
                          {:name => 'Медиа', :link => '/media'},
              						{:name => 'Видео', :link => '/media?t=videos&c=all'},
              						{:name => @video.category_name, :link => "/media?t=videos&c=#{@video.category_id}"},
              						{:name => @video.alter_name, :link => video_path(@video)},
              						{:name => @title}
      					        ]
    			format.html { render :action => "edit" }
    			format.json { render :json => @video.errors, :status => :unprocessable_entity }
  		  end
  		end
  	else
  		redirect_to '/404'
  	end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video = Video.find(params[:id])
  	if isEntityOwner?(@video) || is_admin?
  		@video.destroy
  		respond_to do |format|
  		  format.html { redirect_to '/media?t=videos&c=all' }
  		  format.json { head :no_content }
  		end
  	else
  		redirect_to '/404'
  	end
  end
  
  def new_comment
    @video = Video.find(params[:id])
  	if user_type != 'guest' and user_type != 'bunned'
  		@draft = current_user.message_draft
  		@add_functions = "initMessageForm(#{@draft.id});"
  		@path_array = [
  						{:name => 'Видео', :link => videos_path},
  						{:name => @video.category_name, :link => videos_path(:c => @video.category_path)},
  						{:name => @video.alter_name, :link => video_path(@video)}, 
  						{:name => 'Новый комментарий', :link => '/'} 
  					  ]
  		@message = Message.new
  		@message_to = Message.find_by_id(params[:m])
  	else
  		redirect_to '/404'
  	end
  end
end
