class ThemesController < ApplicationController
include MessagesHelper
include ThemesHelper
include TopicsHelper
  # GET /themes
  # GET /themes.json
  def index
	  @title = @header = 'Все темы'
    @themes = Theme.paginate(:page => params[:page], :per_page => 25).where(:status_id => [1, 4]).order('last_message_date DESC')
		@path_array = [
						        {:name => 'Общение', :link => '/visota_life'},
						        {:name => @title}
					        ]
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @themes }
    end
  end

  # GET /themes/1
  # GET /themes/1.json
  def show
    @theme = Theme.find_by_id(params[:id])
  	if userCanSeeTheme?(@theme)
      @meta_content = (@theme.content.escapeBbCode.blank?)? nil : @theme.content.escapeBbCode
  		@page_params = {:part_id => 9, :page_id => 1, :entity_id => @theme.id}
  		@jsonTheme = {:author => @theme.user.role_card("Автор темы: "), :content => @theme.content_html}
  		@title = @header = @theme.name
  		@path_array = [
  					          {:name => 'Общение', :link => '/visota_life'},
  						        {:name => @theme.topic.name, :link => topic_path(@theme.topic)},
  						        {:name => @theme.name, :link => theme_path(@theme)}
  					        ]
  		#выборка выдаваемых сообщений end
  		respond_to do |format|
  		  format.html# show.html.erb
  		  format.json { render :json => @jsonTheme }
  		end
  	else
  		redirect_to '/404'
  	end
  end

  # GET /themes/new
  # GET /themes/new.json
  def new 
  	@topic = Topic.find_by_id(params[:t])
  	@button_name = 'Создать тему'
  	if userCreateThemeInTopic?(@topic)
  		@path_array = [
  						{:name => 'Клубная жизнь', :link => '/visota_life'},
  						{:name => @topic.name, :link => topic_path(@topic)},
  						{:name => "Новая тема"}
  					  ]
  		@draft = current_user.theme_draft(@topic)
  		@formTheme = @draft 
  		@title = @header = "Новая тема в разделе #{@topic.name}"
  		#@add_functions = "initThemeForm(#{@draft.id}, '.edit_theme');"
  		respond_to do |format|
  		  format.html { render 'new'}# new.html.erb
  		  format.json { render :json => @theme }
  		end
  	else
  		redirect_to '/404'
  	end
  end

  # GET /themes/1/edit
  def edit
    @button_name = 'Сохранить изменения'
    @formTheme = Theme.find(params[:id])
  	if userCanEditTheme?(@formTheme)
  		@topic = @formTheme.topic 
  		@title = @header = "Изменение темы '#{@formTheme.name}'"
  		@path_array = [
  						{:name => 'Клубная жизнь', :link => '/visota_life'},
  						{:name => @topic.name, :link => topic_path(@topic)},
  						{:name => @formTheme.name, :link => theme_path(@formTheme)},
  						{:name => 'Изменение темы'}
  					  ]
  		respond_to do |format|
  			format.html# show.html.erb
  			format.json { render :json => @formTheme }
  		end
  	else
  		redirect_to '/404'
  	end
  end

  # POST /themes
  # POST /themes.json
  def create
  	params[:theme][:status_id] = 1 #Создаёт тему отображаемую в клубной жизни...
  	@topic = Topic.find_by_id(params[:theme][:topic_id])
  	if userCreateThemeInTopic?(@topic) 
  		@theme = Theme.new(params[:theme])
  		@theme.user_id = current_user.id
  		respond_to do |format|
  		  if @theme.save
  			#if params[:photo_editions]!= nil and params[:photo_editions] != []
  			#	photos_params = params[:photo_editions][:photos]
  			#	photos_params.each do |x|
  			#		photo = Photo.find_by_id(x[1][:id])
  			#		if photo != nil
  			#			if photo.description != x[1][:description]
  			#				photo.update_attribute(:description, x[1][:description])
  			#			end
  			#		end
  			#	end
  			#end
  			@theme.assign_entities_from_draft(current_user.theme_draft)
  			format.html { redirect_to @theme, :notice => 'Тема успешно открыта' }
  			format.json { render :json => @theme, :status => :created, :location => @theme }
  		  else
  			@title = "Новая тема в разделе #{@topic.name}"
  			@button_name = 'Создать тему'
  			format.html { render :action => "new"}
  			format.json { render :json => @theme.errors, :status => :unprocessable_entity }
  		  end
  		end
  	else
  		redirect_to '/404'
  	end
  end

  # PUT /themes/1
  # PUT /themes/1.json
  def update
    @formTheme = Theme.find(params[:id])
	if userCanEditTheme?(@formTheme) 
    curStatusId = @formTheme.status_id
    newStatusId = (params[:theme][:status_id] == nil)? curStatusId : params[:theme][:status_id].to_i  
    if curStatusId == 0 && newStatusId == 1
      notice = 'Тема успешно добавлена' 
      params[:theme][:created_at] = params[:theme][:updated_at] = Time.now
      sMail = true
    else
      notice = 'Тема успешно обновлена' 
      params[:theme][:updater_id] = current_user.id
      sMail = false
    end
		respond_to do |format|
		  if @formTheme.update_attributes(params[:theme])
        if sMail
          sendNewThemeMail(@formTheme)
          @formTheme.theme_notifications.create(:user_id =>  @formTheme.user_id)
        end
			#if params[:photo_editions] != nil and params[:photo_editions] != []
			#	photos_params = params[:photo_editions][:photos]
			#	photos_params.each do |x|
			#		photo = Photo.find_by_id(x[1][:id])
			#		if photo != nil
			#			if photo.description != x[1][:description]
			#				photo.update_attribute(:description, x[1][:description])
			#			end
			#		end
			#	end
			#end
			format.html { redirect_to @formTheme, :notice => notice }
			format.json { head :no_content }
		  else
			@topic = @formTheme.topic
			@alter_logo = @topic.image if @topic.image? 
			@title = "Изменение темы '#{@formTheme.name}'"
			@button_name = 'Обновить тему'
			@add_functions = "initThemeForm(#{@formTheme.id}, '#edit_theme_#{@formTheme.id}');"
			format.html { render :action => "edit"}
			format.json { render :json => @theme.errors, :status => :unprocessable_entity }
		  end
		end
	else
		redirect_to '/404'
	end
  end

  # DELETE /themes/1
  # DELETE /themes/1.json
  def destroy 
    @theme = Theme.find(params[:id])
  	link = topic_path(@theme.topic)
    if userCanDeleteTheme?(@theme)
      if is_admin? && current_user != @theme.user
        if @theme.status_id == 1 || @theme.status_id == 3 
          @theme.update_attribute(:status_id, 2)
        elsif @theme.status_id == 2 and user_type == 'super_admin'
          @theme.destroy 
        end
      else
        @theme.destroy          
      end    
      respond_to do |format|
    		format.html { redirect_to link }
    		format.json { head :no_content }
    	end
    else
      redirect_to '/404' 
    end
  end
  def recovery
    @theme = Theme.find(params[:id])
    redirect_to '/404' if user_type != "super_admin" || @theme.nil?
    redirect_to @theme if @theme.update_attribute(:status_id, 1)
  end
