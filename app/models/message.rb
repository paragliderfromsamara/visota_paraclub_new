class Message < ActiveRecord::Base
  attr_accessor :deleted_photos
  attr_accessible :content, :first_message_id, :message_id, :photo_id, :photo_album_id, :name, :theme_id, :topic_id, :updater_id, :user_id, :video_id, :uploaded_photos, :article_id, :attachment_files, :status_id, :created_at, :updated_at, :base_theme_id, :visibility_status_id, :deleted_photos
 
  belongs_to :user
  belongs_to :video
  
  has_many :entity_photos, :as => :p_entity, :dependent => :destroy #has_many :photos, :dependent  => :delete_all
  has_many :photos, through: :entity_photos
  
  has_many :attachment_files, :dependent => :delete_all
  belongs_to :photo
  belongs_to :topic
  belongs_to :theme 
  belongs_to :message
  belongs_to :article
  belongs_to :photo_album
  has_many :messages 
  require 'will_paginate'
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
  #start_quote
  #end_quote
  #after_create :update_last_message_date_in_theme
  after_save :check_photos_in_content #проверить наличие хэш тэгов фотографий, прикреплённых к сообщению, в тексте перед сохранением
  after_update :delete_selected_photos
  before_destroy :clean_binded_entities
  #before_save :make_first_message_id #хрен знает зачем это нужно...
  #-Валидации--------------------------------------------------
  def clean_binded_entities
	if self.messages != []
		self.messages.each do |msg|
			msg.update_attribute(:message_id, nil)
		end
	end
  end
  validate :validation_content
  def validation_content
    delPhotosLenght = (self.deleted_photos != nil and self.deleted_photos != '')? getIds(self.deleted_photos).length : 0  
    photosFlag = (self.photos == []) || (delPhotosLenght == self.photos.length)
    statusFlag = self.status_id == 1
    attachmentsFlag = self.attachment_files == [] || self.attachment_files == nil
		if delPhotosLenght && photosFlag && statusFlag && attachmentsFlag
			errors.add(:content, "Содержимое сообщения не может быть пустым...") if self.content.strip == ''
		end
		if content != nil and content != ''
			errors.add(:content, "Содержимое не может быть длиннее 150000 символов") if content.mb_chars.size > 200000
		end
  end

  def delete_selected_photos
    if self.deleted_photos != nil and self.deleted_photos != ''
      arr = getIds(self.deleted_photos)
      if !(arr.length == self.photos.length and self.content.strip == '') 
        if arr.length > 0
          arr.each do |p_id|
            ph = Photo.find_by(:id => p_id, :message_id => self.id)
            ph.destroy if ph != nil
          end
        end
      end
    end
  end
  
  def main_parent
	return self.theme if self.theme != nil
	return self.photo_album if self.photo_album != nil
	return self.photo if self.photo != nil
	return nil
  end
  
  def check_photos_in_content #ищем хэш тэг фотографии в сообщении
	if photos != [] and photos != nil
		photos.each do |ph|
			check_photo_in_content(ph)
			ph.update_attribute(:status_id, 1) if ph.status != 'draft'
		end
	end
  end  
  def check_photo_in_content(ph) #делаем фотографию невидимой в основном списке фотографий сообщения и делаем видимой, если её там нет
		if content.index("#Photo#{ph.id}") != nil and content.index("#Photo#{ph.id}") != -1
			self.entity_photos.where(photo_id: ph.id).first.set_as_hidden
		else
			self.entity_photos.where(photo_id: ph.id).first.set_as_visible
		end  
  end
  #-Валидации end----------------------------------------------
#Загрузка контента  
  def uploaded_photos=(attrs)
	attrs.each {|attr| self.photos.build(:link => attr, :user_id => self.user_id)}
  end
  def attachment_files=(attrs)
	attrs.each {|attr| self.attachment_files.build(:link => attr, :user_id => self.user_id, :directory => "messages/#{self.theme_id}")}
  end
#Загрузка контента end  
  #статусы...  
  def statuses 
	[	
		{:id => 0, :value => 'draft'},	  		  #черновики
		{:id => 1, :value => 'normal'},			  #в рабочем состоянии
		{:id => 2, :value => 'to_delete'} 		  #в очереди на удаление
		#{:id => 3, :value => 'on_deleted_entity'} #если прикреплено к сущности со статусом to_delete
	]
  end
  
  def status
	stat = 'draft'
	statuses.each do |s|
		stat = s[:value] if status_id == s[:id]
	end
	return stat
  end
  def v_statuses #статус отображения
  [
	{:id => 1, :value => 'visible', :img => '/', :ru => 'Видна всех'},
	{:id => 2, :value => 'hidden', :img => '/', :ru => 'Видна только авторизованным пользователям'}
	]
  end
  
  def v_status #статус отображения
	stat = 'visible'
	v_statuses.each do |s|
		stat = s[:value] if s[:id] == self.visibility_status_id
	end
	return stat
  end
  
  def set_as_delete #помечает сообщение как удалённое
	  self.update_attribute(:status_id, 2)
  end
  
  def set_as_visible #Делает видимым
	  self.update_attribute(:status_id, 1)
  end 
  
  #статусы end... 
#функции связанные с отображением сообщений
  def message_updater #определяет кто последний обновлял сообщение
	updater_text = ""
	if updater_id != nil
    if user_id == updater_id && self.created_at + 1.hour < self.updated_at
		  	updater_text = "<p class = 'istring_m medium-opacity'>Сообщение обновлено Автором #{updated_at.to_s(:ru_datetime)}</p>"
    elsif user_id != updater_id 
      	updater_text = "<p class = 'istring_m medium-opacity'>Сообщение обновлено Администратором #{updated_at.to_s(:ru_datetime)}</p>"
    end
	end
	return updater_text
  end

  def list_photos
	"Измени на message_list_photos(msg) функцию отрисовки и удали list_photos в message.rb"
  end 
  
  def visible_photos #только видимые фотографии
	  photos.where(id: entity_photos.select(:photo_id).where(visibility_status_id: [1, nil]))
  end
