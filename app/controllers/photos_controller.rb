class PhotosController < ApplicationController
include MessagesHelper
  # GET /photos
  # GET /photos.json
  def index
    redirect_to '/media?t=albums' and return
    	@js_photos = [{:id => 'null'}] #application.js getMsgPhotosToForm(msgId, el)
    	jsPhotos = []
    	if params[:message_id] != nil
    		@photos = Photo.find_all_by_message_id(params[:message_id])
    	elsif params[:photo_album_id] != nil
    		@photos = Photo.find_all_by_photo_album_id(params[:photo_album_id])
    	else
    		 @photos = Photo.all
    	end
    	if @photos != [] and params[:format] == 'json'
    		@photos.each do |photo|
    			jsPhotos[jsPhotos.length] = {:id => photo.id, :link => photo.link.to_s, :thumb => photo.link.thumb.to_s, :description => photo.description}
    		end
    		@js_photos = jsPhotos
	
    	end
        respond_to do |format|
          format.html # index.html.erb
          format.json { render :json => @js_photos }
        end
      end

  # GET /photos/1
  # GET /photos/1.json
  def show
    @photo = Photo.find_by(id: params[:id])
	if userCanSeePhoto?(@photo) and params[:e] != nil and params[:e_id] != nil
    @page_params = {:part_id => 4,:page_id => 1,:entity_id => @photo.id}
		@photos = []
		@j_photo = {:id => @photo.id, :link => @photo.link.to_s, :thumb => @photo.link.thumb.to_s, :description => @photo.description}
		@prev_photo = nil
		@next_photo = nil
		@return_to = photo_path(id: @photo.id, e: params[:e], e_id: params[:e_id])
        @page_image = @photo.link.to_s
    @link = ""
		case params[:e]
    when 'photo_album'
      @album = PhotoAlbum.find(params[:e_id])
      if !@album.nil?
        @photos = @album.photos
        @link = "<a href = '#{photo_album_path(@album)}'><li>К альбому</li></a>"
      end
    when 'theme'
      @theme = Theme.find(params[:e_id])
      if !@theme.nil?
        @photos = @theme.photos
        @link = "<a href = '#{photo_album_path(@theme)}'><li>К теме</li></a>"
      end
    when 'message'
      @photo_msg = Message.find(params[:e_id])
      if !message.nil?
        @photos = message.photos
        @message_to = message
        if !@message_to.theme.nil?
          @theme = @message_to.theme 
          @link = "<a href = '#{photo_album_path(@theme)}'><li>К теме</li></a>"
        end
      end
    when 'article'
      @article = Article.find(params[:e_id])
      if !@article.nil?
        @photos = @article.photos
        @link = "<a href = '#{photo_album_path(@album)}'><li>К материалу</li></a>"
      end
    end
		if @photos != []
			@prev_photo = photo_path(id: @photos[@photos.index(@photo) - 1].id, e: params[:e], e_id: params[:e_id]) if @photos.index(@photo) > 0
			@next_photo = photo_path(id: @photos[@photos.index(@photo) + 1].id, e: params[:e], e_id: params[:e_id]) if @photos.index(@photo) < (@photos.length - 1)
    end
		respond_to do |format|
      if @photos != []
		    format.html {render :layout => 'photo_show'}# show.html.erb
		    format.json { render :json => @j_photo }
      else
        format.html {redirect_to '/404'}# show.html.erb
      end
		end
	else
		@j_photo = {:id => 'null', :link => 'null', :thumb => 'null'}
		respond_to do |format|
			  format.html {redirect_to '/404'}
			  format.json { render :json => @j_photo }
		end
	end
	 
	
  end

  # GET /photos/new
  # GET /photos/new.json
  def new
    #@photo = Photo.new
    #respond_to do |format|
    #  format.html # new.html.erb
    #  format.json { render :json => @photo }
    #end
  end

  # GET /photos/1/edit
  def edit
   # @photo = Photo.find(params[:id])
  end

  def edit_photos
	@theme = nil
	@album = nil
	@event = nil
	@message = nil
	@article = nil
	@link_to = nil
	@photos = []
	@entity = params[:e]
	case @entity
	when "theme" #Фотографии в теме...
		@theme = Theme.find_by(id: params[:e_id])
		redirect_to '/404' if !isEntityOwner?(@theme)
		@photos = @theme.entity_photos
		@link_to = theme_path(@theme.id)
	when "photo_album" #Фотографии в альбоме...
		@album = PhotoAlbum.find_by(id: params[:e_id])
		redirect_to '/404' if !isEntityOwner?(@album)
		@photos = @album.entity_photos
		@link_to = photo_album_path(@album.id)
	when "message" #Фотографии в теме...
		@message = Message.find_by(id: params[:e_id])
		redirect_to '/404' if !isEntityOwner?(@message)
		@photos = @message.entity_photos
		@link_to = theme_path(@message.theme_id) if @message.theme != nil
    @link_to = photo_album_path(@message.photo_album_id) if @message.photo_album != nil
    @link_to = photo_path(@message.photo) if @message.photo != nil
    @link_to = video_path(@message.video_id) if @message.video != nil
	when "article" #Фотографии в статье...
		@article = Article.find_by(id: params[:e_id])
		redirect_to '/404' if !isEntityOwner?(@article)
		@photos = @article.entity_photos
		@link_to = article_path(@article)
	when "event" #Фотографии в Новостях...
		@event = Event.find_by(id: params[:e_id])
		redirect_to '/404' if !is_admin? and user_type != 'manager'
		@photos = @event.entity_photos
		@link_to = event_path(@event)
	end
	redirect_to '/404' if @theme == nil && @album == nil && @event == nil && @message == nil && @article == nil
  end
  
  def update_photos
	if user_type != 'guest' and user_type != 'bunned'
		photos_params = params[:photo_editions][:photos]
		flag = 'no_changes'
		photos_params.each do |x|
				photo = Photo.find_by(id: x[1][:id])
				if photo != nil
					if photo.name != x[1][:name] or photo.description != x[1][:description]
						flag = 'updated'
						photo.update_attributes(:name => x[1][:name], :description => x[1][:description])
					end
				end
		end
		respond_to do |format|
			format.html { redirect_to params[:photo_editions][:link_to] }
			format.json { render :json => {:status => :flag}}
		end
	else
		redirect_to '/404'
	end
  end
  
  # POST /photos
  # POST /photos.json
  def create
	  #if user_type != 'guest' and user_type != 'bunned'
		#params[:photo][:user_id] = current_user.id	
		#@photo = Photo.new(params[:photo])
		#respond_to do |format|
		#  if @photo.save
		#	format.html { redirect_to @photo, :notice => 'Фото успешно добавлено' }
		#	format.json { render :json => @photo, :status => :created, :location => @photo }
		#  else
		#	format.html { render :action => "new" }
		#	format.json { render :json => @photo.errors, :status => :unprocessable_entity }
		#  end
		#end
    #else 
		#redirect_to '/404'
    #end
  end

  # PUT /photos/1
  # PUT /photos/1.json
  def update
    @photo = Photo.find(params[:id])
    if isEntityOwner?(@photo)
      respond_to do |format|
        if @photo.update_attributes(params[:photo])
          format.html { redirect_to @photo }
          format.json { head :no_content }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @photo.errors, :status => :unprocessable_entity }
        end
      end
    else
      redirect_to '/404'
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo = Photo.find(params[:id])
    if userCanDeletePhoto?(@photo) || is_admin?
			if @photo.destroy
				respond_to do |format|
				  format.html { redirect_to '/media?t=albums' }
				  format.json { render :json => {:callback => 'success'} }
				end
			end
    else
      redirect_to '/404'
		end
  end
  
  def recovery
		redirect_to '/404'
  end
end
