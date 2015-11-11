module ThemeNotificationsHelper
	def themeNotificationButton(theme_id)
		v = ''
		nt = current_user.getThemeNotification(theme_id)
		if nt == nil
			v =watchBut(theme_id)# "<a id = 'watchTheme' th_id = '#{theme_id}' class = 'b_link pointer'>Отслеживать</a>"
		else
			v = unWatchBut(theme_id)
		end
		return v
	end
	
	def multipleThemeNtfUpd(ntfData)
	end
	
	def singleThemeNtfUpd(ntfData)
		if signed_in?
			ntf = current_user.getThemeNotification(ntfData[:theme_id])
			but = watchBut(ntfData[:theme_id])
			if ntf == nil
				ntf = ThemeNotification.new(:user_id => current_user.id, :theme_id => ntfData[:theme_id])
				but = unWatchBut(ntfData[:theme_id]) if ntf.save
			else
				but = unWatchBut(ntfData[:theme_id]) unless ntf.destroy
			end
			return but
		end
	end
	
	def watchBut(t)
		{:name => "Отслеживать тему", :access => signed_in?, :type => 'eye', :id => 'watchTheme', :value => "#{t}"}
	end
	def unWatchBut(t)
		{:name => "Больше не отслеживать тему", :access => signed_in?, :type => 'eye', :id => 'watchTheme', :value => "#{t}"}
	end
end