#Работа с темами----------------------------  
  def merge_themes
	@theme = Theme.find_by(id: params[:id])
	if @theme != nil and is_admin?
		@title = @header = 'Объединение тем'
		@collection = []
		@themes_collection = []
		@default = {:value => @theme.topic.id, :name => @theme.topic.name}
		topics = Topic.all.order('name ASC')
		topics.each do |topic|
			@collection[@collection.length] = {:value => topic.id, :name => topic.name}
		end
		@path_array = [
						{:name => 'Клубная жизнь', :link => '/visota_life'},
						{:name => @theme.topic.name, :link => topic_path(@theme.topic)},
						{:name => @theme.name, :link => theme_path(@theme)},
						{:name => 'Объединение темы'}
					  ]
		base_themes_list = @theme.topic.themes.where(:status_id => 1)
		if base_themes_list != []
			base_themes_list.each do |thm|
				@themes_collection[@themes_collection.length] = {:value => thm.id, :name => thm.name}
			end
		end
		respond_to do |format|
		  format.html # new.html.erb
		  format.json { render :json => @theme }
		end
	else
		redirect_to '/404'
	end
  end
  
  def do_merge_themes
	current_theme = Theme.find_by(id: params[:merge_theme][:current_theme])
	new_topic = Topic.find_by(id: params[:merge_theme][:topic_id])
	new_theme = Theme.find_by(id: params[:merge_theme][:theme_id])
	if is_admin? and current_theme != nil and new_topic != nil
    th  = current_theme.merge(new_topic, new_theme)
     redirect_to theme_path(th) if !th.nil?
	else
		redirect_to '/404'
	end
  end
  
  def get_themes_list
	if params[:format] == 'json'
		@my_themes = []
		v_status = 1 if is_not_authorized?
		v_status = [1,2] if !is_not_authorized?
		if params[:name] != nil and params[:name] != [] and (params[:name]).mb_chars.length
			qName = (params[:name]).mb_chars.downcase
			themes = Theme.select("id, name").where(:status_id => [1, 3], :topic_id => params[:topic], :visibility_status_id => v_status).order('name ASC') 
			if themes != []
				matches = []
				likeble = []
				themes.each do |t|
					dwnCaseThName = t.name.mb_chars.downcase
					if dwnCaseThName == qName
						matches[matches.length] = t
					end
					if isLikebleText?(dwnCaseThName, qName) == true and qName.mb_chars.length > 3
						likeble[likeble.length] = t
					end
				end
				@my_themes = matches + likeble
				@my_themes.uniq!
			end
			
		#	@my_themes = Theme.find_all_by_topic_id_and_status_id_and_name(params[:topic], 1, params[:name], :order => 'name ASC')
		else 
			@my_themes = Theme.where(topic_id: params[:topic], status_id: 1).order('name ASC')
		end
		respond_to do |format|
		  #format.html # index.html.erb
		  format.json { render :json => @my_themes }
		end
	else
		redirect_to '/404'
	end
  end
  
  def theme_switcher #Закрывает/Открывает темы
		theme = Theme.find_by_id(params[:id])
		to_do = params[:to_do]
		if theme != nil
			if userCanSwitchTheme?(theme)
				theme.do_close(current_user) if to_do == 'close'
				theme.do_open(current_user) if to_do == 'open'
				redirect_to theme
			else
				redirect_to '/404'
			end
		else
			redirect_to '/404'
		end
  end
