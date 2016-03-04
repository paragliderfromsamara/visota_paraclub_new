class Video < ActiveRecord::Base
  attr_accessible :article_id, :category_id, :description, :link, :name, :user_id, :event_id, :image_link, :mini_link
  belongs_to :user
  belongs_to :article
  has_many :messages, :dependent  => :delete_all
  has_many :like_marks, :as => :likeble_entity, :dependent  => :delete_all
  has_one :entity_view, :as => :v_entity, :dependent => :delete
  has_one :event, dependent: :destroy
  require 'will_paginate'
  #has_many :events, :dependent  => :delete_all
	auto_html_for :link do 
		my_youtube(:width => 640, :height => 480)
		my_vimeo(:width => 640, :height => 480)
		vk_video(:width => 640, :height => 480)
	end
	auto_html_for :mini_link do 
		my_youtube(:width => 320, :height => 240)
		my_vimeo(:width => 320, :height => 240)
		vk_video(:width => 320, :height => 240)
	end
	
	def alter_name
		if name == nil
			"Видео от #{created_at.strftime("%d.%m.%Y в %k:%M:%S")}"
		else
			name
		end
	end
	def visible_messages
		Message.where(video_id: self.id, status_id: 1).order('created_at ASC')
	end
	
	before_save :make_mini_link
	after_save :make_name
	
	def make_mini_link
		self.mini_link = link
    end
	
	def make_name
		self.name = alter_name
	end
	
	 #validation    ---
	 video_regex = /(https?:\/\/(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=(player_detailpage|player_embedded)&v=)([A-Za-z0-9_-]*)(\&\S+)?(\?\S+)?)|(<iframe\s+src="(http:\/\/vk\.com\/video_ext\.php)\?oid=(\d+)&id=(\d+)&hash=(.+)(&hd=(\d{1}))?"\s+width="(\d{1,3})"\s+height="(\d{1,3})"\s+frameborder="(\d{1})"(.+)?><\/iframe>)|(https?:\/\/(www.)?vimeo\.com\/([A-Za-z0-9._%-]*)((\?|#)\S+)?)/
	  validates :link, 
    :presence => {:message => "Поле 'Ссылка' должно быть заполнено"},
    				     :format => {:with => video_regex, :message => "Поле не соответсвует формату ссылок youtube, vimeo, vk.com"},
				       :uniqueness => {:case_sensitive => false, :message => "Видео с такой ссылкой уже добавлено"}
	validates :description, :length => { :maximum => 5000, :message => "Описание не может быть более 5000 знаков"}
	validates :name, :length => { :maximum => 100, :message => "Название не может быть длиннее 100 знаков"}
					
	 #validation end---

	  
  #categories end---
  #Просмотры--------
  def views
	  #Step.where(part_id: 3, page_id: 1, entity_id: self.id)
    (self.entity_view == nil)? 0 : self.entity_view.counter 
  end
  #Просмотры end
end
