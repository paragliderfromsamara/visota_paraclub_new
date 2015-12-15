class UserMailer < ApplicationMailer
  def mail_check(user)
  	@user = user
  	action = 'action_type=mail_check'
  	@target_link = "http://#{default_url_options[:host]}/mail_switcher?email=#{user.email}&value=#{user.salt}&name=#{@user.name}&#{action}"
    mail(to: user.email, :subject => "Проверка E-mail адреса") do |format|
      format.text
      format.html
    end
  end
  
  def mail_remember_password(user)
  	@user = user
  	action = 'action_type=remember_password'
  	@target_link = "http://#{default_url_options[:host]}/mail_switcher?email=#{user.email}&value=#{user.salt}&name=#{@user.name}&#{action}"
    mail(to: user.email, :subject => "Восстановление пароля") do |format|
      format.text
      format.html
    end
  end
  
  def user_check(user) #проверено 13-12-15
  	@user = user
  	action = 'action_type=user_check'
  	@target_link = "http://#{default_url_options[:host]}/mail_switcher?email=#{user.email}&value=#{user.salt}&name=#{@user.name}&#{action}"
    mail(to: user.email, :subject => "Проверка связи") do |format|
      format.text
      format.html
    end
  end
end
