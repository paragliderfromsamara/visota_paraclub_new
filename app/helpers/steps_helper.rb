module StepsHelper
  def minlUpdViewElTime
    15.minutes
  end

	def define_action
        #ThemeStep.get_from_step_table
		@page_params = {:part_id => 0, :page_id => 0, :entity_id => 0} if @page_params == nil
		@curTopImage = topImages.last
        current_user.check_bun_status if user_type == 'bunned'
		if controller.controller_name == 'pages'
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
            elsif controller.action_name == 'media'
                @show_authority_message_flag = true
			end
			
		elsif controller.controller_name == 'topics'
			@curMenuItem = 'Общение'
            @show_authority_message_flag = true
            
		elsif controller.controller_name == 'users'
            @show_authority_message_flag = true
            @curTopImage = topImages[5]
		elsif controller.controller_name == 'photo_albums'
            upd_view_element(@album) if controller.action_name == 'show'

            @show_authority_message_flag = true
			@curMenuItem = 'Медиа'
			
		elsif controller.controller_name == 'photos'
			upd_view_element(@photo) if controller.action_name == 'show'
            @show_authority_message_flag = true
            @curMenuItem = 'Медиа'
			
		elsif controller.controller_name == 'videos'
			upd_view_element(@video) if controller.action_name == 'show'
            @show_authority_message_flag = true
            @curMenuItem = 'Медиа'
			
		elsif controller.controller_name == 'messages'
      
		elsif controller.controller_name == 'articles'
            upd_view_element(@article) if controller.action_name == 'show'
            @show_authority_message_flag = true
			@curMenuItem = 'Медиа'
			
		elsif controller.controller_name == 'events'
            @curMenuItem = 'Новости'
		elsif controller.controller_name == 'themes'
            if controller.action_name == 'show'
                upd_view_element(@theme)
                @theme.update_step(current_user)
            end
            @show_authority_message_flag = true
			@curMenuItem = 'Общение'
			
		elsif controller.controller_name == 'old_messages'
			@curMenuItem = 'Общение'
		elsif controller.controller_name == 'votes'
            @show_authority_message_flag = true
			@curMenuItem = 'Общение'
		end
	end

	private
    
    def upd_view_element(entity)
        key = "#{entity.model_name}:#{entity.id}:#{request.remote_ip}"
        if !$redis_views.exists(key)
            $redis_views.set(key, nil, ex: 15*60 )
            entity.e_view.increment_counter
        end
    end
end

