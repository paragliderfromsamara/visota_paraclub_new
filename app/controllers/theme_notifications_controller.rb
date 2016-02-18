class ThemeNotificationsController < ApplicationController
include ThemeNotificationsHelper
  def get_list
  end

  def create
	ntfData = params[:theme_notifications]
	d = false
	if !ntfData.blank? and signed_in?
		if ntfData[:type] == 'multiple' 
			d = multipleThemeNtfUpd(ntfData)
			if d == true 
				respond_to do |format|
					format.html {redirect_to edit_user_path(:id => current_user.id, :tab => 'notification_upd')}# index.html.erb
					format.json { render :json => themeNotificationButton(@theme.id) }
				end
			end
		else
			val = singleThemeNtfUpd(ntfData)
			respond_to do |format|
				format.json { render :json => val}
			end
		end
	else
		redirect_to '/404'
	end
  end

  def destroy
  end
end
