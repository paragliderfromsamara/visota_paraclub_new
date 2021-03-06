module GrantsHelper
	def is_not_authorized?
		user_type == 'guest' || user_type == 'bunned' || user_type == 'new_user' || user_type == 'deleted'
	end
	def is_admin?
		user_type == 'admin' || user_type == 'super_admin'
	end
	def is_super_admin? 
    #if signed_id?
		  user_type == 'super_admin'# || current_user.id == 1
      #else 
    #  false
   # end
	end
#votes
def userCanEditVote?(vote)
  if vote != nil
      return true if vote.user == current_user || is_admin?
  end
  return false
end
  def vote_completed?(vote)
		vote.end_date < Time.now
	end
	def userCanGiveVoice?(vote)
		if vote != nil and user_type != 'guest' and user_type != 'new_user'
			voice = Voice.find_by(user_id: current_user.id, vote_id: vote.id) 
			if vote_completed?(vote) and voice != nil
				return false
			else
				return true
			end
		else
			return false
		end
	end
	def user_could_see_vote_result?(vote)
		
		if user_type != 'guest' and vote != nil
			voice = Voice.find_by(user_id: current_user.id, vote_id: vote.id) 
			if voice != nil || vote_completed?(vote)
				return true
			else	
				return false
			end
		else
			if vote_completed?(vote)
				return true
			else
				return false
			end
		end
	end
#votes end
#events 
def userCanCreateEvent?
  return true if is_admin? || user_type == 'manager'
  return false
end
def userCanEditEvent?(event)
	return true if (is_admin? || user_type == 'manager') and !event.nil?
	return false
end
def userCanSeeEvent?(event)
  if event != nil
    return true if event.status_id == 2 || (event.status_id != 2 and (userCanSeeHiddenEvents?)) 
  end
  return false
end
def userCanSeeHiddenEvents? #кто может смотреть скрытые новости
  is_admin? || user_type == 'manager'
end
#events end
#events_part


