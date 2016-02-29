class Theme < ActiveRecord::Base
  #to_do!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  #после добавления индивидуальной рассылки по теме сделать:
  #---------при объединении тем рассылку от сливаемой темы привязять к целовой теме
  #---------при полном удалении темы удалять и рассылки
  #после добавления лайков:
  #---------при объединении тем все лайки от сливаемой темы привязывать к создаваемому сообщению
  #---------при полном удалении темы удалять и лайки
  
 attr_accessor :deleted_photos, :make_event_flag, :event_post_date
 attr_accessible :last_message_date, :name, :status_id, :topic_id, :user_id, :content, :photos, :uploaded_photos, :updater_id, :attachment_files, :created_at, :updated_at, :visibility_status_id, :deleted_photos, :vote_id, :theme_type_id, :make_event_flag, :event_post_date, :equipment_part_id
 
  has_many :messages, -> { where(status_id: 1).order("created_at ASC")}, :dependent  => :destroy
  belongs_to :user
  belongs_to :topic
  belongs_to :vote
  has_many :attachment_files, :dependent  => :destroy
  
  has_many :entity_photos, :as => :p_entity, :dependent => :destroy #has_many :photos, :dependent  => :delete_all
  has_many :photos, through: :entity_photos 
    
  has_many :theme_notifications, :dependent => :delete_all
  has_one :entity_view, :as => :v_entity, :dependent => :delete
  has_one :event, dependent: :destroy
  has_one :article
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
	#start_quote
	#end_quote
    simple_format
  end
  after_save :check_photos_in_content 
  before_destroy :delete_steps
  #after_create :last_msg_upd_after_create
  after_validation :check_event_flag
  
  validate :deleted_photos_check, :on => :update

  def deleted_photos_check
    if self.deleted_photos != nil and self.deleted_photos != ''
      arr = self.deleted_photos.getIdsArray
      if arr.length > 0
        ePhs = self.entity_photos.where(id: arr)
        if ePhs != []
          ePhs.each do |ePh|
            ePh.destroy
          end
        end
      end
    end
  end
  
  def check_event_flag
    
    if self.event.nil? && make_event_flag == 'true' && visibility_status_id == 1  && (self.status_id == 1 || self.status_id == 3)
      #dAreaId = (self.event_display_area_id.blank?)? 2 : self.event_display_area_id
      pDate = event_post_date.blank? ? self.updated_at : event_post_date
      self.build_event(post_date: self.updated_at, content: self.content, status_id: 2, title: self.name)
    elsif !self.event.nil? 
      status = (self.status_id != 1 && self.status_id != 3)? 1 : 2
      pDate = event_post_date.blank? ? self.event.post_date : event_post_date
      self.event.update_attributes(title: self.name, content: self.content, status_id: status, :post_date => pDate) 
    end
  end
  #searchable do
  #    text :name, :content
  #    text :messages do
  #      messages.map { |message| message.content }
  #    end
 #     
 #     integer :user_id
 #    integer :topic_id
 #     integer :status_id
 #     integer :visibility_status_id
 #     time    :created_at
 #     time    :updated_at
 #
 # end
  
  
  def uploaded_photos=(attrs)
	  attrs.each do |photo|
       ph = Photo.create(:link => attr, :user_id => self.user_id)
       self.entity_photos.create(photo_id: ph.id)
    end
  end

  def attachment_files=(attrs)
	attrs.each {|attr| self.attachment_files.build(:link => attr, :user_id => self.user_id, :directory => "themes/#{self.name}")}
  end
  
  def last_message #находим последнее сообщение темы
	  self.messages.last
  end
