class LikeMarksController < ApplicationController
include LikeMarksHelper
  def switch_mark
    markData = params[:mark]
    if signed_in? and markData != nil
			v = {}
      if markData[:type] == 'photo'
        v = switchPhotoLike(markData[:id])
      elsif markData[:type] == 'photo_album'
        v = switchPhotoAlbumLike(markData[:id])
      elsif markData[:type] == 'video'
        v = switchVideoLike(markData[:id])
      end
      respond_to do |format|
				format.json { render :json => v}
			end
      
    end
  end
end
