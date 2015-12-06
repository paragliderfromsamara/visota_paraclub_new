class EntityView < ActiveRecord::Base
  attr_accessible :v_entity_id, :v_entity_type, :counter
  belongs_to :v_entity, :polymorphic => true
end
