class Event < ActiveRecord::Base
  attr_accessible :title, :content, :updated_at, :status_id, :post_date, :uploaded_photos, :attachment_files, :theme_id, :photo_album_id, :video_id, :article_id
 
  has_many :entity_photos, :as => :p_entity, :dependent => :destroy #has_many :photos, :dependent  => :delete_all
  has_many :photos, through: :entity_photos
  
  belongs_to :photo_album
  belongs_to :video
  belongs_to :article
  belongs_to :photo
  belongs_to :theme
  require 'will_paginate'
  
  auto_html_for :content do
	html_escape
  my_google_map
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
  
  after_save :check_photos_in_content
  #Проверка
  validates :content, :presence => {:message => "Поле \"Текст новости\" не должно быть пустым"},
 				     :length => { :maximum => 15000, :message => "Текст новости не должен быть длиннее 15000 символов"}
 				     #:on => :create
 				     #:if => :has_attachments_and_photos? 
  #end
#Зоны видимости------------------------------------------------------------
  def display_area_list
	[
    {:value => 2, :name => 'Только в корне гостевой'},
		{:value => 1, :name => 'Только главная страница'},
		{:value => 3, :name => 'На главной странице и в корне гостевой'}
	]
  end
  def get_display_area_list_item
	value = {}
	display_area_list.each do |item|
		value = item if display_area_id == item[:value] 
	end
	return value
  end
#Зоны видимости end--------------------------------------------------------
#Статус новости------------------------------------------------------------
  def statuses_list
	[
		{:value => 0, :name => 'Черновик'},
    {:value => 1, :name => 'Не активна'},
		{:value => 2, :name => 'Активна'}
	]
  end
  def get_status_item
	value = {}
	statuses_list.each do |item|
		value = item if status_id == item[:value] 
	end
	return value
  end
#Статус новости end--------------------------------------------------------

	def alter_content
		 if short_content != '' and short_content != nil
			return short_content if short_content.strip != ''
		 end
		return content
	end
	def alter_photo(type)
		photo_tag = nil
		if video != nil
			width = '250px' if type == 'article' or type == 'thumb'
			width = '150px' if type == 'small' || type == 'small_thumb'
			if video.image_link != '' and video.image_link != nil
				photo_tag = "<img src = '#{video.image_link}' width = #{width} align = 'left' style = 'padding-right: 5px;'/>"
			end
		else
			photo_to_return = nil
			if !article.nil? || !photo_album.nil? || photo != nil || photos != [] || !theme.nil?
				if !photo_album.nil?
					photo_to_return = photo_album.get_photo
        elsif !article.nil?
					photo_to_return = article.alter_photo  
        elsif !theme.nil?
          photo_to_return = self.theme.photos.first
        end
        if !self.photos.blank? && photo_to_return.nil?
				  photo_to_return = self.photos.first if self.photo.nil? 
				  photo_to_return = self.photo if !self.photo.nil?
        end
			end
			if !photo_to_return.nil?
        if photo_to_return.link?
  				if type == 'thumb'
  					photo_tag = "<img src = '#{photo_to_return.link.thumb}' align = 'left' style = 'padding-right: 5px;' />"
  				elsif type == 'article'
  					photo_tag = "<img src = '#{photo_to_return.link.article}' align = 'left' style = 'padding-right: 5px;' />"
  				elsif type == 'small'
  					photo_tag = "<img src = '#{photo_to_return.link.small}' align = 'left' style = 'padding-right: 5px;' />"
  				elsif type == 'small_thumb'
  					photo_tag = "<img src = '#{photo_to_return.link.small_thumb}' align = 'left' style = 'padding-right: 5px;' />"
  				end
        end
			end
		end

		return photo_tag
	end
	def uploaded_photos=(attrs)
		attrs.each {|attr| self.photos.build(:link => attr)}
	end
  
 	def visible_photos #Видимые фотографии
     photos.where(id: entity_photos.select(:photo_id).where(visibility_status_id: [1, nil]))
 	end  
  
	def check_photos_in_content
		if photos != []
			photos.each do |ph|
				if content.index("#Photo#{ph.id}") != nil and content.index("#Photo#{ph.id}") != -1
					self.entity_photos.where(photo_id: ph.id).first.set_as_hidden
				else
					self.entity_photos.where(photo_id: ph.id).first.set_as_visible
				end
			end
		end
	end
	def link_to
		link = "/events/#{id}"
		link = "/articles/#{article.id}" if article != nil
		link = "/photo_albums/#{photo_album.id}" if photo_album != nil
		link = "/videos/#{video.id}" if video != nil
    link = "/themes/#{theme.id}" if !theme.nil?
		return link
	end
  
  def clean #обязательно должна вызываться при обновлении сообщений
  	if self.photos != []
  		self.photos.each do |ph|
  			ph.destroy
  		end
  	end					
  end
  def assign_entities_from_draft(draft)
    if draft != nil
      if draft.photos != []
        draft.photos.each do |ph|
    			ph.update_attributes(:event_id => self.id, :status_id => 1, :visibility_status_id => 1)
        end
      end
    end
  end

end
