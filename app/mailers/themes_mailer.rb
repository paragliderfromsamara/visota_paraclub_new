class ThemesMailer < ApplicationMailer
	def new_theme_notification(theme, user)
    @user = user
    @theme = theme
  	@link = "http://localhost:3000/themes/#{theme.id}" #'http://visota-paraclub.ru'
  	@target_link = "<a href = 'http://#{@link}'>Ссылка на новую тему</a>"

        mail(to: user.email, :subject => "Новая тема в разделе #{theme.topic.name}") do |format|
          format.text
          #format.html
        end
  end
end
