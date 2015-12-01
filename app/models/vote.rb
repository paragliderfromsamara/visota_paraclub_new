class Vote < ActiveRecord::Base
  #при переносе заменить в бд имена столбцов title на name, privat_flag на visibility_status_id
  attr_accessor :added_vote_values
  attr_accessible :user_id, :message_id, :title, :content, :status_id, :start_date, :end_date, :vote_type_id, :privat_flag, :added_vote_values
  belongs_to :user
  has_many :vote_values, :dependent => :delete_all
  has_many :voices, :dependent  => :delete_all
  belongs_to :message
 
  auto_html_for :content do
    html_escape
	  my_youtube_msg(:width => 480, :height => 360, :span => true)
	  my_vimeo(:width => 480, :height => 360, :span => true)
	  vk_video_msg(:width => 480, :height => 360, :span => true)
	  smiles
    link :target => "_blank", :rel => "nofollow", :class => "b_link"
	  my_photo_hash
	  user_hash
	  theme_hash
	  my_quotes
	  fNum
    simple_format
  end
  
  validates :content, :presence => {:message => "Поле 'Вопрос' не должно быть пустым"},
				      :length => { :maximum => 800, :message => "Название не может быть длиннее 500-ти знаков"}
  #validates :added_vote_values, :length => { :minimum => 2, :message => "Вариантов ответа не может быть меньше 2-х..."}
  
# validate :validation_vote_values
  
# def validation_vote_values
#    errors.add(:vote_values, "Вариантов ответа не может быть меньше 2-х...") if added_vote_values.length < 2
# end
  def name 
	if title == nil or title == ''
		content.escapeBbCode
	else
		title
	end
  end
  def added_vote_values=(attrs)
	  attrs.each {|attr| self.vote_values.build(:value => attr[1]) if attr[1].strip != ''}
  end
end
