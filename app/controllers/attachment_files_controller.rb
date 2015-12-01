class AttachmentFilesController < ApplicationController
  def index
    @eType = params[:e]
    @eId = params[:e_id]
    if @eType != nil && @eId != nil
      case @eType
      when 'article'
        @files = AttachmentFile.where(article_id: @eId)
      when 'theme'
        @files = AttachmentFile.where(theme_id: @eId)
      when 'message'
        @files = AttachmentFile.where(message_id: @eId)
      end
    else
      @files = AttachmentFile.all
    end
    respond_to do |format|
      format.html
      format.json do
        jsonData = []
        @files.each do |f|
          jsonData[jsonData.length] = {name: f.name, link: f.link, id: f.id, size: f.alter_size}
        end
        render json: jsonData
      end
    end
     
  end
  def destroy
    aFile = AttachmentFile.find(params[:id])
    if aFile != nil 
      @id = aFile.id
      if aFile.user == current_user || is_admin?
        respond_to do |frmt|
          if aFile.destroy
            frmt.json {render json: {success: true}}
          end
        end
      end
    end
  end
end