#функции связанные с отображением сообщений end


#Поиск потомков сообщения  
  def get_tread #Поиск всех сообщений в иерархии
	msgs_array = self.messages #Начальный массив сообщений
	if msgs_array != []
		msgs_to_loop = msgs_array #Массив для обработки в цикле
		begin 
			msgs_temp = [] #временный массив для сообщений
			msgs_to_loop.each do |msg|
				msgs_temp += msg.messages if msg.messages != []
			end
			msgs_array += msgs_temp if msgs_temp !=[] #Обновляем возвращаемый массив
			msgs_to_loop = msgs_temp #Обновляем массив для цикла полученным
		end until(msgs_to_loop == [])
	end
	return msgs_array
  end
  
  def get_visible_tread
	msgs = self.get_tread
	v_msgs = Message.where(id: (msgs), status_id: 1)
	return v_msgs
  end
  
  def tread_has_another_user_message? #проверка на наличии в ответах на сообщение - сообщений не автора
	msgs = self.get_visible_tread
	if msgs != []
		msgs.each do |msg|
			return true if msg.user_id != self.user_id
		end
	end
	return false
  end
  def makeThemeFromMessage(new_theme_name, new_topic)
		new_theme = Theme.new(
							:name => new_theme_name, 
							:topic_id => new_topic.id, 
							:content => self.content, 
							:status_id => self.theme.status_id, 
							:user_id => self.user.id,
							:created_at => self.created_at,
							:updated_at => self.updated_at,
							:visibility_status_id => self.theme.visibility_status_id
							)
	new_theme.save(:validate => false)				
	if self.get_tread != []
		self.get_tread.each do |msg|
			msg.update_attributes(:theme_id => new_theme.id, :topic_id => new_theme.topic_id)
		end	
	end	
	if self.entity_photos != []
		self.entity_photos.each do |ph|
			 new_theme.entity_photos.create(photo_id: ph.photo_id, visibility_status_id: ph.visibility_status_id)
		end
	end
	if self.attachment_files != []
		attachment_files.each do |af|
			af.update_attributes(:message_id => nil, :theme_id => new_theme.id)
		end
	end
	self.destroy
	return new_theme
  end  
#Поиск потомков сообщения end
 

  def bind_photos_to_theme(theme) #Привязывает фото к теме и отвязывает от сообщения
    phs = Photo.where(message_id: self.id)
    if phs != []
  		phs.each do |ph|
  			ph.update_attributes(:theme_id => theme.id, :message_id => nil)
  			#theme.check_photo_in_content(ph)
  		end
  	end
  end
  
  def bind_attachments_to_theme(theme) #Привязывает вложения к теме и отвязывает от сообщения
	if attachment_files != []
		attachment_files.each do |af|
			af.update_attributes(:theme_id => theme.id, :message_id => nil)
		end
	end
  end
#превращение сообщения в тему  
  def bind_child_messages_to_theme(theme) #Переносит в тему не созданную из first_message
	if self.get_tread != []
		self.get_tread.each do |msg|
			msg.update_attributes(:theme_id => theme.id, :topic_id => theme.topic_id, :visibility_status_id => theme.visibility_status_id)
		end	
	end	
  end


  def bind_child_messages_to_theme_from_first_message(theme) #Переносит в тему созданную из first_message
	msgs = Message.where(:first_message_id => self.id)
	if msgs != []
		msgs.each do |msg|
			msg.update_attributes(:theme_id => theme.id, :first_message_id => nil, :topic_id => theme.topic_id, :status_id => 1)
		end
	end
  end
#превращение сообщения в тему end
#сомнительные функции

  
  def make_first_message_id #непонятная функция
	if self.message_id != nil
		message_to = Message.find_by(id: self.message_id)
		if message_to != nil
			self.first_message_id = message_to.first_message_id if message_to.first_message_id != nil
			self.first_message_id = message_to.id if message_to.first_message_id == nil
		else
			self.message_id = nil
		end
	end
  end
#сомнительные функции end  
  
  
  
#  def assign_entities_from_draft(draft) #привязка сущностей с черновика
#	if draft.photos != []
#		draft.photos.each do |ph|
#			ph.update_attributes(:message_id => self.id)
#			check_photo_in_content(ph)
#		end
#	end
#	self.update_attributes(:status_id => 1)
 # end
  
  def remove_attachments_and_photos #полное удаление 
	if self.photos != []
		self.photos.each do |ph|
			ph.destroy
		end
	end
	if self.attachment_files != []
		self.attachment_files.each do |af|
			af.destroy
		end
	end
  end
  
  def clean #обязательно должна вызываться при обновлении сообщений
	self.update_attributes(
							:topic_id => nil,
							:theme_id => nil,
							:message_id => nil,
							:photo_id => nil,
							:photo_album_id => nil,
							:video_id => nil,
							:content => ''
						   )
	self.remove_attachments_and_photos						
  end
  
  def getIds(str)
  	ids = []
  	id = ''
  	str.chars do |ch|
  		if ch != '[' and ch != ']'
  			id += ch
  		elsif ch == ']'
  			ids[ids.length] = id
  			id = ''
  		end
  	end
  	return ids
  end
end

# to_do list
# 1. Изменение сообщения. (тест)
# 2. Перенос сообщения. (пробежаться)
# 3. Удаление сообщения. (пробежаться и понять чего я хочу)
# 4. Вложения. (добавить)


