class UserMailer < ActionMailer::Base
  default :from => '"ВЫСОТА" - Самарский Парапланерный Клуб <noreply@visota-paraclub.ru>'
  def mail_check(user)
	@user = user
	site_link = '46.38.62.245:3000' #'http://visota-paraclub.ru'
	action = 'action_type=mail_check'
	@target_link = "<a href = 'http://#{site_link}/mail_switcher?email=#{user.email}&value=#{user.salt}&name=#{@user.name}&#{action}'>Ссылка на подтверждение почтового адреса</a>"
	mail(
			:to => user.email,
			:subject => "Проверка E-mail адреса"
		)
  end
  
  def mail_remember_password(user)
	@user = user
	action = 'action_type=remember_password'
	site_link = '46.38.62.245:3000' #'http://visota-paraclub.ru'
	@target_link = "<a href = 'http://#{site_link}/mail_switcher?email=#{user.email}&value=#{user.salt}&name=#{@user.name}&#{action}'>Ссылка на страницу восстановления пароля</a>"
	mail(
			:to => user.email,
			:subject => "Восстановление пароля"
		)
  end
  
  def user_check(user, password)
	@user = user
	@pswrd = password
	action = 'action_type=user_check'
	site_link = '46.38.62.245:3000' #'http://visota-paraclub.ru'
	@target_link = "<a href = 'http://#{site_link}/mail_switcher?email=#{user.email}&value=#{user.salt}&name=#{@user.name}&#{action}'>Ссылка на подтверждение аккаунта</a>"
	mail(
			:to => user.email,
			:subject => "Проверка связи"
		)
  end
  def user_new_password(user, password)
	@user = user
	@pswrd = password
	mail(
			:to => user.email,
			:subject => "Данные для входа на сайт"
		)
  end
end
