module LikeMarksHelper
  def user_photo_like_link(photo)
    v = ''
    i = '/files/like_g.png'
    counter = "<span id = 'mark_count'>#{photo.photo_like_marks.count.to_s}</span>"
    if signed_in?
      like = photo.photo_like_marks.where(:user_id => current_user.id)
      if like == []
        v = "Мне нравится"
        i = '/files/like_g.png'
      else
        v = "Больше не нравится"
        i = '/files/like_b.png'
      end
      v = "<a id = 'mark_link'>#{v}</a>"
    end
    v = v = "<div class = 'like_marks' onclick = \"switchLikeMark(#{photo.id}, 'photo')\" id = 'photo_#{photo.id}_mark'><table><tr><td valign = 'midle'>#{v}</td><td><div id = 'mark_img' style = 'background-image: url(#{i});'></div></td><td valign = 'middle'>#{counter}</td></tr></table></div>"
    return v.html_safe
  end
  
  def user_photo_album_like_link(album)
    v = ''
    i = '/files/like_g.png'
    counter = "<span id = 'mark_count'>#{album.photo_album_like_marks.count.to_s}</span>"
    if signed_in?
      like = album.photo_album_like_marks.where(:user_id => current_user.id)
      if like == []
        v = "Мне нравится"
        i = '/files/like_g.png'
      else
        v = "Больше не нравится"
        i = '/files/like_b.png'
      end
      v = "<a id = 'mark_link'>#{v}</a>"
    end
    v = "<div class = 'like_marks' onclick = \"switchLikeMark(#{album.id}, 'photo_album')\" id = 'photo_album_#{album.id}_mark'><table><tr><td valign = 'midle'>#{v}</td><td><div id = 'mark_img' style = 'background-image: url(#{i});'></div></td><td valign = 'middle'>#{counter}</td></tr></table></div>"
    return v.html_safe
  end
  
  def user_video_like_link(video)
    v = ''
    i = '/files/like_g.png'
    counter = "<span id = 'mark_count'>#{video.video_like_marks.count.to_s}</span>"
    if signed_in?
      like = video.video_like_marks.where(:user_id => current_user.id)
      if like == []
        v = "Мне нравится"
        i = '/files/like_g.png'
      else
        v = "Больше не нравится"
        i = '/files/like_b.png'
      end
      v = "<a id = 'mark_link'>#{v}</a>"
    end
    v = "<div class = 'like_marks' onclick = \"switchLikeMark(#{video.id}, 'video')\" id = 'video_#{video.id}_mark'><table><tr><td valign = 'middle'>#{v}</td><td><div id = 'mark_img' style = 'background-image: url(#{i});'></div></td><td valign = 'middle'>#{counter}</td></tr></table></div>"
    return v.html_safe
  end
  
  def switchPhotoLike(id)
    ph = Photo.find_by(id: id)
    if ph != nil
      mCount = ph.photo_like_marks.count
      like = ph.photo_like_marks.where(user_id: current_user.id).first
      if like == nil
        if ph.photo_like_marks.create(user_id: current_user.id)
          return disLikeBut(mCount + 1)
        end
      else
        if like.destroy
          return likeBut(mCount - 1)
        end 
      end
    else
      return {}
    end
  end
  
  def switchPhotoAlbumLike(id)
    al = PhotoAlbum.find_by(id: id)
    if al != nil
      mCount = al.photo_album_like_marks.count
      like = al.photo_album_like_marks.where(user_id: current_user.id).first
      if like == nil
        if al.photo_album_like_marks.create(user_id: current_user.id)
          return disLikeBut(mCount + 1)
        end
      else
        if like.destroy
          return likeBut(mCount - 1)
        end 
      end
    else
      return {}
    end
  end

  def switchVideoLike(id)
    v = Video.find_by(id: id)
    if v != nil
      mCount = v.video_like_marks.count
      like = v.video_like_marks.where(user_id: current_user.id).first
      if like == nil
        if v.video_like_marks.create(user_id: current_user.id)
          return disLikeBut(mCount + 1)
        end
      else
        if like.destroy
          return likeBut(mCount - 1)
        end 
      end
    else
      return {}
    end
  end 
  
  def likeBut(c)
    {:linkName => "Мне нравится", :mCount => c, :img => '_g'}
  end
  def disLikeBut(c)
    {:linkName => "Больше не нравится", :mCount => c, :img => '_b'}
  end
end
