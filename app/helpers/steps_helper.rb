module StepsHelper
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
			@curMenuItem = 'Клубная жизнь'
			make_signed_step
		elsif controller.controller_name == 'users' #@page_params[:part_id] == 2 #users
      @curTopImage = topImages[5]
		elsif controller.controller_name == 'photo_albums' #@page_params[:part_id] == 3 #photo_albums
			@curMenuItem = 'Фото'
			make_step
		elsif controller.controller_name == 'photos' #@page_params[:part_id] == 4 #photos (внести изменения в контроллер)
			@curMenuItem = 'Фото'
			make_step
		elsif controller.controller_name == 'videos' #@page_params[:part_id] == 5 #videos
			@curMenuItem = 'Видео'
			make_step
		elsif controller.controller_name == 'messages' #@page_params[:part_id] == 6 #messages
		elsif controller.controller_name == 'articles'#@page_params[:part_id] == 7 #articles
			@curMenuItem = 'Материалы'
			make_step
		elsif controller.controller_name == 'events' #@page_params[:part_id] == 8 #events
      @curMenuItem = 'Новости'
		elsif controller.controller_name == 'themes' #@page_params[:part_id] == 9 #themes
			@curMenuItem = 'Клубная жизнь'
			make_signed_step
		elsif controller.controller_name == 'old_messages' #@page_params[:part_id] == 9 #themes
			@curMenuItem = 'Клубная жизнь'
		elsif controller.controller_name == 'votes' #@page_params[:part_id] == 9 #themes
			@curMenuItem = 'Клубная жизнь'
		end
	end
	
	def backLink(link)
		@backLink=link
	end
	
	def make_step #Создаёт либо обновляет steps
		if signed_in? 
			signed_step
		else
			unsigned_step 
		end
		
	end
	
	def make_signed_step
		signed_step if signed_in? 		
	end
	
	def clear_steps(user)
		steps = Step.where(user_id: 0, ip_addr: request.env['REMOTE_ADDR'], host_name: request.env['REMOTE_HOST'])
		steps.each do |step|
			signed_step = Step.find_by(user_id: user.id, part_id: step.part_id, entity_id: step.entity_id, page_id: step.page_id, ip_addr: request.env['REMOTE_ADDR'], host_name: request.env['REMOTE_HOST'])
			if signed_step != nil
				signed_step.update_attributes(:visit_time => step.visit_time)
				step.destroy
			else
				step.update_attributes(:user_id => user.id)
			end
		end
	end
	
	def signed_step
		if signed_step_check == nil
			signed_step_create
		else
			signed_step_update(signed_step_check)
		end
	end
	
	def unsigned_step
		if guest_host_validation == nil
			if unsigned_step_check != nil
				unsigned_step_update(unsigned_step_check)
			else
				unsigned_step_create
			end
		end 
	end
	
	def signed_step_check
		step = Step.find_by(user_id: current_user.id, part_id: @page_params[:part_id], page_id: @page_params[:page_id], entity_id: @page_params[:entity_id])
		return step
	end
	
	def unsigned_step_check
		step = Step.find_by(user_id: 0, part_id: @page_params[:part_id], page_id: @page_params[:page_id], entity_id: @page_params[:entity_id], ip_addr: request.env['REMOTE_ADDR'], host_name: request.env['REMOTE_HOST'])
		return step
	end
	

	
	def signed_step_update(step)
		step.update_attributes(
								:visit_time => Time.now,
								:ip_addr => request.env['REMOTE_ADDR'],
								:host_name => request.env['REMOTE_HOST']
							   )
	end
	
	def	signed_step_create
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
		step.update_attributes(
								:visit_time => Time.now
							   )
	end
	
	def guest_host_validation
		step = Step.find_by(part_id: @page_params[:part_id], page_id: @page_params[:page_id], entity_id: @page_params[:entity_id], ip_addr: request.env['REMOTE_ADDR'], host_name: request.env['REMOTE_HOST'], user_id: "!=0")
		return step
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

