class EntityPhoto < ActiveRecord::Base
  attr_accessible :p_entity_id, :p_entity_type, :photo_id, :visibility_status_id
  
  belongs_to :p_entity, :polymorphic => true
  belongs_to :photo 
  
  before_destroy :check_photo
  
  def check_photo
    self.photo.destroy if self.photo.entity_photos.where.not(id: self.id).count == 0
  end
  
  def set_as_visible
	  self.update_attribute(:visibility_status_id, 1) if self.visibility_status_id != 1 #Пометить как видимый
  end
  
  def set_as_hidden
    self.update_attribute(:visibility_status_id, 2) if self.visibility_status_id != 2 #Пометить как скрытый
  end
  
end
