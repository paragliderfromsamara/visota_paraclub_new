#13.02.2014 - Добавлены user_errors
#			- Добавлен user_index_list(user)
#14.02.2014 - Добавлены функции user_contacts(user) и data_container(data)
module UsersHelper

def user_errors
	@pswrd_error = ''
	@old_pswrd_error = ''
	@cur_pswrd_error = ''
	@old_pswrd_f_color = ''
	@cur_pswrd_f_color = ''
	@pswrd_f_color = ''
	@name_error = ''
	@name_f_color = ''
	@mail_f_color = ''
	@mail_error = ''
	if @user.errors[:password] != [] and @user.errors[:password] != nil
		@pswrd_f_color = "style = 'background-color: red;'"
		@user.errors[:password].each do |err|
			@pswrd_error += "<span style = 'color: white;'>#{err}</span><br />"
		end
	end
	if @user.errors[:name] != [] and @user.errors[:name] != nil
		@name_f_color = "style = 'background-color: red;'"
		@user.errors[:name].each do |err|
			@name_error += "<span style = 'color: white;'>#{err}</span><br />"
		end
	end
	if @user.errors[:email] != [] and @user.errors[:email] != nil
		@mail_f_color = "style = 'background-color: red;'"
		@user.errors[:email].each do |err|
			@mail_error += "<span style = 'color: white;'>#{err}</span><br />"
		end
	end
	if @user.errors[:old_password] != [] and @user.errors[:old_password] != nil
		@old_pswrd_f_color = "style = 'background-color: red;'"
		@user.errors[:old_password].each do |err|
			@old_pswrd_error += "<span style = 'color: white;'>#{err}</span><br />"
		end
	end
	if @user.errors[:current_password] != [] and @user.errors[:current_password] != nil
		@cur_pswrd_f_color = "style = 'background-color: red;'"
		@user.errors[:current_password].each do |err|
			@cur_pswrd_error += "<span style = 'color: white;'>#{err}</span><br />"
		end
	end
end
#Отображение пользователя в списке пользователей
def user_index_list(user, i)
	html = "
      			<table style = 'width: 100%;'>
      				<tr>
      					<td style = 'width: 100px;' align = 'center' valign = 'top'>
      							#{image_tag(user.alter_avatar_square, :class => 'ava')}
      					</td>
      					<td align = 'left' valign = 'top'>
      						<div style = 'padding-left: 15px;'>
      							<p>#{link_to user.visible_name(user_type), user, :class => 'b_link_bold'}</p>
      							<p class = 'istring norm'>#{user.group_name}</p>
                    <p class = 'istring norm'>#{user.email_with_status if user_type == 'super_admin'}</p>
      						</div>
      					</td>
      				</tr>
      			</table>"
        	p = {
        			  :tContent => html, 
        			  :idLvl_2 => 'b_middle',
                :parity => i
        		  }
            return c_box_block(p).html_safe
end

def user_contacts(user)
	if !is_not_authorized? || user == current_user
		"<table>
				#{data_container(:name => "<i class = 'fi-mail fi-medium'></i>", :value => user.email)}
				#{data_container(:name => "<i class = 'fi-telephone fi-medium'></i>", :value => user.cell_phone) if user.cell_phone?}
				#{data_container(:name => "<i class = 'fi-social-skype fi-medium'></i>", :value => user.skype) if user.skype?}
				#{data_container(:name => "<i class = 'fi-web fi-medium'></i>", :value => link_to(user.web_site, check_user_www_link(user.web_site), class: 'b_link_i', id: 'user_site_link', target: '_blank')) if user.web_site?}
		</table>"
	else
		"<p class = 'istring norm'>Контактная информация скрыта, либо отсутствует</p>"
	end
