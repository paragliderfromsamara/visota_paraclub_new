class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    @title = @header = 'Новости'
    status = (!params[:show_hidden].nil? and userCanSeeHiddenEvents?)? 1 : 2
	  @events = Event.paginate(:page => params[:page], :per_page => 10).where(status_id: status).order('post_date DESC')
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
  	if userCanSeeEvent?(@event)
  		@title = @header = @event.title
  		@path_array = [
  						{:name => 'Новости', :link => '/events'},
  						{:name => @event.title}
  					  ]
  		respond_to do |format|
  		  format.html # show.html.erb
  		  format.json { render :json => @event }
  		end
  	else
  		redirect_to '/404'
  	end
  end

  # GET /events/new
  # GET /events/new.json
  def new
	if user_type == 'admin' || user_type == 'super_admin' || user_type == 'manager'
		@event = current_user.event_draft
		@title = @header = 'Добавление новости'
		@path_array = [
					          {:name => 'Новости', :link => '/events'},
					          {:name => @title}
					        ]
    respond_to do |format|
		  format.html # new.html.erb
		  format.json { render :json => @event }
		end
	else
		redirect_to '/404'
	end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find_by(id: params[:id])
	if userCanEditEvent?(@event)
		@title = 'Изменение новости'
    @add_functions = "initEventForm(#{@event.id}, '.edit_event');"
		@path_array = [
						{:name => 'Новости', :link => '/events'},
						{:name => @event.title, :link => event_path(@event)},
            {:name => "Изменение новости"}
					  ]
	else
		redirect_to '/404'
	end
  end

  # POST /events
  # POST /events.json
  def create
	if user_type == 'admin' || user_type == 'super_admin' || user_type == 'manager'
		@event = Event.new(params[:event])
		respond_to do |format|
		  if @event.save
      @event.assign_entities_from_draft(current_user.event_draft)	#ищем черновик и привязываем	
      @event.check_photos_in_content
			format.html { redirect_to @event, :notice => 'Новость успешно добавлена' }
			format.json { render :json => @event, :status => :created, :location => @event }
		  else
			format.html { render :action => "new" }
			format.json { render :json => @event.errors, :status => :unprocessable_entity }
		  end
		end
	else
		redirect_to '/404'
	end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find_by(id: params[:id])
	if userCanEditEvent?(@event)
		respond_to do |format|
		  if @event.update_attributes(params[:event])
        @event.check_photos_in_content
			format.html { redirect_to @event, :notice => 'Новость успешно сохранена' }
			format.json { head :no_content }
		  else
			format.html { render :action => "edit" }
			format.json { render :json => @event.errors, :status => :unprocessable_entity }
		  end
		end
	else
		redirect_to '/404'
	end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
	if userCanEditEvent?(@event)
		@event.destroy

		respond_to do |format|
		  format.html { redirect_to events_url }
		  format.json { head :no_content }
		end
	else
		redirect_to '/404'
	end
  end

  def upload_photos
  	event = Event.find_by_id(params[:id]) 
    	if userCanEditEvent?(event)
    		@photo = Photo.new(:event_id => event.id, :user_id => current_user.id, :link => params[:event][:uploaded_photos])
    		if @photo.save
          event.entity_photos.create(photo_id: @photo.id, visibility_status_id: 1)
    			render :json => {:message => 'success', :photoID => @photo.id}, :status => 200
    		else
    			render :json => {:error => @photo.errors.full_messages.join(',')}, :status => 400
    		end
    	else
    		redirect_to '/404'
    	end
  end
  
  def upload_attachment_files
  	event = Event.find_by_id(params[:id]) 
  	if userCanEditEvent?(event)
  		@attachmentFile = AttachmentFile.new(:user_id => current_user.id, uploaded_file: params[:event][:attachment_files], directory: "events")
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