#Работа с темами end------------------------ 
  
  def new_message
	@theme = Theme.find(params[:id])
  redirect_to @theme
	#if user_type != 'bunned' and user_type != 'guest' and @theme != nil
	#	@path_array = [
	#					{:name => 'Клубная жизнь', :link => '/visota_life'},
	#					{:name => @theme.topic.name, :link => topic_path(@theme.topic)},
	#					{:name => @theme.name, :link => theme_path(@theme)}, 
	#					{:name => 'Новое сообщение', :link => '/'}
	#				  ]
	#	@message_to = Message.find_by_id_and_status_id_and_theme_id(params[:m], 1, @theme.id)
	#	@message = Message.new
	#	@tmpMessage = current_user.message_draft
	#			if @tmpMessage.theme_id != @theme.id and @tmpMessage.topic_id != @theme.topic_id
	#				@tmpMessage.clean
	#				@tmpMessage.update_attributes(:theme_id => @theme.id, :topic_id => @topic_id, :message_id => nil, :content => '')
	#			end
	#	@add_functions = "initMessageForm(#{@tmpMessage.id.to_s})"
	#	respond_to do |format|
	#	  format.html # new_message.html.erb
	#	  format.json { render :json => @message }
	#	end
	#else
	#	redirect_to '/404'
	#end	
  end
  def upload_photos
	theme = Theme.find_by_id(params[:id]) 
	if isThemeOwner?(theme)
		@photo = Photo.new(:user_id => theme.user.id, :link => params[:theme][:uploaded_photos])
		if @photo.save
      theme.entity_photos.create(photo_id: @photo.id, visibility_status_id: 1)
			render :json => {:message => 'success', :photoID => @photo.id }, :status => 200
		else
			render :json => {:error => @photo.errors.full_messages.join(',')}, :status => 400
		end
	else
		redirect_to '/404'
	end
  end
  def upload_attachment_files
  	theme = Theme.find_by(id: params[:id]) 
  	if isEntityOwner?(theme)
  		@attachmentFile = AttachmentFile.new(:theme_id => theme.id, :user_id => theme.user.id, uploaded_file: params[:theme][:attachment_files], directory: "themes")
  		if @attachmentFile.save
  			render :json => {:message => 'success', :attachmentID => @attachmentFile.id }, :status => 200
  		else
  			render :json => {:error => @attachmentFile.errors.full_messages.join(',')}, :status => 400
  		end
  	else
  		redirect_to '/404'
  	end
  end
  def make_article
    @theme = Theme.find(params[:id])
    @title = @header = 'Создание статьи из темы'
    if @theme != nil and is_admin?
      art = Article.new
      tId = (params[:article_type] == nil)? 0 : params[:article_type][:article_type_id].to_i
      @type = (art.get_type_by_id(tId) == nil)? {} : art.get_type_by_id(tId)
  		@path_array = [
  						        {:name => 'Клубная жизнь', :link => '/visota_life'},
  						        {:name => @theme.topic.name, :link => topic_path(@theme.topic)},
  						        {:name => @theme.name, :link => theme_path(@theme)},
  						        {:name => 'Создание статьи из темы'}
  					        ]
      @formArticle = @theme.update_article_draft(current_user.article_draft(@type[:value]))
  		respond_to do |format|
  		  format.html # make_article.html.erb
  		end
    else 
      redirect_to @theme if !@theme.nil?
      redirect_to '/404'
    end
  end
  def make_album
    @theme = Theme.find(params[:id])
    @title = @header = 'Создание фотоальбома из темы'
    if @theme != nil and is_admin?
  		@path_array = [
  						        {:name => 'Клубная жизнь', :link => '/visota_life'},
  						        {:name => @theme.topic.name, :link => topic_path(@theme.topic)},
  						        {:name => @theme.name, :link => theme_path(@theme)},
  						        {:name => 'Создание статьи из темы'}
  					        ]
      @albumToForm = @theme.update_album_draft(current_user.album_draft)
  		respond_to do |format|
  		  format.html # make_article.html.erb
  		end
    else 
      redirect_to @theme if !@theme.nil?
      redirect_to '/404'
    end
  end
end
