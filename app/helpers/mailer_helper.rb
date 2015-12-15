module MailerHelper
  def sendCheckUserData(user)
    UserMailer.user_check(user).deliver_now if user.user_group_id == 5
    UserMailer.mail_check(user).deliver_now if user.user_group_id != 5
  end
  def sendNewAlbumMail(album)
    if album.photos.length > 2
      mailers = Mailer.where(album:'yes', user_id: 1)
      if mailers != []
        mailers.each do |m|
          if m.user != album.user && m.user.email_status == 'Активен'
            PhotoAlbumMailer.new_album_mailer(album, m.user).deliver_later
          end
        end
      end
    end
  end

end
