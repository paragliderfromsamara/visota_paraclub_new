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
							            host_name: request.env['REMOTE_HOST']
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
                                    :guest_token => token
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
                        :guest_token => token
  						          )
    end
	end
  
  
  
	def make_signed_step
		signed_step if signed_in? 		
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
          existStep.update_attribute(:visit_time, s.visit_time)
          s.delete
        else
          s.update_attributes(user_id: user.id, guest_token: user.guest_token)
        end
      end
    end
		#steps = Step.where(user_id: 0, ip_addr: request.env['REMOTE_ADDR'], host_name: request.env['REMOTE_HOST'])
		#steps.each do |step|
		#	signed_step = Step.find_by(user_id: user.id, part_id: step.part_id, entity_id: step.entity_id, page_id: step.page_id, ip_addr: request.env['REMOTE_ADDR'], host_name: request.env['REMOTE_HOST'])
		#	if signed_step != nil
		#		signed_step.update_attributes(:visit_time => step.visit_time)
		#		step.destroy
		#	else
		#		step.update_attributes(:user_id => user.id)
		#	end
		#end
	end
	
	def signed_step
		s = signed_step_check
    if s == nil
			signed_step_create
		else
			signed_step_update(s)
		end
	end
	
	def unsigned_step
		if guest_host_validation == nil
			u = unsigned_step_check
      if u != nil
				unsigned_step_update(u)
			else
				unsigned_step_create
			end
		end 
	end
	
	def signed_step_check
		Step.find_by(user_id: current_user.id, part_id: @page_params[:part_id], page_id: @page_params[:page_id], entity_id: @page_params[:entity_id])
	end
	
	def unsigned_step_check
		Step.find_by(user_id: 0, part_id: @page_params[:part_id], page_id: @page_params[:page_id], entity_id: @page_params[:entity_id], ip_addr: request.env['REMOTE_ADDR'], host_name: request.env['REMOTE_HOST'])
	end
	

	
	def signed_step_update(step)
    if (step.visit_time + minlUpdViewElTime) < Time.now
      v = getViewElement
      v.increment_counter if v != nil
    end
		step.update_attributes(
								          :visit_time => Time.now,
								          :ip_addr => request.env['REMOTE_ADDR'],
							            :host_name => request.env['REMOTE_HOST']
							            )
	end
	
	def	signed_step_create
    v = getViewElement
    v.increment_counter if v != nil
		step = Step.new(
						:user_id => current_user.id, 
						:part_id => @page_params[:part_id],
						:page_id => @page_params[:page_id],
						:entity_id => @page_params[:entity_id],
						:host_name => request.env['REMOTE_HOST'],
						:ip_addr => request.env['REMOTE_ADDR'],
						:visit_time => Time.now
						)
		step.save
	end

	def unsigned_step_create
    v = getViewElement
    v.increment_counter if v != nil
		step = Step.new(
						:user_id => 0, 
						:part_id => @page_params[:part_id],
						:page_id => @page_params[:page_id],
						:entity_id => @page_params[:entity_id],
						:host_name => request.env['REMOTE_HOST'],
						:ip_addr => request.env['REMOTE_ADDR'],
						:visit_time => Time.now
						)
		step.save
	end
	
	def unsigned_step_update(step)
    if (step.visit_time + minlUpdViewElTime) < Time.now
      v = getViewElement
      v.increment_counter if v != nil
    end
		step.update_attribute(:visit_time, Time.now)
	end
	
	def guest_host_validation
		Step.find_by(part_id: @page_params[:part_id], page_id: @page_params[:page_id], entity_id: @page_params[:entity_id], ip_addr: request.env['REMOTE_ADDR'], host_name: request.env['REMOTE_HOST'], user_id: "!=0")
	end
	
	#отрисовка переходов
	def entity_link(e)
		if e.entity_name[:link] == nil
			'(Пусто)'
		else
			return link_to(truncate(e.entity_name[:name], :length=> 50), e.entity_name[:link], :class=> 'b_link')
		end
	end
end

