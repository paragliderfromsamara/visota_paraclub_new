class VideoMailer < ApplicationMailer
  def new_video_mailer(video, user)
    @user = user
    @video = video
    @link = "visota-paraclub.ru/videos/#{video.id}" #'http://visota-paraclub.ru'
    @target_link = "<a href = 'http://#{@link}'>Перейти к видео</a>"
    mail(to: user.email, :subject => "Новое видео в категории #{@video.category_name}") do |format|
      format.text
      format.html
    end
  end
end
