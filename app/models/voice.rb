class Voice < ActiveRecord::Base
  attr_accessible :vote_value_id, :user_id, :vote_id
  belongs_to :user
  belongs_to :vote_value
  belongs_to :vote
  validate :check_exist_voice, :on => :create
  def check_exist_voice
    extVoice = Voice.find_by(user_id: self.user_id, vote_id: self.vote_id)
    errors.add(:user_id, "У Вас недостаточно прав для создания новой темы.") if !extVoice.nil?
  end
  
end