#Валидация--------------------------------------------------------------------------
 validates :name, :presence => {:message => "Поле 'Заголовок темы' не должно быть пустым"},
				   :length => { :maximum => 100, :message => "Заголовок темы должен быть длиннее 100 символов"},
				   #:on => :create
				   :if => :is_not_draft?
 validates :content, :presence => {:message => "Поле \"Содержимое\" не должно быть пустым"},
				     :length => { :maximum => 15000, :message => "Содержимое темы не должно быть длиннее 15000 символов"},
				     #:on => :create
				     :if => :has_attachments_and_photos?
				   
  validate :uniqless_name_check
  validate :check_user_permission, :on => :create
  validate :check_visibility_status, :on => :create
  
  def is_not_draft?
	return false if self.status_id == 0
	return true if self.status_id != 0
  end
  def has_attachments_and_photos?	
	if (self.photos == [] || self.photos == nil) and (self.attachment_files == [] || self.attachment_files == nil)and status_id != 0
		return true
	else
		return true if self.content.strip.length > 0
		return false if self.content.strip.length == 0
	end
  end
  
  def uniqless_name_check
	if self.name != nil and self.name != ''
		th = Theme.find_by(name: self.name, topic_id: self.topic_id, status_id: 1)
		errors.add(:content, "Тема с таким названием уже существует в данном разделе") if self != th and th != nil

	end
	
  end
  
  def check_user_permission
	if !self.user.nil?
		if (self.user.user_group_id == nil || self.user.user_group_id == 7 || self.user.user_group_id == 4) || (self.topic_id != 6 and self.user.user_group_id == 5) 
			errors.add(:user_id, "У Вас недостаточно прав для создания новой темы.")
		end
	else
		errors.add(:user_id, "У Вас недостаточно прав для создания новой темы.")
	end
  end
  
  def check_visibility_status
    self.visibility_status_id = 1 if self.visibility_status_id == nil
  end
#Валидация end----------------------------------------------------------------------
#статусы...  
  def statuses 
	[	
		{:id => 0, :value => 'draft', :img => 'unlock', :ru => 'Черновик'},	  #черновики
		#отображенные
		{:id => 1, :value => 'open', :img => 'unlock', :ru => 'Открыта'},     #отображенные
		{:id => 2, :value => 'delete', :img => 'unlock', :ru => 'Удалена'},#в очереди на удаление
		{:id => 3, :value => 'closed', :img => 'lock', :ru => 'Закрыта'},    #Тема закрыта
		{:id => 4, :value => 'closed_to_delete', :img => 'lock', :ru => 'Закрыта и удалена'}    #Тема закрыта    #Тема закрыта и удалена
		#отображенные end
	]
  end
  def status(loc = :value)
	statuses.each do |s|
		return s[loc] if s[:id] == self.status_id
	end
  end
  def v_statuses #статус отображения
	[
	{:id => 1, :value => 'visible', :img => 'none', :ru => 'Для всех'},
	{:id => 2, :value => 'hidden', :img => 'shield', :ru => 'Только для авторизванных пользователей'}
	]
  end
  def users_who_can_see
    [0,1,2,3,4,6] if self.v_status == 'visible'
    [0,1,2,3,6] if self.v_status == 'hidden'
  end
  def v_status #статус отображения
	stat = 'visible'
	v_statuses.each do |s|
		stat = s[:value] if s[:id] == self.visibility_status_id
	end
	return stat
  end
  def statusHash
	statuses.each do |s|
		return s if s[:id] == self.status_id
	end
  end
  def vStatusHash
	v_statuses.each do |s|
		return s if s[:id] == self.visibility_status_id
	end
  end
#статусы end...  
#  def visible_messages
#    self.messages
#  end
  
  def merge(new_topic=nil, new_theme=nil) #объединение тем 
  	if !new_theme.nil?
    message_in_target_theme = Message.new(
  											  :user_id => self.user_id, 
  												:updater_id => self.updater_id, 
  												:content => self.content, 
  												:theme_id => new_theme.id, 
  												:topic_id => new_topic.id, 
  												:status_id => 1, 
  												:created_at => self.created_at, 
  												:updated_at => self.updated_at
  											) #1. Создаём в целевой теме сообщение с содержимым сливаемой темы
  	message_in_target_theme.save(:validate => false)
  	if self.entity_photos != []
  		self.entity_photos.each do |ph|
         message_in_target_theme.entity_photos.create(photo_id: ph.photo_id, visibility_status_id: ph.visibility_status_id)
  		end
  	end
  	if self.attachment_files != []
  		self.attachment_files.each do |af|
  			af.update_attributes(:message_id => message_in_target_theme.id, :theme_id => nil) #4. Переносим вложения в message_in_target_theme
  		end
  	end 
  	if self.messages != []
  		self.messages.each do |msg|
  			mes_id = message_in_target_theme.id if msg.message_id == nil #сообщение как ответ на message_in_target_theme если оно не является ответом на какое-либо сообщение
  			mes_id = msg.message_id if msg.message_id != nil #не изменяем если является
  			msg.update_attributes(
  									:theme_id => new_theme.id, 
  									:topic_id => new_topic.id, 
  									:message_id => mes_id
  								  )# Переносим в целевую тему все сообщения из текущей в :base_theme_id записываем id сливаемой (базовой) темы (При условии сохранения сливаемой темы)
  			#msg.updatePhotosStatusesAfterSave
  		end
  	end
  	old_theme_notifications = self.theme_notifications
  	if old_theme_notifications != []
  		old_theme_notifications.each do |ntf|
        usr_id = ntf.user_id
  			newNtf = ThemeNotification.find_by(theme_id: new_theme.id, user_id: usr_id)
        newNtf = ThemeNotification.create(theme_id: new_theme.id, user_id: usr_id) if newNtf == nil
  		end
  	end
	
  	self.destroy
    return new_theme
  else
    self.update_attribute(:topic_id, new_topic.id)
    msgs = Message.where(theme_id: self.id)
    msgs.each {|m| m.update_attribute(:topic_id, new_topic.id)}
    return self
  end
   #Объединение тем
    #1. Создаём в целевой теме сообщение с содержимым сливаемой темы
    #2. Переносим в целевую тему все сообщения из текущей в :base_theme_id записываем id сливаемой (базовой) темы
    #3. Переносим фотографии в message_in_target_theme
    #4. Переносим вложения в message_in_target_theme
    #5. Обновление текущей темы
    #6. Создание информационного сообщения
  end
  
  def delete_merged_theme
	self.unbind_photos
	self.attachment_files
  end

