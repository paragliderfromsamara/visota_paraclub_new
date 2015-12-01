class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.json
  def index
    redirect_to "/media?t=articles&c=3"
  #article = Article.new
	#@curArtCat = article.types.first
	#article.types.each do |t|
	#	if params[:c] == t[:link]
	#		@curArtCat = t
	#		break
	#	end
	#end  
	#  @title = @header = @curArtCat[:multiple_name]
  #  vStatus = (is_not_authorized?)? [1]:[1,2]
	#  @articles = Article.where(article_type_id: @curArtCat[:value], status_id: 1, visibility_status_id: vStatus).order('accident_date DESC')
	#  respond_to do |format|
  #    format.html # index.html.erb
  #    format.json { render :json => @articles }
  #  end
  end


  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.find_by(id: params[:id])
    if userCanSeeArticle(@article)
  	  @photos = Photo.select(:id)
  	  @path_array = [
                      {:name => 'Медиа', :link => '/media'},
  					          {:name => @article.type_name_multiple, :link => "/media?t=#{@article.type[:link]}"},
  					          {:name => @article.alter_name, :link => article_path(@article)}
  				          ]
    	@title = @header = @article.alter_name
      respond_to do |format|
        format.html # show.html.erb
        format.json { render :json => @article }
      end
    else
      redirect_to '/404'
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
	art = Article.new
	@type = art.get_type_by_id(params[:c])
	if userCanCreateArticle? and @type != nil
	  @title = @header = "#{@type[:form_title]}"
    @path_array = [
                    {:name => 'Медиа', :link => '/media'},
					          {:name => @type[:multiple_name], :link => "/media?t=#{@type[:link]}"},
					          {:name => "#{@header}"}
				          ]
		respond_to do |format|
		  format.html # new.html.erb
		  format.json { render :json => @formArticle }
		end
	else
		redirect_to '/404'
	end
  end

  # GET /articles/1/edit
  def edit
    @formArticle = Article.find(params[:id])
	if userCanEditArtilcle?(@formArticle)
    @title = @header = "Изменение материала"
		@type = @formArticle.type
		@draft = @formArticle
    redirect_to '/404' if @type == nil 
    @path_array = [
                    {:name => 'Медиа', :link => '/media'},
					          {:name => @type[:multiple_name], :link => "/media?t=#{@type[:link]}"},
                    {:name => @formArticle.alter_name, :link => article_path(@formArticle)},
					          {:name => "#{@header}"}
				          ]
	else 
		redirect_to '/404'
	end
	
  end

  # POST /articles
  # POST /articles.json
  def create
	if user_type != 'guest' and user_type != 'bunned'
		params[:article][:user_id] = current_user.id
    params[:article][:status_id] = 1
		@article = Article.new(params[:article])
		params[:v] = params[:article][:article_type_id]
		@type = @article.get_type_by_id(params[:v])
		respond_to do |format|
		  if @article.save
			format.html { redirect_to @article, :notice => 'Материал успешно добавлен' }
			format.json { render :json => @article, :status => :created, :location => @article }
		  else
			format.html { render :action => "new"  }
			format.json { render :json => @article.errors, :status => :unprocessable_entity }
		  end
		end
	else
		redirect_to '/404'
	end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = Article.find(params[:id])
	if userCanEditArtilcle?(@article)
		respond_to do |format|
		  if @article.update_attributes(params[:article])
			format.html { redirect_to @article, :notice => 'Статья успешно добавлена' }
			format.json { head :no_content }
		  else
			format.html { render :action => "edit" }
			format.json { render :json => @article.errors, :status => :unprocessable_entity }
		  end
		end
	else
		redirect_to '/404'
	end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find_by(id: params[:id])
    if userCanDeleteArticle(@article)
  	  type = @article.get_type_by_id(@article.article_type_id)
      @article.destroy

      respond_to do |format|
        format.html { redirect_to articles_path(:c=>type[:link]) }
        format.json { head :no_content }
      end
    else
      redirect_to '/404'
    end
  end
  def upload_photos
  	article = Article.find_by(id: params[:id]) 
  	if isEntityOwner?(article)
  		@photo = Photo.new(:article_id => article.id, :user_id => article.user.id, :link => params[:article][:uploaded_photos], :status_id => 1)
  		if @photo.save
  			render :json => {:message => 'success', :photoID => @photo.id }, :status => 200
  		else
  			render :json => {:error => @photo.errors.full_messages.join(',')}, :status => 400
  		end
  	else
  		redirect_to '/404'
  	end
  end
  def upload_attachment_files
  	article = Article.find_by(id: params[:id]) 
  	if isEntityOwner?(article)
  		@attachmentFile = AttachmentFile.new(:article_id => article.id, :user_id => article.user.id, uploaded_file: params[:article][:attachment_files], directory: "articles")
  		if @attachmentFile.save
  			render :json => {:message => 'success', :attachmentID => @attachmentFile.id }, :status => 200
  		else
  			render :json => {:error => @attachmentFile.errors.full_messages.join(',')}, :status => 400
  		end
  	else
  		redirect_to '/404'
  	end
  end
  def bind_videos_and_albums
    article = Article.find_by(id: params[:id])  
  	if isEntityOwner?(article) and params[:format] == 'json'
  		@albums = PhotoAlbum.where(article_id: [nil, article.id], status_id: 1)
  		@videos = Video.where(article_id: [nil, article.id])
  		a = []
  		v = []
  		@albums.each {|al| a[a.length] = {:id => al.id, :name => al.name, :link => photo_album_path(al)}} if @albums != []
  		@videos.each {|vi| v[v.length] = {:id => vi.id, :name => vi.alter_name, :link => video_path(vi)}} if @videos != [] 
  		render :json => {:albums => a, :videos => v}
  	else
  		redirect_to '/404'
  	end
  end
end
