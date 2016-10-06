class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include MailerHelper
  include GrantsHelper
  include ApplicationHelper
  #include AlbumBindersHelper
  include StepsHelper
  #before_action :site_works
  before_action :check_domain_name
  after_filter :set_online
  
  def site_works
    redirect_to '/404' if user_type == 'guest'
    redirect_to '/404' if current_user.id != 1 
  end
  
  
  private
  
  def set_online
      if signed_in?
          $redis_onlines.set( "user:#{current_user.id}", Time.now, ex: 90.days)
          if user_type == 'super_admin'
              if params[:todo] == 'make' 
                  ThemeStep.get_from_step_table 
              elsif params[:todo] == 'del'
                   ThemeStep.del 
              end
          end
          
      else
          $redis_onlines.set( "ip:#{request.remote_ip}", Time.now, ex: 10*60 )
      end
  end
  
  def check_domain_name
    url = request.url.to_s
    new_url = 'visota63'
    regexp = /visota-paraclub/i
    if !url.index(regexp).nil?
      redirect_to url.gsub(regexp, new_url)
    end
  end
  
  
  
end
