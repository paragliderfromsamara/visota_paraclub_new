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
  def sendNewThemeMail(theme) #добавлено в Themes update
    users = User.select(:id).where(email_status: 'Активен', user_group_id: theme.users_who_can_see).where.not(id: theme.user_id)
    mailers = TopicNotification.where(topic_id:theme.topic_id, user_id: users)
    mailers.each {|m| ThemesMailer.new_theme_notification(theme, m.user).deliver_later if m.user_id == 1} if mailers != []
  end
  def sendNewMessageMail(message)  
   # mailers = TopicNotification.where(topic_id:theme.topic_id, user_id: users)
   # mailers.each {|m| ThemesMailer.new_theme_notification(theme, m.user).deliver_later if m.user_id == 1} if mailers != []
    if !message.theme.nil?
      message_to_user_id = (message.message.nil?)? nil : message.message.user_id
      ntfs = message.theme.theme_notifications.select(:user_id).where.not(user_id: message_to_user_id)
      if ntfs != []
        users = User.select(:id).where(email_status: 'Активен', id: ntfs)
        mailers = Mailer.where(message:'yes', user_id: users)
        mailers.each {|m| MessageMailer.new_message_in_theme_mailer(message, m.user).deliver_later if m.user.id == 1} if mailers != []
      end
      if !message.message.nil?
        u = message.message.user 
        MessageMailer.new_answer_in_theme_mailer(message, u).deliver_later if u != message.user && u.email_status == 'Активен' && u.mailer.message == 'yes'&& u.id == 1
      end  
    elsif !message.video.nil?
    elsif !message.photo_album.nil? 
    end
  end
end
