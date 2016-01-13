class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include MailerHelper
  include GrantsHelper
  include ApplicationHelper
  #include AlbumBindersHelper
  include StepsHelper
  #before_action :site_works
  
  def site_works
    redirect_to '/404' if user_type == 'guest'
    redirect_to '/404' if current_user.id != 1 
  end
  
end