end
def check_user_www_link(link)
  if link.blank?
    return 'http://visota63.ru'
  else
    if link.index(/http:\/\//).nil?
      return "http://#{link}"
    else
      return link
    end
  end
end
def show_path_buttons
	[
		{:name => 'К списку пилотов', :access => true, :type => 'arrow-right', :link => '/pilots'},
		{:name => 'Изменить общую информацию', :access =>  userCanEditUserCard?(@user), :type => 'clipboard-pencil', :link => edit_user_path(:id => @user.id), :id => 'change_password'},
		{:name => 'Уведомления', :title => "Уведомления на почтовый ящик", :access => userCanEditUserCard?(@user), :type => 'megaphone', :link => edit_user_path(:id => @user.id, :tab => 'notification_upd'), :id => 'change_notification'},
		{:name => 'Изменить E-mail', :title => "Изменить адрес электронной почты", :access => userCanEditUserCard?(@user), :type => 'mail', :link => edit_user_path(:id => @user.id, :tab => 'email_upd'), :id => 'change_email'},
    {:name => 'Изменить пароль', :access => userCanEditUserCard?(@user), :type => 'key', :link => edit_user_path(:id => @user.id, :tab => 'password_upd'), :id => 'change_password'},
    {:name => 'Удалить', :access => is_super_admin? && @user.id != 1, :type => 'trash', :link => user_path(@user), :data_method => 'delete', :data_confirm => 'Вы уверены, что хотите удалить пользователя?'}
  ]	
end
def last_user_videos(i)
  videos = @user.videos.order("created_at DESC").limit(3)
  v = ""
  if videos != []
    videos.each { |video| v += video_index_block(video)}
  	p = {
  			:tContent => "#{v}", 
			  :parity => i,
        :classLvl_2 => 'tb-pad-m'
  		}
      v = c_box_block(p)
  end
  return v
end
def edit_path_buttons
	buttons = [
					{:name => 'К профилю', :access => true, :type => 'arrow-right', :link => user_path(@user)},
					{:name => 'Изменить пароль', :access => userCanEditUserCard?(@user), :type => 'key', :link => edit_user_path(:id => @user.id, :tab => 'password_upd'), :id => 'change_password'},
					{:name => 'Изменить E-mail', :title => "Изменить адрес электронной почты", :access => userCanEditUserCard?(@user), :type => 'mail', :link => edit_user_path(:id => @user.id, :tab => 'email_upd'), :id => 'change_email'},
					{:name => 'Изменить информацию', :title => "Изменить контактные данные, фото, аватар", :access => userCanEditUserCard?(@user), :type => 'clipboard-pencil', :link => edit_user_path(:id => @user.id, :tab => 'data_upd'), :id => 'change_data'},
					{:name => 'Уведомления', :title => "Уведомления на почтовый ящик", :access => userCanEditUserCard?(@user), :type => 'megaphone', :link => edit_user_path(:id => @user.id, :tab => 'notification_upd'), :id => 'change_notification'}
				]
	buttons.each do |button|
		button[:access] = false if (params[:tab] == nil or params[:tab] == '' or params[:tab] == 'data_upd' and button[:name] == 'Изменить информацию') || (params[:tab] == 'password_upd' and button[:name] == 'Изменить пароль') || (params[:tab] == 'email_upd' and button[:name] == 'Изменить E-mail') || (params[:tab] == 'notification_upd' and button[:name] == 'Уведомления') 
	end
	return buttons
end
def index_path_buttons(user)
	[
		{:name => 'Перейти', :title => "Перейти на страницу пилота", :access => true, :type => 'b_green', :link => user_path(user)},
		{:name => 'Изменить', :title => "Изменить данные", :access => userCanEditUserCard?(user), :type => 'b_grey', :link => edit_user_path(user)}
	]
end

def data_container(data)
	"<tr><td><p class = 'istring medium-opacity'>#{data[:name]}</p></td><td><p class = 'istring'>#{data[:value]}</p></td></tr>"
end

def users_paths_buttons #buttons => {:name => 'Перейти', :title => "Перейти на страницу пилота", :access => ['all'], :type => 'b_green', :link => user_path(user)}
	#user = User.new
	buttons_array = [
					 {:name => "Клубные пилоты [#{User.club_pilots.count}]", :access => true, :type => 'b_grey', :link => '/pilots'}, 
					 {:name => "Друзья клуба [#{User.club_friends.count}]", :access => true, :type => 'b_grey', :link => '/pilots?g=club_friends'}, 
					 {:name => "Вновь прибывшие [#{User.new_users.count}]", :access => true, :type => 'b_grey', :link => '/pilots?g=just_came'}, 
					 {:name => "Бан лист [#{User.bunned.count}]", :access => is_admin?, :type => 'b_grey', :link => '/pilots?g=bun_list'}
					 ]
	buttons_array[@active_button][:selected] = true if @active_button != nil
	buttons_in_line(buttons_array)
end
#Отображение пользователя в списке пользователей end

def usersLinkString(users)
  return '' if users.blank?
  uNames = ''
  users.each {|u| uNames += "#{link_to u.name, u,class: 'b_link_i', target: '_blank'}#{', ' if u != users.last}"}
  return uNames
end

end
