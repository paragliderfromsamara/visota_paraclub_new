class LikeMark < ActiveRecord::Base
  attr_accessible :user_id
  belongs_to :user
  belongs_to :likeble_entity, :polymorphic => true
end
