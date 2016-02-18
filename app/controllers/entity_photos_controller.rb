class EntityPhotosController < ApplicationController
  def destroy
    ePhoto = EntityPhoto.find(params[:id])
    if userCanDeleteEntityPhoto?(ePhoto) || user_type == 'admin'
      phId = ePhoto.photo_id
			if ePhoto.destroy
				respond_to do |format|
				  format.html { redirect_to photos_url }
				  format.json { render :json => {:callback => 'success', id: phId} }
				end
			end
		end
  end
end