#статусы end...
  def last_msg_upd
	  date = self.last_message.created_at if self.last_message != nil
	  date = self.created_at if self.last_message_date == nil
	  self.update_attribute(:last_message_date, self.created_at) if self.last_message_date != date
  end
 
#управление содержимым  
  def check_photos_in_content 
	if self.photos != [] and self.photos != nil
		self.photos.each do |ph|
			self.check_photo_in_content(ph)
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

  def updater_string #Выводит информацию о последнем обновлении темы
	updater_text = ""
	if updater_id != nil && self.created_at + 5.hours < self.updated_at 
		updater = "Автором" if user_id == updater_id
		updater = "Администратором" if user_id != updater_id
		updater_text = "<p class = 'istring_m norm medium-opacity' >Тема обновлена #{updater} #{updated_at.to_s(:ru_datetime)}</p>"
	end
	return updater_text
  end
#управление содержимым end  
  def not_read_messages(user = User.find(1), step = nil)
    if self.messages.size > 0
      last_step_in_theme = (step.nil?)? Step.find_by(part_id: 9, page_id: 1, entity_id: self.id, user_id: user.id) : step
      return (last_step_in_theme.nil?)? [] : self.messages.where("created_at > :step_time", {step_time: last_step_in_theme.visit_time}).order('created_at ASC')
    else
      return []
    end
  end
  def theme_read_info(user) #информация прочитанности тем и ссылка
    info = ""
    link = "/themes/#{self.id}"
    if !user.nil?
      step = Step.find_by(part_id: 9, page_id: 1, entity_id: self.id, user_id: user.id)
      if step.nil?
        info = '<span class = "not-read-theme" title = "не прочитано">н/п</span>'
      elsif !self.messages.blank?
        nr_messages = self.not_read_messages(user, step)
        if nr_messages.size < 100 && nr_messages.size != 0
          info = "<span class = 'not-read-messages'>+#{nr_messages.size}</span>"
          link = "/themes/#{self.id}#msg_#{nr_messages.last.id}"
        elsif nr_messages.size > 99
          info = '<span class = "not-read-messages">>99</span>'
          link = "/themes/#{self.id}#msg_#{nr_messages.last.id}"
        else
          link = "/themes/#{self.id}#msg_#{self.last_message.id}"
        end
      end
    end
    return {info: info, link: link, last_message: self.last_message}
  end
  def clean
		self.update_attributes(:content => '',:name => '')
		self.remove_attachments_and_photos
  end
  
  def unbind_photos
  	if self.photos != []
  		 self.photos.each do |pht|
  		   pht.update_attribute(:theme_id, nil)
  		 end
  	end
  end
  
	def unbind_attachment_files
		if self.attachment_files != []
			 self.attachment_files.each do |af|
				af.update_attribute(:theme_id, nil)
			end
		end
	end
	
	def visible_photos #Видимые фотографии
    photos.where(id: entity_photos.select(:photo_id).where(visibility_status_id: [1, nil]))
	end
