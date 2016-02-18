class TopicsController < ApplicationController
include ThemesHelper
include EventsHelper
  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.all
	  @title = @header = "Общение"
    @add_functions = "initSearchForm();"
    respond_to do |format|
	  format.html# index.html.erb
      format.json { render :json => @topics }
    end
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
  @topic = Topic.find(params[:id])
	@title = @header = @topic.name 
	@themes_per_page = 25
  if signed_in?
    if params[:th_filter] == 'my'
      @themes = @topic.themes.where(user_id: current_user.id).order('last_message_date DESC').paginate(:page => params[:page], :per_page => @themes_per_page)
    elsif params[:th_filter] == 'ntf'
      @themes = @topic.themes.where(id: current_user.theme_notifications.select(:theme_id)).order('last_message_date DESC').paginate(:page => params[:page], :per_page => @themes_per_page)
    elsif params[:th_filter] == 'not_visited' 
      @themes = @topic.themes.where(id: current_user.not_readed_themes_ids(@topic, is_not_authorized?)).order('last_message_date DESC').paginate(:page => params[:page], :per_page => @themes_per_page)
    elsif params[:th_filter] == 'deleted' && user_type == 'super_admin'
      @themes = @topic.themes.rewhere(status_id: 2).order('last_message_date DESC').paginate(:page => params[:page], :per_page => @themes_per_page)
    else
    	if is_not_authorized?
    		@themes = @topic.themes.where(visibility_status_id: 1).order('last_message_date DESC').paginate(:page => params[:page], :per_page => @themes_per_page)
    	else
    		@themes = @topic.themes.where(visibility_status_id: [1,2]).order('last_message_date DESC').paginate(:page => params[:page], :per_page => @themes_per_page)
    	end
    end
  else
    @themes = @topic.themes.where(visibility_status_id: 1).order('last_message_date DESC').paginate(:page => params[:page], :per_page => @themes_per_page)
  end
	@path_array = [
					        {:name => 'Общение', :link => '/visota_life'},
					        {:name => @title}
				        ]
    respond_to do |format|
      format.html# show.html.erb
      format.json { render :json => @topic }
    end
  end

  # GET /topics/new
  # GET /topics/new.json
  def new
	if user_type == 'super_admin'
    @title = @header = "Новый раздел"
		@topic = Topic.new
  	@path_array = [
  					        {:name => 'Общение', :link => '/visota_life'},
  					        {:name => @title}
  				        ]
		respond_to do |format|
		  format.html# new.html.erb
		  format.json { render :json => @topic }
		end
	else
		redirect_to '/404'
	end
  end

  # GET /topics/1/edit
  def edit
	if user_type == 'super_admin'
		@topic = Topic.find(params[:id])
		@title = @header = "Изменение раздела '#{@topic.name}'"
		@path_array = [
						{:name => 'Клубная жизнь', :link => '/visota_life'},
						{:name => @topic.name, :link => topic_path(@topic)},
						{:name => 'Изменение раздела'}
					  ]
		respond_to do |format|
		  format.html# new.html.erb
		  format.json { render :json => @topic }
		end
	else
		redirect_to '/404'
	end
  end

  # POST /topics
  # POST /topics.json
  def create
	if user_type == 'super_admin'
		@topic = Topic.new(params[:topic])
		respond_to do |format|
		  if @topic.save
			format.html { redirect_to @topic, :notice => 'Раздел успешно создан' }
			format.json { render :json => @topic, :status => :created, :location => @topic }
		  else
			format.html { render :action => "new"}
			format.json { render :json => @topic.errors, :status => :unprocessable_entity }
		  end
		end
	else
		redirect_to '/404'
	end
  end

  # PUT /topics/1
  # PUT /topics/1.json
  def update
	if user_type == 'super_admin'
		@topic = Topic.find(params[:id])

		respond_to do |format|
		  if @topic.update_attributes(params[:topic])
			format.html { redirect_to @topic, :notice => 'Раздел успешно обновлён' }
			format.json { head :no_content }
		  else
			format.html { render :action => "edit"}
			format.json { render :json => @topic.errors, :status => :unprocessable_entity }
		  end
		end
	else
		redirect_to '/404'
	end
  end

  def set_as_read_all_themes
    topic = Topic.find(params[:id])
    redirect_to '/404' if !signed_in? || topic.nil?
    themes = topic.themes.where(id: current_user.not_readed_themes_ids(topic, is_not_authorized?))
    if themes.size > 0
      themes.each do |th|
        step = Step.find_by(part_id: 9, page_id: 1, entity_id: th.id, user_id: current_user.id)
        if step.nil?
    		  step = Step.create(
    					              :user_id => current_user.id, 
    						            :part_id => 9,
    						            :page_id => 1,
    						            :entity_id => th.id,
    						            :host_name => request.env['REMOTE_HOST'],
    						            :ip_addr => request.env['REMOTE_ADDR'],
    						            :visit_time => Time.now,
                            :guest_token => current_user.guest_token,
                            online_flag: true
    						            )
        else
          step.update_attributes(visit_time: Time.now, online_flag: true)
        end
      end
    end
		respond_to do |format|
		  format.html { redirect_to topic }
		  format.json { render :json => {callback: 'success'}}
		end
  end
  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
	if user_type == 'super_admin'
		@topic = Topic.find(params[:id])
		@topic.destroy

		respond_to do |format|
		  format.html { redirect_to topics_url }
		  format.json { head :no_content }
		end
	else
		redirect_to '/404'
	end
  end
end
