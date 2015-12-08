class EntityView < ActiveRecord::Base
  attr_accessible :v_entity_id, :v_entity_type, :counter
  belongs_to :v_entity, :polymorphic => true
  
  def increment_counter
    self.update_attribute(:counter, self.counter += 1)
  end
end
