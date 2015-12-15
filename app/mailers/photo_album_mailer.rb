class PhotoAlbumMailer < ApplicationMailer
  def new_album_mailer(album, user)
    @user = user
    @album = album
    @link = "visota-paraclub.ru/photo_albums/#{album.id}" #'http://visota-paraclub.ru'
    @target_link = "<a href = 'http://#{@link}'>Перейти к фотоальбому</a>"
    mail(to: user.email, :subject => "Новый фотоальбом в разделе #{@album.category_name}") do |format|
      format.text
      format.html
    end
  end
end
