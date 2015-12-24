class MessageMailer < ApplicationMailer
  def new_message_in_theme_mailer(message, user)
    @user = user
    @message = message
    @link = "http://#{default_url_options[:host]}/themes/#{message.theme.id}#msg_#{message.id}" #'http://visota-paraclub.ru'
    @target_link = "<a href = '#{@link}'>Перейти к теме</a>"
    mail(to: user.email, :subject => "Новое сообщение в теме \"#{message.theme.name}\"") do |format|
      format.text
      format.html
    end
  end
  def new_answer_in_theme_mailer(message, user)
    @user = user
    @message = message
    @link = "http://#{default_url_options[:host]}/themes/#{message.theme.id}#msg_#{message.id}" #'http://visota-paraclub.ru'
    @target_link = "<a href = '#{@link}'>Перейти к теме</a>"
    mail(to: user.email, :subject => "Ответ в теме \"#{message.theme.name}\" от пользователя #{message.user.name}") do |format|
      format.text
      format.html
    end
  end
  def new_comment_in_photo_mailer(message, user)
    @user = user
    @message = message
    @link = "http://#{default_url_options[:host]}/photos/#{message.photo.id}#msg_#{message.id}" #'http://visota-paraclub.ru'
    @target_link = "<a href = '#{@link}'>Перейти к фотографии</a>"
    mail(to: user.email, :subject => "Новый комментарий к фотографии") do |format|
      format.text
      format.html
    end
  end
  def new_answer_in_photo_mailer(message, user)
    @user = user
    @message = message
    @link = "http://#{default_url_options[:host]}/photos/#{message.photo.id}#msg_#{message.id}" #'http://visota-paraclub.ru'
    @target_link = "<a href = '#{@link}'>Перейти к фотографии</a>"
    mail(to: user.email, :subject => "Новый комментарий к фотографии") do |format|
      format.text
      format.html
    end
  end
  def new_comment_in_album_mailer(message, user)
    @user = user
    @message = message
    @link = "http://#{default_url_options[:host]}/photo_albums/#{message.photo_album.id}#msg_#{message.id}" #'http://visota-paraclub.ru'
    @target_link = "<a href = '#{@link}'>Перейти к фотоальбому</a>"
    mail(to: user.email, :subject => "Новый комментарий к фотоальбому") do |format|
      format.text
      format.html
    end
  end
  def new_answer_in_album_mailer(message, user)
    @user = user
    @message = message
    @link = "http://#{default_url_options[:host]}/photo_albums/#{message.photo_album.id}#msg_#{message.id}" #'http://visota-paraclub.ru'
    @target_link = "<a href = '#{@link}'>Перейти к фотоальбому</a>"
    mail(to: user.email, :subject => "Ответ на комментарий к фотоальбому") do |format|
      format.text
      format.html
    end
  end
  def new_comment_in_video_mailer(message, user)
    @user = user
    @message = message
    @link = "http://#{default_url_options[:host]}/videos/#{message.video.id}#msg_#{message.id}" #'http://visota-paraclub.ru'
    @target_link = "<a href = '#{@link}'>Перейти к видео</a>"
    mail(to: user.email, :subject => "Новый комментарий к видео") do |format|
      format.text
      format.html
    end
  end
  def new_answer_in_video_mailer(message, user)
    @user = user
    @message = message
    @link = "http://#{default_url_options[:host]}/videos/#{message.video.id}#msg_#{message.id}" #'http://visota-paraclub.ru'
    @target_link = "<a href = '#{@link}'>Перейти к видео</a>"
    mail(to: user.email, :subject => "Ответ на комментарий к видео") do |format|
      format.text
      format.html
    end
  end
end
