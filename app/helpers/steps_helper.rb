module StepsHelper
  def minlUpdViewElTime
    15.minutes
  end

	def define_action
		@page_params = {:part_id => 0, :page_id => 0, :entity_id => 0} if @page_params == nil
		@curTopImage = topImages.last
		if controller.controller_name == 'pages' #@page_params[:part_id] == 0 #pages
			if controller.action_name == 'about_us'
				@curTopImage = topImages[0]
			elsif controller.action_name == 'index'
				@curTopImage = topImageMainPage
			elsif controller.action_name == 'equipment'
				@curTopImage = topImages[2] 
			elsif controller.action_name == 'contacts'
				@curTopImage = topImages[1]
			elsif controller.action_name == 'paragliding'
				@curTopImage = topImages[3]
			elsif controller.action_name == 'school'
				@curTopImage = topImages[4]
			end
			
		elsif controller.controller_name == 'topics' #@page_params[:part_id] == 1 #topics
			@curMenuItem = 'Общение'
			#make_step
		elsif controller.controller_name == 'users' #@page_params[:part_id] == 2 #users
      @curTopImage = topImages[5]
		elsif controller.controller_name == 'photo_albums' #@page_params[:part_id] == 3 #photo_albums
			@curMenuItem = 'Фото'
			make_step
		elsif controller.controller_name == 'photos' #@page_params[:part_id] == 4 #photos (внести изменения в контроллер)
			@curMenuItem = 'Медиа'
			make_step
		elsif controller.controller_name == 'videos' #@page_params[:part_id] == 5 #videos
			@curMenuItem = 'Медиа'
			make_step
		elsif controller.controller_name == 'messages' #@page_params[:part_id] == 6 #messages
		elsif controller.controller_name == 'articles'#@page_params[:part_id] == 7 #articles
			@curMenuItem = 'Медиа'
			make_step
		elsif controller.controller_name == 'events' #@page_params[:part_id] == 8 #events
      @curMenuItem = 'Новости'
		elsif controller.controller_name == 'themes' #@page_params[:part_id] == 9 #themes
			@curMenuItem = 'Общение'
			make_step
		elsif controller.controller_name == 'old_messages' #@page_params[:part_id] == 9 #themes
			@curMenuItem = 'Общение'
		elsif controller.controller_name == 'votes' #@page_params[:part_id] == 9 #themes
			@curMenuItem = 'Общение'
		end
	end
	
  def getViewElement
    if @page_params[:part_id] == 3 
        return (@album.entity_view.nil?)? @album.build_entity_view(counter: 0) : @album.entity_view if @album != nil && @page_params[:page_id] == 1 
    elsif @page_params[:part_id] == 4 #photos
        return (@photo.entity_view.nil?)? @photo.build_entity_view(counter: 0) : @photo.entity_view if @photo != nil && @page_params[:page_id] == 1  
    elsif @page_params[:part_id] == 9 #themes
        return (@theme.entity_view.nil?)? @theme.build_entity_view(counter: 0) : @theme.entity_view if @theme != nil && @page_params[:page_id] == 1     
    elsif @page_params[:part_id] == 5 #videos
        return (@video.entity_view.nil?)? @video.build_entity_view(counter: 0) : @video.entity_view if @video != nil && @page_params[:page_id] == 1     
    else
      return nil
    end
  end
  

	def make_step #Создаёт либо обновляет steps
		s = Step.find_by(
                      part_id: @page_params[:part_id], 
                      page_id: @page_params[:page_id], 
                      entity_id: @page_params[:entity_id],
                      guest_token: guestToken
                     )
    if s.nil?
      create_step
    else
      update_step(s)
    end  
	end
  
	def update_step(step)
    if (step.visit_time + minlUpdViewElTime) < Time.now
      v = getViewElement
      v.increment_counter if v != nil
    end
    usr = guest_user
    user_id = (usr.nil?)? 0 : usr.id 
		step.update_attributes(
                          user_id: user_id,
								          visit_time: Time.now,
								          ip_addr: request.env['REMOTE_ADDR'],
							            host_name: request.env['REMOTE_HOST'],
                          online_flag: signed_in?
							            )
    
  end
  
	def	create_step
    v = getViewElement
    v.increment_counter if v != nil
    usr = guest_user
    if usr.nil?
      user_id = 0
      token = get_guest_token
    else
      user_id = usr.id
      token = usr.guest_token
    end
    step = Step.where("user_id = ? AND visit_time < ?", 0, Time.now - 7.days).order('visit_time ASC').last
    if !step.nil?
  		step.update_attributes(
  					                        :user_id => user_id, 
  						                      :part_id => @page_params[:part_id],
  						                      :page_id => @page_params[:page_id],
  						                      :entity_id => @page_params[:entity_id],
  						                      :host_name => request.env['REMOTE_HOST'],
  						                      :ip_addr => request.env['REMOTE_ADDR'],
  						                      :visit_time => Time.now,
                                    :guest_token => token,
                                    online_flag: signed_in?
  						                      )
    else
  		step = Step.create(
  					            :user_id => user_id, 
  						          :part_id => @page_params[:part_id],
  						          :page_id => @page_params[:page_id],
  						          :entity_id => @page_params[:entity_id],
  						          :host_name => request.env['REMOTE_HOST'],
  						          :ip_addr => request.env['REMOTE_ADDR'],
  						          :visit_time => Time.now,
                        :guest_token => token,
                        online_flag: signed_in?
                        
  						          )
    end
	end
  
	def clear_steps(user, oldToken)
    steps = Step.where(guest_token: oldToken)
    if steps != []
      steps.each do |s|
        existStep = Step.find_by(
                                  part_id: s.part_id,
				                          page_id: s.page_id,
				                          entity_id: s.entity_id,
                                  guest_token: user.guest_token
                                  )
        if existStep != nil
          existStep.update_attribute(:visit_time, s.visit_time, online_flag: true)
          s.delete
        else
          s.update_attributes(user_id: user.id, guest_token: user.guest_token, online_flag: true)
        end
      end
    end
	end
	
end

