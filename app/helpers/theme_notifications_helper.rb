module ThemeNotificationsHelper
	def themeNotificationButton(theme_id)
		v = ''
		if signed_in?
			nt = current_user.getThemeNotification(theme_id)
			if nt == nil
				v = {:name => "Отслеживать тему", :access => signed_in?, :type => 'edit', :id => 'watchTheme'}# "<a id = 'watchTheme' th_id = '#{theme_id}' class = 'b_link pointer'>Отслеживать</a>"
			else
				v = "<a id = 'unWatchTheme' th_id = '#{theme_id}' class = 'b_link pointer'>Не отслеживать</a>"
			end
		end
		return v
	end
end