#events_part end
#photos_part
	def userCanSeePhoto?(photo)
		#f = false
		#if photo != nil
		#	if @theme != nil
		#		f = userCanSeeTheme?(@theme)
		#	elsif @photo_msg != nil
		#		f = userCanSeeMessage?(@photo_msg)
		#	elsif @album != nil
		#		f = userCanSeeAlbum?(@album) || (@album.status_id == 0 && @album.user == current_user)
		#	elsif @article != nil
		#		f = isEntityOwner?(@article)
		#	elsif @event != nil
		#		f = userCanSeeEvent?(@event)
		#	end
		#end
		return true
	end
	def userCanDeletePhoto?(photo) #может ли пользователь удалить фотографию?
		if isEntityOwner?(photo)
			true
    else 
      false
    end
	end
	def userCanDeleteEntityPhoto?(ePhoto) #может ли пользователь удалить фотографию?
		if ePhoto.p_entity_type != 'Event'
      return isEntityOwner?(ePhoto.p_entity)
    else
      return userCanEditEvent?(ePhoto.p_entity)
    end
	end
	#photos_part_end
	#articles_part
	def userCanSeeArticle(article)
    if article != nil
      if is_not_authorized?
        if article.user == current_user and current_user != nil
          return true if article.status_id == 1 
        else
          return true if article.status_id == 1 and article.visibility_status_id == 1
        end
      else
        if article.user != current_user
          return true if article.status_id == 1 
        else
          return true if article.status_id != 3
        end 
      end
      return true if is_super_admin?
    end
    return false
  end
  
  def userCanCreateArticle?
		if !is_not_authorized?
			if user_type != 'friend'
				return true
			end
		end
		return false
	end
	def userCanEditArtilcle?(article)
		isEntityOwner?(article)
	end
  def userCanDeleteArticle(article)
    return true if Time.now < (article.created_at + 1.day) and isEntityOwner?(article)
  end
	#articles_part end

	#photo_albums_part
		def userCanSeeAlbum?(album)
			if album != nil
				return true if (album.status == 'hidden' and !is_not_authorized?) || (album.status == 'visible')
				return true if is_admin?
			end
			return false
		end
		def userCanEditAlbum?(album)		
			if isEntityOwner?(album) 
				return true if album.status_id == 1 || album.status_id == 0
				
			end
			return false
		end
	#photo_albums_part end
	#users_part
		def userCanEditUserCard?(user)
			(is_super_admin? || (user == current_user and user_type != 'bunned')) and user != nil  
		end
	#users_part end
	#topics_part
		def userCreateThemeInTopic?(topic)
			!is_not_authorized? || (user_type == 'new_user' and topic.id == 6) 
		end
		def userCanCreateAds? #может ли пользователь создавать тему с типом объявление
			user_type == 'manager' || is_admin?
		end
	#topics_part
	#themes_part
	def userCanDeleteTheme?(theme)
		if theme != nil
			((isThemeOwner?(theme) || is_admin?) and (theme.status == 'open' || theme.status == 'closed')) || is_super_admin?
		else
			return false
		end
	end
	def isThemeOwner?(theme)
		if theme != nil
		(theme.user == current_user and user_type != 'bunned' and user_type != 'guest' and user_type != 'deleted') || is_super_admin?
		else
			return false
		end
	end
	def isEntityOwner?(entity)
		if entity.nil?
			return false
		else
      (entity.user == current_user and user_type != 'bunned' and user_type != 'guest') || is_super_admin?
		end
	end
	def userCanEditTheme?(theme) #проверка может ли пользователь редактировать тему
		(isThemeOwner?(theme) and (theme.status == 'open' || theme.status == 'draft') ) || is_super_admin?
	end
	def userCanSwitchTheme?(theme) #проверка может ли пользователь открывать/закрывать тему
		(isThemeOwner?(theme) and (theme.status == 'open' || theme.status == 'closed')) || is_admin?
	end
	def userCanCreateMsgInTheme?(theme) #проверка может ли пользователь редактировать тему
		f = false
			if theme != nil
				if theme.status == 'open' 
					if theme.v_status == 'visible'
						f = true if !is_not_authorized? || (user_type == 'new_user' and (theme.topic.id == 6 || current_user == theme.user))
					elsif theme.v_status == 'hidden'
						f = true if !is_not_authorized?
					end
				end
			end
		return f
	end
	def userCanSeeTheme?(theme)
		f = false 
		if theme != nil
			if theme.v_status == 'hidden' and (theme.status == 'open' or theme.status == 'closed') 
					f = true if !is_not_authorized?
					f = true if theme.user == current_user
			elsif (theme.v_status == 'hidden' or theme.v_status == 'visible') and (theme.status == 'open' or theme.status == 'closed') 
				f = true
			end
			f = true if theme.status == 'draft' and isEntityOwner?(theme)
			f = true if is_super_admin?
		end 
		return f
	end
	def userCanWatchTheme?(theme)
		return userCanSeeTheme?(theme)
	end
	#themes_part end

	#messages_part
	def userCanCreateMsg? #может ли пользователь создавать сообщение
		th_flag = true
		alb_flag = true
		ph_flag = true
		if @theme != nil
			th_flag = userCanCreateMsgInTheme?(@theme)
		end
		if @album != nil
			alb_flag = !is_not_authorized? #условие для альбома
		end
		if @photo != nil
			ph_flag = !is_not_authorized? #условие для фото
		end
		return th_flag & alb_flag & ph_flag
		
	end
	def userCanEditMsg?(msg)
		if isEntityOwner?(msg) 
			if !msg.tread_has_another_user_message?
				if msg.theme_id != nil
					return true if msg.theme.status == 'open' if Time.now < msg.created_at + 5.hour  
				end
        if msg.photo_album != nil
          return true if userCanSeeAlbum?(msg.photo_album) and Time.now < msg.created_at + 1.hour
        end
        if msg.photo != nil
          return true if userCanSeePhoto?(msg.photo)
        end
        if msg.video != nil
          return true if Time.now < msg.created_at + 1.hour # || is_super_admin?
        end
			end
      return true if msg.status == 'draft' 
		end 
		#return true if is_super_admin?
		return false
	end
	def userCanSeeMessage?(msg)
		if msg != nil
			return userCanSeeTheme?(msg.theme) if msg.theme_id != nil
      return userCanSeeAlbum?(msg.photo_album) if msg.photo_album != nil
      return userCanSeePhoto?(msg.photo) if msg.photo != nil
      return !is_not_authorized? if msg.video != nil
		end
		return false
	end
	def userCanDeleteMessage?(msg)
		return true if isEntityOwner?(msg) || (user_type == 'admin' && msg.status_id == 1)
		return false
	end
	#messages_part end
	
	
   #ограничения end
end