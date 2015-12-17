module MailerHelper
  def sendCheckUserData(user)
    UserMailer.user_check(user).deliver_now if user.user_group_id == 5
    UserMailer.mail_check(user).deliver_now if user.user_group_id != 5
  end
  def sendNewAlbumMail(album) #добавлено в PhotoAlbumsController update
    if album.photos.length > 2 and album.status_id == 1
      users = User.select(:id).where(email_status: 'Активен').where.not(id: album.user_id)
      mailers = Mailer.where(album:'yes', user_id: users)
      mailers.each {|m| PhotoAlbumMailer.new_album_mailer(album, m.user).deliver_later if m.user_id == 1} if mailers != []
    end
  end
  def sendNewVideoMail(video) #добавлено в VideosController create
    users = User.select(:id).where(email_status: 'Активен').where.not(id: video.user_id)
    mailers = Mailer.where(video:'yes', user_id: users)
    mailers.each {|m| VideoMailer.new_video_mailer(video, m.user).deliver_later if m.user_id == 1} if mailers != []
  end
  def sendNewThemeMail(theme)
    users = User.select(:id).where(email_status: 'Активен').where.not(id: theme.user_id)
    mailers = TopicNotification.where(topic_id:theme.topic_id, user_id: users)
    mailers.each {|m| ThemesMailer.new_theme_notification(theme, m.user).deliver_later if m.user_id == 1} if mailers != []
  end
end
