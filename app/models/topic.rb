class Topic < ActiveRecord::Base
  attr_accessible :description, :image, :name, :image_cache
  has_many :messages, -> {where(status_id: 1)}
  has_many :themes, -> {where(:status_id => [1,3]).order('last_message_date DESC')}
  #has_many :old_messages
  mount_uploader :image, ImageUploader
  
  def alter_image
   return '/files/undefined.png' if image == nil or image == ''
   return image if image != nil and image != ''
  end
  
  def last_active_themes(is_not_authorized)
	v_status = 1
	v_status = [1,2] if !is_not_authorized
    return self.themes.select('id, name, last_message_date, user_id, created_at').where(:visibility_status_id => v_status).order('last_message_date DESC').limit(4)
  end
  
  def entities_count(is_not_authorized)
	c = {:cThemes => 0, :cMessages => 0}
	v_status = 1
	v_status = [1,2] if !is_not_authorized
	c[:cThemes] = self.themes.where(:visibility_status_id => v_status).size
	c[:cMessages] = self.messages.size
	return c
  end
  
  #Для адаптации старого форума в новый
  def firstMessages
    msgs = Message.select(:name, :id).where(photo_id: nil, video_id: nil, first_message_id: nil, topic_id: self.id)#.order('id ASC')
    msgsWithoutName = []
    msgsWithName = [] 
    msgs.each do |m|
      if m.name.blank?
        msgsWithoutName[msgsWithoutName.length] = m.id
      else
        msgsWithName[msgsWithName.length] = m.id
      end
    end
    return {withName: msgsWithName, withoutName: msgsWithoutName}       
    #self.messages.rewhere(:photo_id => nil, :video_id => nil, :first_message_id => nil).order('id ASC')
  end
 
  def firstMessagesWithoutName(ids) #Находим все первые сообщения без заголовка
    #frst_messages = []
    Message.where(id: ids).order('id ASC')
    #msgs += self.messages.select(:id).rewhere(:photo_id => nil, :video_id => nil, :first_message_id => nil, :name => '')
    #if msgs != []
	  #  frst_messages = Message.where(id: msgs).order('id ASC')
    #end
	  #return frst_messages 
  end
  def firstMessagesWithName(ids) #Находим все первые сообщения c заголовком
	  Message.where(id: ids).order('id ASC')
  end
  
  def is_not_equipment? #проверка не является ли раздел купи-продайкой
    self.id != 9
  end
end
