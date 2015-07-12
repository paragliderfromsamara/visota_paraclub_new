class TopicNotificationsController < ApplicationController
include TopicNotificationsHelper
  def get_list
  end

  def create
	ntfData = params[:topic_notifications]
	d = false
	if ntfData != [] and ntfData != nil and current_user != nil
		if ntfData[:type] == 'multiple' 
			d = multipleTopicNtfUpd(ntfData)
			if d == true 
				respond_to do |format|
					format.html {redirect_to edit_user_path(:id => current_user.id, :tab => 'notification_upd'), :notice => 'Список отслеживаемых разделов успешно обновлён.'}# index.html.erb
					format.json { render :json => d }
				end
			else
			
			end
		else
			d = singleTopicNtfUpd(ntfData)
		end
	else
		redirect_to '/404'
	end
  end

  def destroy
  end
end
