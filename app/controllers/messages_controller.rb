class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json
  def index #has test 31.10.2015
    redirect_to "/visota_life"
    #@messages = Message.all #Ищем все первые сообщения в обсуждениях
    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render :json => @messages }
    #end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = Message.find_by(id: params[:id])
	if userCanSeeMessage?(@message) and params[:preview_mode] == 'true'
		#themes part
		@theme = Theme.find_by(id: @message.theme_id, status_id: ([1, 3]))
    @photo_album = @message.photo_album
    @photo = Photo.find_by(id: @message.photo_id, status_id: 1)
		if @theme != nil
			@title = @header = "Ответы на сообщение от #{@message.created_at.to_s(:ru_datetime)}"
			@path_array = [
							        {:name => 'Клубная жизнь', :link => '/visota_life'},
						          {:name => @theme.topic.name, :link => topic_path(@theme.topic)},
					            {:name => @theme.name, :link => theme_path(@theme)},
					            {:name => @title, :link => ''}
					          ]
		end
		#themes part end
		#photos part
    if @photo_album != nil
      if @photo != nil
    			@title = @header = "Комментарий к фото"
    			@path_array = [
                          {:name => 'Медиа', :link => '/media'},
		                      {:name => 'Фотоальбомы', :link => '/media?t=albums&c=all'},
		                      {:name => @photo_album.category_name, :link => "/media?t=albums&c=#{@photo_album.category_id}"},
		                      {:name => @photo_album.name,:link => photo_album_path(@photo_album)},
                          {:name => @title}
    					          ]
      else
  			@title = @header = "Комментарий к фотоальбому"
    		@path_array = [
                        {:name => 'Медиа', :link => '/media'},
    						        {:name => 'Фотоальбомы', :link => '/media?t=albums&c=all'},
    						        {:name => @photo_album.category_name, :link => "/media?t=albums&c=#{@photo_album.category_id}"},
    						        {:name => @photo_album.name, :link => photo_album_path(@photo_album)},
                        {:name => @title}
    					        ]
      end
		
		end

		#photos part end
		#videos part
		@video = Video.find_by(id: @message.video_id)
		if @video != nil
			@title = "Ответы комментарий от #{@message.created_at.to_s(:ru_datetime)}"
			@path_array = [
							{:name => 'Видео', :link => videos_path},
							{:name => @video.category_name, :link => videos_path(:c => @video.category_path)},
							{:name => @video.alter_name, :link => video_path(@video)},
							{:name => @title, :link => '/'}
						  ]
		end
		#videos part end
		@messages = @message.get_visible_tread
		respond_to do |format|
		  format.html # show.html.erb
		  format.json { render :json => @message }
		end
	else
		redirect_to '/404'
	end
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
	#@button_name = 'Создать'
	#if user_type != 'bunned' and user_type != 'guest' and (@message_to || @theme_to || @photo_to || @album_to)
	#	@message = Message.new
		#if @message_to.theme != nil
			#redirect_to '/404' and return if @message_to.theme.status_id != 1 
		#end
	#	respond_to do |format|
	#	  format.html # new.html.erb
	#	  format.json { render :json => @message }
	#	end
	#else
		redirect_to '/visota_life'
  #end
  end

  # GET /messages/1/edit
  def edit
    @formMessage = Message.find_by(id: params[:id], status_id: 1)
  	if userCanEditMsg?(@formMessage)
  			@theme = Theme.find_by(id: @formMessage.theme_id, status_id: 1)
  			@photo = Photo.find_by(id: @formMessage.photo_id, status_id: 1)
        @album = PhotoAlbum.find_by(id: @formMessage.photo_album_id, status_id: 1)
  			@video = Video.find_by(id: @formMessage.video_id)
  			if @theme != nil
  				@title = @header = 'Изменение сообщения'
  				@topic = Topic.find_by(id: @formMessage.topic_id)
  				@path_array = [
  								{:name => 'Общение', :link => '/visota_life'},
  								{:name => @theme.topic.name, :link => topic_path(@theme.topic)},
  								{:name => @theme.name, :link => theme_path(@theme)},
  								{:name => @title, :link => '#'}
  							  ]
  			end
  			if @album != nil
          @title = @header = 'Изменение комментария'
    			@path_array = [
                          {:name => 'Медиа', :link => '/media'},
            						  {:name => 'Видео', :link => '/media?t=videos&c=all'},
            						  {:name => @album.category_name, :link => "/media?t=albums&c=#{@album.category_id}"},
            						  {:name => @album.name, :link => photo_album_path(@album)},
            						  {:name => @title}
    						        ]
  			end
  			if @video != nil
          @title = @header = 'Изменение комментария'
    			@path_array = [
                          {:name => 'Медиа', :link => '/media'},
            						  {:name => 'Видео', :link => '/media?t=videos&c=all'},
            						  {:name => @video.category_name, :link => "/media?t=videos&c=#{@video.category_id}"},
            						  {:name => @video.alter_name, :link => video_path(@video)},
            						  {:name => @title}
    						        ]
  			end				
  	else
  		redirect_to '/visota_life'
  	end
  end

  # POST /messages
  # POST /messages.json
  def create
	if user_type != 'guest' and user_type != 'bunned'
		@button_name = 'Создать'
		params[:message][:user_id] = current_user.id
		@message_to = Message.find_by(id: params[:message][:message_id], status_id: 1) 	#ищем ответ ли это на сообщение.
		@theme = Theme.find_by(id: params[:message][:theme_id], status_id: 1)				#ищем тему.
		@photo = Photo.find_by(id: params[:message][:photo_id], status_id: 1)				#ищем фотографию.
		@album = PhotoAlbum.find_by(id: params[:message][:photo_album_id], status_id: 1)  #ищем фотоальбом.
    @video = Video.find_by(id: params[:message][:video_id])
    @createNotice = 'Сообщение успешно добавлено...'
		if @theme != nil
			@path_array = [
							{:name => 'Общение', :link => '/visota_life'},
							{:name => @theme.topic.name, :link => topic_path(@theme.topic)},
							{:name => @theme.name, :link => theme_path(@theme)}, 
							{:name => 'Новое сообщение', :link => '/#'}
						  ]
		end
		if @album != nil
      @createNotice = 'Комментарий успешно добавлен...'
			@path_array = [
                    {:name => 'Медиа', :link => '/media'},
        						{:name => 'Видео', :link => '/media?t=videos&c=all'},
        						{:name => @video.category_name, :link => "/media?t=videos&c=#{@video.category_id}"},
        						{:name => @video.alter_name, :link => video_path(@video)},
        						{:name => @title}
						  ]
			if @photo != nil
				
			end
		end
    if @video != nil
      @createNotice = 'Комментарий успешно добавлен...'
			@path_array = [
                    {:name => 'Медиа', :link => '/media'},
        						{:name => 'Видео', :link => '/media?t=videos&c=all'},
        						{:name => @video.category_name, :link => "/media?t=videos&c=#{@video.category_id}"},
        						{:name => @video.alter_name, :link => video_path(@video)},
        						{:name => @title}
						  ]
    end
		if @message_to != nil
			if @message_to.photo != nil
				params[:message][:photo_id] = @message_to.photo_id
				#params[:message][:photo_album_id] =  @message_to.photo_album_id
			end
		end
		@message = Message.new(params[:message])
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
		  if @message.save
			link = params[:info][:return_to_link] if params[:info] != nil 
			#link = "#{theme_path(@message.theme_id)}#msg_#{@message.id}" if @message.theme != nil
			#link = "#{video_path(@message.video_id)}#msg_#{@message.id}" if @message.video != nil
			#link = "#{photo_path(@message.photo_id)}" if @message.photo != nil
			#link = "#{photo_path(@message.photo_album_id)}" if @message.photo_album != nil
			#@message.assign_entities_from_draft(current_user.message_draft)	#ищем черновик и привязываем		
			@theme.last_msg_upd if @theme != nil
			format.html { redirect_to link + "#msg_#{@message.id}", :notice => @createNotice}
			format.json { render :json => @message, :status => :created, :location => @message }
		  else
			format.html { render :action => "new" }
			format.json { render :json => @message.errors, :status => :unprocessable_entity }
		  end
		end
	else
		redirect_to '/404'
	end
  end

  # PUT /messages/1
  # PUT /messages/1.json
  def update
    @message = Message.find(params[:id])
  	if userCanEditMsg?(@message)
  		params[:message][:updater_id] = current_user.id if @message.status_id == 1
      old_status_id = @message.status_id
      new_status_id = 0
      new_status_id = params[:message][:status_id].to_i if params[:message][:status_id] != nil
      if new_status_id > old_status_id
        sMail = true
        noticeText = "Сообщение успешно добавлено."
      else
        sMail = false
        noticeText = "Сообщение успешно обновлено."
      end
  		respond_to do |format|
  		  if @message.update_attributes(params[:message])
          sendNewMessageMail(@message) if sMail
          newTime = Time.now
          @message.update_attributes(created_at: newTime, updated_at: newTime) if new_status_id > old_status_id
    			link = "#{theme_path(@message.theme_id)}#msg_#{@message.id}" if @message.theme != nil
    			link = "#{video_path(@message.video_id)}#msg_#{@message.id}" if @message.video != nil
          link = "#{photo_album_path(@message.photo_album_id)}#msg_#{@message.id}" if @message.photo_album != nil
          link = "#{photo_path(@message.photo_id)}#msg_#{@message.id}" if @message.photo != nil
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
          jsonData = {
                      content: @message.content_html
                     }
    			#link = message_path(@message.id)
    			#link = "#{theme_path(@message.theme_id)}#msg_#{@message.id}" if @message.theme != nil
    			#link = "#{video_path(@message.video_id)}" if @message.video != nil
    			#link = "#{photo_path(@message.photo_id)}" if @message.photo != nil
    			format.html { redirect_to link, :notice => noticeText}
    			format.json { render :json => jsonData }
  		  else
    			#current_user.message_draft.clean
    			@message_to = Message.find_by(id: params[:message][:message_id], status_id: 1)
    			@theme = Theme.find_by(id: @message.theme_id, status_id: 1)
    			@photo = Photo.find_by(id: @message.photo_id, status_id: 1)
    			@video = Video.find_by(id: @message.video_id)
          @album = PhotoAlbum.find_by(id: @formMessage.photo_album_id, status_id: 1)
    			if @theme != nil
    				@title = 'Изменение сообщения'
    				@topic = Topic.find_by(id: @message.topic_id)
    				@path_array = [
    						    {:name => 'Общение', :link => '/visota_life'},
    								{:name => @theme.topic.name, :link => topic_path(@theme.topic)},
    								{:name => @theme.name, :link => theme_path(@theme)},
    								{:name => @title, :link => '#'}
    							  ]
    			end
    			if @photo != nil
          
    			end
    			if @video != nil
    				@title = @header = 'Изменение комментария'
    				@path_array = [
                          {:name => 'Медиа', :link => '/media'},
              						{:name => 'Видео', :link => '/media?t=videos&c=all'},
              						{:name => @video.category_name, :link => "/media?t=videos&c=#{@video.category_id}"},
              						{:name => @video.alter_name, :link => video_path(@video)},
              						{:name => @title}
    							        ]
    			end				
    			format.html { render :action => "edit" }
    			format.json { render :json => @message.errors, :status => :unprocessable_entity }
    		  end
  		end
  	else
  		redirect_to "/404"
  	end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
	  ent = @message.theme if @message.theme != nil
	  ent = @message.photo if @message.photo != nil
	  ent = @message.photo_album if @message.photo_album != nil
    ent = @message.video if @message.video != nil
  	if userCanDeleteMessage?(@message)
  		if is_admin?
  			if @message.status_id == 3
  				@message.destroy
  			else
  				@message.set_as_delete
  			end 
  		else
  			@message.destroy
  		end
  		respond_to do |format|
  		  format.html { redirect_to ent }
  		  format.json { head :no_content }
  		end
  	else
  		redirect_to '/404'
  	end
  end
  
  def recovery
  	msg = Message.find_by(id: params[:id])
  	if msg != nil and is_admin?
  		msg.set_as_visible
  	else
  		redirect_to '/404'
  	end
  end
  
  def replace_message
	@message = Message.find_by(id: params[:id])
	if user_type != 'admin' || user_type != 'super_admin' and @message != nil
		@collection = []
		@themes_collection = []
		@default = {:value => @message.theme.topic_id, :name => @message.theme.topic.name}
		@add_functions = "getTargetTheme();" #Включаем функцию вытаскивания темы
		topics = Topic.all.order('name ASC')
		topics.each do |topic|
			@collection[@collection.length] = {:value => topic.id, :name => topic.name}
		end
		base_themes_list = @message.theme.topic.themes.where(:status_id => 1)
		if base_themes_list != []
			base_themes_list.each do |thm|
				@themes_collection[@themes_collection.length] = {:value => thm.id, :name => thm.name}
			end
		end
	else
		redirect_to '/404'
	end
  end
  
  def do_replace_message
	if is_admin?
		message = Message.find_by(id: params[:replace_message][:current_message])
		new_topic = Topic.find_by(id: params[:split_theme][:topic_id])
		target_theme = Theme.find_by(id: params[:split_theme][:theme_id])
		new_theme_flag = (params[:replace_message][:make_new_as_theme]).to_i
		new_theme_name = (params[:replace_message][:new_theme_name]).strip
		if message != nil and new_topic != nil
			replace_path = "/messages/#{message.id}/replace_message"
			if new_theme_flag == 1
				if new_theme_name != ''
					new_theme = message.makeThemeFromMessage(new_theme_name, new_topic)
					redirect_to new_theme
				else
					redirect_to replace_path, :notice => 'Введите название новой темы'
				end
			else
				if target_theme != nil
					message.update_attributes(:theme_id => target_theme.id, :topic_id => target_theme.topic_id, :visibility_status_id => target_theme.visibility_status_id, :message_id => nil)
					message.bind_child_messages_to_theme(target_theme)
					redirect_to "#{theme_path(target_theme)}#m_#{message.id.to_s}"
				else
					redirect_to replace_path, :notice => 'Выберите тему, либо создайте новую'
				end
			end
		else
			redirect_to '/404'
		end
	else
		redirect_to '/404'
	end
  end
  def upload_photos
	  message = Message.find(params[:id]) 
  	if isEntityOwner?(message)
  		@photo = Photo.new(message_id: message.id, user_id: message.user.id, link: params[:message][:uploaded_photos])
  		if @photo.save
  			render :json => {message: 'success', photoID: @photo.id }
  		else
  			render :json => {:error => @photo.errors.full_messages.join(',')}
  		end
  	else
  		redirect_to '/404'
  	end
  end
  def upload_attachment_files
  	message = Message.find_by(id: params[:id]) 
  	if isEntityOwner?(message)
  		@attachmentFile = AttachmentFile.new(:message_id => message.id, :user_id => message.user.id, uploaded_file: params[:message][:attachment_files], directory: "messages")
  		if @attachmentFile.save
  			render :json => {:message => 'success', :attachmentID => @attachmentFile.id }, :status => 200
  		else
  			render :json => {:error => @attachmentFile.errors.full_messages.join(',')}, :status => 400
  		end
  	else
  		redirect_to '/404'
  	end
  end
end
