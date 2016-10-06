
module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
    $redis_onlines.del("ip:#{request.remote_ip}") if $redis_onlines.exists("ip:#{request.remote_ip}")
    $redis_onlines.set( "user:#{current_user.id}", Time.now, ex: 90.days)
    return true
  end
  
  def current_user=(user)
    @current_user = user
  end
   
  def current_user
	  @current_user ||= user_from_remember_token
  end
  
  def guest_user
    (signed_in?)? current_user : User.find_by(guest_token: get_guest_token)
  end
  
  def is_online?(u=current_user)
      key = "user:#{u.id}"
      if $redis_onlines.exists(key)
          if $redis_onlines.get(key) > (Time.now - 10.minutes)
              {status: true}
          else
              {status: false, last_visit_time: $redis_onlines.get(key)}
          end
      else
          {status: false}
      end
  end
  
  def user_type
  	if current_user != nil
  		@current_user.group 
  	else
  		user_type = "guest"
  	end
  end

  # все вошедшие пользователи онлайн (массив с их id)
  def all_signed_users_online
    ids = []
    $redis_onlines.scan_each( match: 'user*' ){|u| ids << u.gsub("user:", "") if $redis_onlines.get(u)> (Time.now - 10.minutes)}
    ids
  end

  # количество не вошедших пользователей онлайн
  def all_anonymous_users_online
    $redis_onlines.scan_each( match: 'ip*' ).to_a.size
  end

  # количество всех пользователей онлайн
  def all_who_are_in_list
    $redis_onlines.dbsize
  end
  
  def whoIsOnlineMenu  
      anons = all_anonymous_users_online
      signed = all_signed_users_online 
      newUsrs = User.n_users
      nUsrsText = "<div class = 'm_1000wh tb-pad-s'><span class = 'istring_m'>К нам присоединил#{newUsrs.size == 1 ? 'ся' : 'ись'}: </span>#{usersLinkString(newUsrs)}</div>"
      if signed_in?
          signed -= [current_user.id.to_s]
      else
          anons -= 1
      end
      signed_usrs = User.where(id: signed).select(:id, :name).order("name ASC")
      signedTxt = "<span class = 'istring_m'>Сейчас на сайте#{' только' if anons == 0 && signed_usrs.size == 0}</span> <span style = 'font-size: 12px;' class = 'bi-string'>Вы</span>"
      if signed_usrs.size > 0
          signed_usrs.each do |u|
              signedTxt += (signed_usrs.last == u)? " <span class = 'istring_m'>и</span> " : "<span class = 'istring_m'>,</span> "
              signedTxt += link_to u.name, u, class: 'b_link_i'
          end
      end
      if anons > 0
          signedTxt += (signed_usrs.size == 0)? " <span class = 'istring_m'>и</span> " : " <span class = 'istring_m'>, а также</span> "
          signedTxt += (anons == 1)? "<span style = 'font-size: 12px;' class = 'bi-string'>Гость</span>" : "<span style = 'font-size: 12px;' class = 'istring_m'>#{anons}</span> <span style = 'font-size: 12px;' class = 'bi-string'>Гостей</span>" 
      end
      return "<div class = 'c_box even'><div class = 'm_1000wh tb-pad-s'>#{signedTxt}</div>#{nUsrsText if newUsrs.size > 0}</div>".html_safe
  end
  
  private
    
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
    
  	def sign_out
      $redis_onlines.set( "user:#{current_user.id}", Time.now-10.minutes, ex: 90.days)
      cookies.delete(:remember_token)
      self.current_user = nil
    end
	
    def signed_in?
      !current_user.nil?
    end
	
end

