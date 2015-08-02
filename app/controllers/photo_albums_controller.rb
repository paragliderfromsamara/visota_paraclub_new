class PhotoAlbumsController < ApplicationController
include ApplicationHelper
include MessagesHelper
  # GET /photo_albums
  # GET /photo_albums.json
  def index
	@title = 'Фотоальбомы'
	@per_page = 10
	case params[:c]
	when 'paragliding'
		@albums = PhotoAlbum.paginate(:page => params[:page], :per_page => @per_page).where(category_id: 5, status_id: 1).order('created_at DESC')
		@category_name = 'Свободные полёты'
	when 'power_paragliding'
		@albums = PhotoAlbum.paginate(:page => params[:page], :per_page => @per_page).where(category_id: 4, status_id: 1).order('created_at DESC')
		@category_name = 'Моторные полёты'
	when 'kiting'
		@albums = PhotoAlbum.paginate(:page => params[:page], :per_page => @per_page).where(category_id: 2, status_id: 1).order('created_at DESC')
		@category_name = 'Кайтинг'		
	when 'club_events'
		@albums = PhotoAlbum.paginate(:page => params[:page], :per_page => @per_page).where(category_id: 3, status_id: 1).order('created_at DESC')
		@category_name = 'Клубные мероприятия'
		
	when 'another'
		@albums = PhotoAlbum.paginate(:page => params[:page], :per_page => @per_page).where(category_id: 1, status_id: 1).order('created_at DESC')
		@category_name = 'Разное'
	else
		@albums = PhotoAlbum.paginate(:page => params[:page], :per_page => @per_page).where(status_id: 1).order('created_at DESC')
		@category_name = 'Все'
	end
  @title = "#{@title}: #{@category_name}"
  @header = @title
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @photo_albums }
    end
  end
  
  def unbinded_to_article_albums
	@photo_albums = PhotoAlbum.where(article_id: nil, status_id: 1)
	respond_to do |format|
      #format.html # index.html.erb
      format.json { render :json => @photo_albums }
    end
  end
  
  # GET /photo_albums/1
  # GET /photo_albums/1.json
  def show
	@album = PhotoAlbum.find_by(id: params[:id], status_id: 1) if !is_admin? 
	@album = PhotoAlbum.find_by(id: params[:id]) if is_admin?
	if userCanSeeAlbum?(@album)
		@page_params = {:part_id => 3,:page_id => 1,:entity_id => @album.id}
		@return_to = photo_album_path(@album)
		@title = @header = @album.name
		@path_array = [
            {:name => 'Медиа', :link => '/media'},
						{:name => 'Фотоальбомы', :link => '/media?t=albums&c=all'},
						{:name => @album.category_name, :link => "/media?t=albums&c=#{@album.category_id}"},
						{:name => @album.name}
					  ]
		respond_to do |format|
		  format.html # show.html.erb
		  format.json { render :json => @album }
		end
	else
		redirect_to '/404'
	end
  end

  # GET /photo_albums/new
  # GET /photo_albums/new.json
  def new
	if !is_not_authorized?
		@title = @header = 'Новый альбом'
		@path_array = [
                    {:name => 'Медиа', :link => '/media'},
        						{:name => 'Новый альбом'}
					        ]
		respond_to do |format|
		  format.html # new.html.erb
		  format.json { render :json => @album }
		end
	else
		redirect_to '/404'
	end
  end

  # GET /photo_albums/1/edit
  def edit
	@albumToForm = PhotoAlbum.find_by(id: params[:id])
	if isEntityOwner?(@albumToForm) 
		@title = @header = 'Изменение фотоальбома'
		@path_array = [
                    {:name => 'Медиа', :link => '/media'},
						        {:name => 'Фотоальбомы', :link => '/media?t=albums&c=all'},
						        {:name => @albumToForm.category_name, :link => "/media?t=albums&c=#{@albumToForm.category_id}"},
						        {:name => @albumToForm.name, :link => photo_album_path(@albumToForm)},
                    {:name => @title},
					  ]
	else
		redirect_to '/404'
	end
  end

  # POST /photo_albums
  # POST /photo_albums.json
  def create
	if !is_not_authorized?
		params[:photo_album][:user_id] = current_user.id
		params[:photo_album][:status_id] = 1
		params[:photo_album][:visibility_status_id] = 1
		@albumToCreate = PhotoAlbum.new(params[:photo_album])
		if params[:photo_editions]!= nil and params[:photo_editions] != []
			photos_params = params[:photo_editions][:photos]
			photos_params.each do |x|
				photo = Photo.find_by_id(x[1][:id])
				if photo != nil
					if photo.description != x[1][:description]
						photo.update_attribute(:description, x[1][:description])
					end
				end
			end
		end
		respond_to do |format|
		  if @albumToCreate.save
			@albumToCreate.assign_entities_from_draft
			@albumToCreate.user.album_draft.clean
			format.html { redirect_to @albumToCreate, :notice => 'Альбом успешно создан' }
			format.json { render :json => @albumToCreate, :status => :created, :location => @albumToCreate }
		  else
			format.html { render :action => "new" }
			format.json { render :json => @albumToCreate.errors, :status => :unprocessable_entity }
		  end
		end
	else
		redirect_to '/404'
	end
  end

  # PUT /photo_albums/1
  # PUT /photo_albums/1.json
  def update
	@albumToForm = PhotoAlbum.find_by(id: params[:id], status_id: 1) if user_type != 'super_admin' and user_type != 'admin'
	@albumToForm = PhotoAlbum.find_by(id: params[:id]) if user_type == 'super_admin' || user_type == 'admin'
  if isEntityOwner?(@albumToForm) 
			if @albumToForm.user_id != (params[:photo_album][:user_id]).to_i
				if @albumToForm.photos != []
					@albumToForm.photos.each do |photo|
						photo.update_attributes(:user_id => params[:photo_album][:user_id])
					end
				end
			end
			if params[:photo_editions] != nil and params[:photo_editions] != []
				photos_params = params[:photo_editions][:photos]
				photos_params.each do |x|
					photo = Photo.find_by_id(x[1][:id])
					if photo != nil
						if photo.description != x[1][:description]
							photo.update_attribute(:description, x[1][:description])
						end
					end
				end
			end
			respond_to do |format|
			  if @albumToForm.update_attributes(params[:photo_album])
			    format.html { redirect_to @albumToForm, :notice => 'Альбом успешно обновлён' }
				  format.json { head :no_content}
			  else
      		@title = @header = 'Изменение фотоальбома'
      		@path_array = [
                          {:name => 'Медиа', :link => '/media'},
      						        {:name => 'Фотоальбомы', :link => '/media?t=albums&c=all'},
      						        {:name => @albumToForm.category_name, :link => "/media?t=albums&c=#{@albumToForm.category_id}"},
      						        {:name => @albumToForm.name, :link => photo_album_path(@albumToForm)},
                          {:name => @title},
      					  ]
				  format.html { render :action => "edit" }
				  format.json { render :json => @albumToForm.errors, :status => :unprocessable_entity }
			  end
			end
		else
			redirect_to '/404'
		end
  end

  # DELETE /photo_albums/1
  # DELETE /photo_albums/1.json
  def destroy
    @photo_album = PhotoAlbum.find_by(id: params[:id])
	if @photo_album.user == current_user || is_admin?
		if @photo_album.destroy
			respond_to do |format|
				format.html { redirect_to '/media?t=albums&c=all' }
				format.json { head :no_content }
			end
    end
	else
		redirect_to '/404'
	end
  end
  def get_albums_list
	if params[:format] == 'json'
		@my_albums = []
		v_status = 1 if is_not_authorized?
		v_status = [1,2] if !is_not_authorized?
		if params[:name] != nil and params[:name] != [] and (params[:name]).mb_chars.length
			qName = (params[:name]).mb_chars.downcase
			albums = PhotoAlbum.select("id, name").where(:status_id => 1).order('name ASC') 
			if albums != []
				matches = []
				likeble = []
				albums.each do |a|
					dwnCaseAlbName = a.name.mb_chars.downcase
					if dwnCaseAlbName == qName
						matches[matches.length] = a
					end
					if isLikebleText?(dwnCaseAlbName, qName) == true and qName.mb_chars.length > 3
						likeble[likeble.length] = a
					end
				end
				@my_albums = matches + likeble
				@my_albums.uniq!
			end
		else 
			@my_albums = Theme.where(status_id: 1).order('name ASC')
		end
		respond_to do |format|
		  #format.html # index.html.erb
		  format.json { render :json => @my_albums }
		end
	else
		redirect_to '/404'
	end
  end
  def recovery
	album = PhotoAlbum.find_by(id: params[:id])
	if album != nil and is_admin?
		album.set_as_visible
	else
		redirect_to '/404'
	end
  end
  
  def upload_photos #загрузка фотографий
	album = PhotoAlbum.find_by(id: params[:id]) 
	if isEntityOwner?(album)
		@photo = Photo.new(:photo_album_id => album.id, :user_id => current_user.id, :link => params[:photo_album][:uploaded_photos])
		if @photo.save
			render :json => {:message => 'success', :photoID => @photo.id }, :status => 200
		else
			render :json => {:error => @photo.errors.full_messages.join(',')}, :status => 400
		end
	else
		redirect_to '/404'
	end
  end
end
