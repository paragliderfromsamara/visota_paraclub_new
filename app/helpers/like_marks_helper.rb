module LikeMarksHelper
  def user_photo_like_link(photo)
    givenLike = (signed_in?)? photo.like_marks.where(:user_id => current_user.id).count : 0
    f = (givenLike  > 0)? true : false
    c = photo.like_marks.count
    return makeLikeBut(f, photo, c).html_safe
  end
  
  def user_photo_album_like_link(album)
    givenLike = (signed_in?)? album.like_marks.where(:user_id => current_user.id).count : 0
    f = (givenLike  > 0)? true : false
    c = album.like_marks.count
    return makeLikeBut(f, album, c).html_safe
  end
  
  def user_video_like_link(video)
    givenLike = (signed_in?)? video.like_marks.where(:user_id => current_user.id).count : 0
    f = (givenLike  > 0)? true : false
    c = video.like_marks.count
    return makeLikeBut(f, video, c).html_safe
  end
  
  def switchPhotoLike(id)
    ph = Photo.find(id)
    if ph != nil
      mCount = ph.like_marks.count
      like = ph.like_marks.where(user_id: current_user.id).first
      if like == nil
        if ph.like_marks.create(user_id: current_user.id)
          return disLikeBut(mCount + 1)
        end
      else
        if like.delete
          return likeBut(mCount - 1)
        end 
      end
    else
      return {}
    end
  end
  
  def switchPhotoAlbumLike(id)
    al = PhotoAlbum.find(id)
    if al != nil
      mCount = al.like_marks.count
      like = al.like_marks.where(user_id: current_user.id).first
      if like == nil
        if al.like_marks.create(user_id: current_user.id)
          return disLikeBut(mCount + 1)
        end
      else
        if like.delete
          return likeBut(mCount - 1)
        end 
      end
    else
      return {}
    end
  end

  def switchVideoLike(id)
    v = Video.find(id)
    if v != nil
      mCount = v.like_marks.count
      like = v.like_marks.where(user_id: current_user.id).first
      if like == nil
        if v.like_marks.create(user_id: current_user.id)
          return disLikeBut(mCount + 1)
        end
      else
        if like.delete
          return likeBut(mCount - 1)
        end 
      end
    else
      return {}
    end
  end 
  
  def makeLikeBut(f, e, c)
    t = (f)? (disLikeBut(c)):(likeBut(c))
    v = (!signed_in?)? (""):("<span id = 'mark_link'>#{t[:linkName]}</span>")
    return "<div lm-entity-id = \"#{e.id}\" lm-entity-type = \"#{e.class.name.downcase}\" class='stat fi-float-right like_marks'>#{v} <i id = 'mark_img' class = 'fi-heart fi-small #{t[:img]}'></i><span id = 'mark_count'>#{t[:mCount]}</span></div>"
  end
  def likeBut(c)
    {:linkName => "Мне нравится", :mCount => c, :img => 'fi-grey'}
  end
  
  def disLikeBut(c)
    {:linkName => "Больше не нравится", :mCount => c, :img => 'fi-blue'}
  end
end