#управление статусами	
	def do_close(current_user) #Закрываем тему
		self.update_attribute(:status_id, 3)
		self.messages.create(:topic_id => topic_id, :content => closeThemeMessage, :user_id => current_user.id, :status_id => 1)
	end
	def do_open(current_user) #Открываем тему
		self.update_attribute(:status_id, 1)
		self.messages.create(:topic_id => topic_id, :content => openThemeMessage, :user_id => current_user.id, :status_id => 1)
	end

	def set_as_visible #перевод в статус visible тему с текущим статусом hidden
		self.update_attribute(:visibility_status_id, 1) if self.visibility_status_id != 1
	end 
	def set_as_hidden #перевод в статус visible тему с текущим статусом hidden
		self.update_attribute(:visibility_status_id, 2) if self.visibility_status_id != 2
	end
  
#счётчик просмотров
def views
  (self.entity_view == nil)? 0 : self.entity_view.counter 
end
#счётчик просмотров end

def all_photos_in_theme
  phs = self.photos
  if self.messages.size > 0
    self.messages.each do |m|
      if m.photos.size > 0
        phs += m.photos
      end
    end
  end
  return phs
end


def update_article_draft(article)
  text = self.content
  phs = (self.photos != [])? self.photos : []
  msgs = self.messages
  article.clean
  if msgs != []
    msgs.each do |m|
      text += "\n #User#{m.user.id}[#{m.user.name}] \n #{m.content} \n" if m.content.strip != ''
      phs += m.photos if m.photos != []
    end
  end
  article.update_attributes(content: text, name: self.name)
  if phs != []
    phs.each do |p|
      article.entity_photos.create(photo_id: p.id, visibility_status_id: 1)
    end
  end
  return article
end
def update_album_draft(album)
  text = self.content.escapeBbCode
  phs = self.all_photos_in_theme
  phs_to_del = album.photos - phs
  phs_to_add = phs - (album.photos - phs_to_del)
  msgs = self.messages
  if msgs != []
    msgs.each do |m|
      text += "\n #{m.user.name} \n #{m.content.escapeBbCode} \n" if m.content.strip != ''
    end
  end
  album.update_attributes(description: text, name: self.name)
  if phs_to_del != []
    del_entity_photos = album.entity_photos.where(photo_id: phs_to_del)
    del_entity_photos.each do |p|
      p.destroy
    end
  end
  if phs_to_add != []
    phs_to_add.each do |p|
      album.entity_photos.create(photo_id: p.id, visibility_status_id: 1)
    end
  end
  return album
end

def steps
  Step.where(part_id: 9, page_id: 1, entity_id: self.id)
end

def delete_steps
  self.steps.delete_all
end




def equipment_part
  if self.equipment_part_id.blank? 
    return 'Прочее' 
  else
    equipment_parts.each do |p|
      return p[:name] if p.id == self.equipment_part_id
    end
    return 'Прочее' 
  end
end

def self.equipment_part_by_id(params)
   all = Theme.equipment_parts('id').push(nil)
  if !params.nil?
    params = params.to_i
    all = Theme.equipment_parts('id').push(nil)
    if params > 0 && params < Theme.equipment_parts.size + 1
       Theme.equipment_parts.each do |p|
         return {id: p[:id], name: p[:name], equipment_part_id: p[:id], status_id: 1 } if p[:id] == params
       end
    elsif params == 100500 #Архив
      return {id: 100500, name: 'Неактуальные', status_id: 3, equipment_part_id: all}
    elsif params == 100 #Мои
      return {id: 100, name: 'Мои', status_id: [1,3], equipment_part_id: all}
    elsif params == 500 #Разное
      return {id: 500, name: 'Разное', status_id: 1, equipment_part_id: nil}
    end
  end
  return {id: nil, name: 'Все актуальные', status_id: 1, equipment_part_id: all}
end
def self.equipment_parts(s = 'all')
  parts = [
            {id: 1, name: 'Парапланы'},
            {id: 2, name: 'Подвесные системы'},
            {id: 3, name: 'Запасные парашюты'},
            {id: 4, name: 'Парамоторы и аксессуары'},
            {id: 5, name: 'Приборы'},
            {id: 6, name: 'Кайтинг'}
          ]
  return parts if s != 'id' && s != 'name'
  return parts.map{ |i| i[:id] } if s == 'id'
  return parts.map{ |i| i[:name] } if s == 'name'
end
private
	def openThemeMessage
		'Тема возобновлена'
	end
	def closeThemeMessage
		'Тема закрыта'
	end
  
end
