class TopicsController < ApplicationController
include ThemesHelper
include EventsHelper

  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.all
	  @title = @header = "Общение"
    @events = Event.where("post_date > ?", Time.now-30.days).where.not(status_id: [0,1]).order('post_date DESC')#.limit(3)
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
  thType = [1,2,3]#(session[:themes_list_type] == 'list')? [1,2] : 1
  if session[:themes_list_type] != 'list'
    vStat = is_not_authorized? ? 1 : [1,2]
    if signed_in?
        @ads = Theme.where(theme_type_id: 3, status_id: [1,3], visibility_status_id: vStat).includes([:entity_view, :user, {messages: :user}, :theme_steps]).order('last_message_date DESC')
        @ads += Theme.where(theme_type_id: 2, status_id: [1,3], visibility_status_id: vStat, topic_id: @topic.id).includes([:entity_view, :user, {messages: :user}, :theme_steps]).order('last_message_date DESC')
    else
        @ads = Theme.where(theme_type_id: 3, status_id: [1,3], visibility_status_id: vStat).includes(:messages).order('last_message_date DESC') + Theme.where(theme_type_id: 2, status_id: [1,3], visibility_status_id: vStat, topic_id: @topic.id).includes(:messages).order('last_message_date DESC')
        @ads += Theme.where(theme_type_id: 2, status_id: [1,3], visibility_status_id: vStat, topic_id: @topic.id).includes(:messages).order('last_message_date DESC')
    end
  end
  
  @themes_per_page = 25
  if @topic.id != 9
    if signed_in?
      #@ads = Theme.where(theme_type_id: 2,status_id: [1,3]).order('last_message_date DESC') if session[:themes_list_type] != 'list'
      if params[:th_filter] == 'my'
        @themes = @topic.themes.where(user_id: current_user.id, theme_type_id: thType).includes([:entity_view, :user, {messages: :user}, :theme_steps]).order('last_message_date DESC').paginate(:page => params[:page], :per_page => @themes_per_page)
      elsif params[:th_filter] == 'ntf'
        @themes = @topic.themes.where(id: current_user.theme_notifications.select(:theme_id), theme_type_id: thType).includes([:entity_view, :user, {messages: :user}, :theme_steps]).order('last_message_date DESC').paginate(:page => params[:page], :per_page => @themes_per_page)
      elsif params[:th_filter] == 'not_visited' 
        @themes = @topic.themes.where(id: current_user.not_readed_themes_ids(@topic, is_not_authorized?), theme_type_id: thType).includes([:entity_view, :user, {messages: :user}, :theme_steps]).order('last_message_date DESC').paginate(:page => params[:page], :per_page => @themes_per_page)
      elsif params[:th_filter] == 'deleted' && user_type == 'super_admin'
        @themes = @topic.themes.rewhere(status_id: 2, theme_type_id: thType).includes([:entity_view, :user, {messages: :user}, :theme_steps]).order('last_message_date DESC').paginate(:page => params[:page], :per_page => @themes_per_page)
      else
      	if is_not_authorized?
      		@themes = @topic.themes.where(visibility_status_id: 1, theme_type_id: thType).order('last_message_date DESC').paginate(:page => params[:page], :per_page => @themes_per_page)
      	else
      		@themes = @topic.themes.where(visibility_status_id: [1,2], theme_type_id: thType).includes([:entity_view, :user, {messages: :user}, :theme_steps]).order('last_message_date DESC').paginate(:page => params[:page], :per_page => @themes_per_page)
      	end
      end
    else
      @themes = @topic.themes.where(visibility_status_id: 1, theme_type_id: thType).order('last_message_date DESC').paginate(:page => params[:page], :per_page => @themes_per_page)
    end
  else #если топик == купи-продайка
    @cur_equipment_part = Theme.equipment_part_by_id(params[:e_part])
    vStatus = (is_not_authorized?)? 1 : [1,2]
    if @cur_equipment_part[:id] == 100 && user_type != 'guest' && user_type != 'new_user'
      @themes = @topic.themes.rewhere(theme_type_id: 1, user_id: current_user.id, status_id: [1,3]).order('updated_at DESC').paginate(:page => params[:page], :per_page => @themes_per_page)
    else
      @themes = @topic.themes.rewhere(visibility_status_id: vStatus, theme_type_id: 1, status_id: @cur_equipment_part[:status_id], equipment_part_id: @cur_equipment_part[:equipment_part_id] ).order('updated_at DESC').paginate(:page => params[:page], :per_page => @themes_per_page)
    end
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
    themes.each {|th| th.update_step(current_user)} if themes.size > 0
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
