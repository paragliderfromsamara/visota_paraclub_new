class Vote < ActiveRecord::Base
  attr_accessor :added_vote_values, :make_theme_flag, :topic_id
  attr_accessible :user_id, :message_id, :title, :content, :status_id, :start_date, :end_date, :vote_type_id, :private_flag, :added_vote_values, :make_theme_flag, :topic_id
  belongs_to :user
  has_many :vote_values, :dependent => :delete_all
  has_many :voices, :dependent  => :delete_all
  belongs_to :message
  has_one :theme, dependent: :destroy
  after_save :make_theme
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
				    :length => { :maximum => 800, :message => "'Вопрос' не может быть длиннее 500-ти знаков"}
  #validates :added_vote_values, :length => { :minimum => 2, :message => "Вариантов ответа не может быть меньше 2-х..."}
  
# validate :validation_vote_values
  
# def validation_vote_values
#    errors.add(:vote_values, "Вариантов ответа не может быть меньше 2-х...") if added_vote_values.length < 2
# end
  def make_theme
    if !self.make_theme_flag.blank? && self.theme.blank?
      if self.make_theme_flag.to_i == 2 
        new_name = (self.name.mb_chars.length > 100)? self.name.mb_chars[0..96] + '...' : self.name
        th = self.create_theme(
                          name: new_name,
                          content: self.content,
                          user_id: self.user_id,
                          topic_id: self.topic_id,
                          visibility_status_id: 1,
                          status_id: 1
                         )
      end
    end
  end
  def name 
  	if title == nil or title == ''
  		content.escapeBbCode
  	else
  		title
  	end
  end
  def is_private? #13-01-2016
    false if self.private_flag.blank? || self.private_flag == 1
    true if self.private_flag == 2
  end
  
  def added_vote_values=(attrs)
	  attrs.each {|attr| self.vote_values.build(:value => attr[1]) if attr[1].strip != ''}
  end
  def self.active_votes
      Vote.where("end_date > :time_now", {:time_now => Time.now})
  end 
  def self.completed_votes
      Vote.where("end_date < :time_now", {:time_now => Time.now})
  end
  
end
