#12.02.2014 - Создание
#			- Добавлено логирование пользователя
#			- Добавлен массив user_groups
#			- Добавлен блок antibot_images
#			- Добавлен блок Uploaders
#14.02.2014 - Добавлена функция alter_avatar и alter_avatar_thumb
#15.02.2014 - Добавлен блок Mailers
#21.02.2014 - Добавлены фотоальбомы 


require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password, :old_password, :current_password
  attr_accessible :password, :avatar, :cell_phone, :email, :email_status, :encrypted_password, :full_name, :inform, :name, :photo, :salt, :skype, :web_site, :user_group_id, :password_confirmation, :avatar_cache, :photo_cache, :old_password, :current_password, :guest_token, :bunned_to, :bunned_why, :prev_group_id, :role, :order_number
  require 'will_paginate'
  
#--------Old_messages---------------------------------------------
has_many :old_messages
#--------Old_messages end-----------------------------------------
#--------Videos---------------------------------------------
has_many :videos, :dependent  => :destroy
#--------Videos end-----------------------------------------
  
#--------PhotoAlbums---------------------------------------------
has_many :photo_albums, :dependent  => :destroy
#--------PhotoAlbums end-----------------------------------------

#--------PhotoAlbums---------------------------------------------
has_many :photos, :dependent  => :destroy
#--------PhotoAlbums end-----------------------------------------

#--------Themes--------------------------------------------------
has_many :themes, :dependent  => :destroy
has_many :theme_steps, dependent: :delete_all
#--------Themes end----------------------------------------------
has_many :articles, :dependent => :destroy
#--------video_like_marks--------------------------------------------------
has_many :like_marks, :dependent  => :delete_all
#--------video_like_marks end----------------------------------------------
#--------Messages--------------------------------------------------
has_many :messages, -> {where(status_id:1)}, :dependent  => :destroy
#--------Messages end----------------------------------------------
#--------steps-----------------------------------------------------
has_many :steps, :dependent  => :delete_all
#--------steps end-------------------------------------------------
#conversations 
has_many :conversation_users
has_many :conversation_user_messages
has_many :conversations, through: :conversation_users

def conversation_messages(conversation, last_message_id=nil)
  return [] if conversation.nil?
  return self.conversation_user_messages.where(conversation_message_id: conversation.conversation_messages.select(:id).where("id>#{last_message_id}")).order("created_at ASC") if !last_message_id.nil?
  return self.conversation_user_messages.where(conversation_message_id: conversation.conversation_messages.select(:id)).order("created_at ASC") if last_message_id.nil?
end
#conversations end
#--------topic_notifications-----------------------------------------------------
has_many :topic_notifications
def getTopicNotification(topic_id)
	tNtf = nil
	if self.topic_notifications != []
		tNtf = self.topic_notifications.where(:topic_id => topic_id).first 
	end
	return tNtf
end
#--------topic_notifications end-------------------------------------------------
#--------theme_notifications-----------------------------------------------------
has_many :theme_notifications, dependent: :delete_all
def getThemeNotification(theme_id)
	tNtf = nil
	if self.theme_notifications != []
		tNtf = self.theme_notifications.where(:theme_id => theme_id).first 
	end
	return tNtf
end
#--------theme_notifications end-------------------------------------------------
#--------Mailers-------------------------------------------------
has_one :mailer, :dependent  => :delete
	def has_mailer?
		return mailer if mailer != nil and email == mailer.email
		return nil if mailer == nil or email != mailer.email
	end
	def make_mailer
		if !has_mailer?
			self.create_mailer(:album => 'no', :video => 'no', :message => 'no', :article => 'no', :photo_comment => 'no', :video_comment => 'no', :email => email)
		end
	end
#--------Mailers end---------------------------------------------
#UserDrafts------------------------------------------------------
#def themeMessageDraft #Черновик для сообщений в темах
#	msg_draft = Message.find_by_user_id_and_topic_id_and_theme_id_and_status_id(self.id, 0, 0, 0)
#	msg_draft = self.messages.create(:theme_id => 0, :topic_id => 0, :status_id => 0) if msg_draft == nil
#	return msg_draft
#end
#def photoCommentDraft #Черновик для комментариев к фото
#end
#def videoCommentDraft #Черновик для комментариев к видео
#end
#def photoAlbumDraft #Черновик для альбома
#end
#UserDrafts end--------------------------------------------------
#--------Uploaders-----------------------------------------------
mount_uploader :avatar, UserAvatarUploader
mount_uploader :photo, UserPhotoUploader
#--------Uploaders end-------------------------------------------
  def visible_name(user_group)
	if !full_name? || user_group == 'guest' || user_group == 'bunned' || user_group == 'new_user' 
		return name
	else
		return full_name
	end
  end
  def alter_avatar
	user_avatar = '/files/undefined.png'
		if avatar?
			user_avatar = avatar
		end
	return user_avatar
  end
  def alter_avatar_square
	user_avatar = '/files/undefined.png'
		if avatar?
			user_avatar = avatar.sq_thumb
		end
	return user_avatar
  end
  def widthAndHeight(link)
	p = {:width=>0,:height=>0}
    image = Magick::Image.read(Rails.root.join("public#{link}")).first
    p[:width] = image.columns
	p[:height] = image.rows
	return p
  end
  def alter_avatar_thumb
	user_avatar = '/files/undefined_thumb.png'
		if avatar?
			user_avatar = avatar.thumb
		end
	return user_avatar
  end
  def empty_card
	"
		<table style = 'height: 30px;'>
					<tr>
						<td valign = 'middle' align = 'left' style = 'width: 30px;'><img class = 'mini_link' src = '#{alter_avatar_thumb}'></td>
						<td valign = 'middle' align = 'left'><a class = 'b_link' href = '/users/#{id}' target = '_blank' >#{name}</a></td>
					</tr>
		</table>
	"
  end
  def role_card(user_role)
	"
		<table style = 'height: 30px;'>
					<tr>
						<td valign = 'middle' align = 'left'><p class = 'istring'>#{user_role}</p></td>
						<td valign = 'middle' align = 'left' style = 'width: 30px;'><img class = 'mini_link' src = '#{alter_avatar_thumb}'></td>
						<td valign = 'middle' align = 'left'><a class = 'b_link' href = '/users/#{id}' target = '_blank' >#{name}</a></td>
					</tr>
		</table>
	"
  end
  def email_with_status
    msg = "Не подтверждён"
    msg = "Подтверждён" if self.email_status == "Активен" 
    return "#{self.email} (#{msg})"
  end
  
  def user_groups #в старой версии была отдельная таблица в базе
		[
			{:value => 7, :name => 'Удалённый', en_name: 'deleted'},#deleted
			{:value => 6, :name => (self.role.blank?)? "Лица клуба" : self.role, en_name: 'manager'},#manager
			{:value => 2, :name => 'Клубный пилот', en_name: 'club_pilot'},	 #club_pilot
			{:value => 3, :name => 'Друг клуба', en_name: 'friend'},		 #friend
			{:value => 5, :name => 'Вновь прибывший', en_name: 'new_user'},   #new_user
			{:value => 4, :name => 'Бан лист', en_name: 'bunned'},		 #bunned
			{:value => 1, :name => 'Site Admin', en_name: 'admin'},		 #admin
			{:value => 0, :name => 'Super Admin', en_name: 'super_admin'}    #super_admin
		]
  end
  
  def self.n_users
    User.where('user_group_id in (:user_gr_id) and created_at > :cr_at_offset ', {user_gr_id: [2,3,0,1,6], cr_at_offset: Time.now - 10.days}).select(:name, :id)
  end
  #tracked_themes
  def tracked_themes(flag)
    v_status = (flag)? 1 : [1,2]
    return Theme.where(id: theme_notifications.ids, status_id: [1, 3], :visibility_status_id => v_status).order('last_message_date ASC')
  end
  #tracked_themes end
  
  def not_readed_themes_ids(topic, flag=false) #use for select not visited themes in topic show
    v_status = (flag)? 1 : [1,2]
    #topic_themes = topic.themes.where(visibility_status_id: v_status).includes(:theme_steps, :messages).order("last_message_date DESC")
    not_visited_themes_ids = topic.themes.where.not(id: theme_steps.pluck(:theme_id)).where(visibility_status_id: v_status).ids
    visited_themes = topic.themes.includes(:theme_steps).where("theme_steps.user_id" => self.id)
    no_read_last_message_ids = []
    visited_themes.each {|th| no_read_last_message_ids << th.id if th.last_message_date > th.theme_steps.first.last_visit_date}
    return no_read_last_message_ids << not_visited_themes_ids
  end
  
  def self.club_pilots
	  User.where(user_group_id: [0,1,2,6])
  end
  
  def self.club_friends
	  User.where(user_group_id: 3)
  end
  
  def self.new_users
    User.where(user_group_id: 5)
  end
  
  def self.bunned
    User.where(user_group_id: 4)
  end

  def group
    user_group[:en_name]
  end
  def group_name
	  (self.role.blank?)? user_group[:name] : self.role
  end
  
  def group_id
	user_group[:value]
  end
  
  def user_group
    return {:value => 0, :name => 'Super Admin', en_name: 'super_admin'} if self.id == 1 
	  user_groups.each do |group|
	    return group if user_group_id == group[:value]
	  end
  end
  def check_bun_status
    time = Time.now
    self.update_attributes(user_group_id: self.prev_group_id, bunned_why: '') if time > self.bunned_to
  end
  def return_from_bun_list
    self.update_attributes(user_group_id: self.prev_group_id)
  end
  #управление черновиками тем и сообщений
  def theme_message_draft(theme) #выдает, а если необходимо создает черновик сообщения
	  draft = Message.find_by(user_id: self.id, status_id: 0, theme_id: theme.id)
	  draft = self.messages.create(:status_id => 0, theme_id: theme.id, content: "") if draft == nil
    if draft.content == nil
      draft.update_attribute(:content, "")
    end 
	  return draft
  end
  def album_message_draft(album)
    draft = Message.find_by(user_id: self.id, status_id: 0, photo_album_id: !nil)
    if draft != nil
      draft.clean
      draft.update_attribute(:photo_id, album.id)
    end
	  draft = self.messages.create(:status_id => 0, photo_album_id: album.id) if draft == nil 
	  return draft
  end
  def photo_comment_draft(photo)
    draft = Message.find_by(user_id: self.id, status_id: 0, photo_id: !nil)
    if draft != nil
      draft.clean
      draft.update_attribute(:photo_id, photo.id)
    end
	  draft = self.messages.create(:status_id => 0, photo_id: photo.id) if draft == nil 
	  return draft
  end
  def video_comment_draft(video)
    draft = Message.find_by(user_id: self.id, status_id: 0, video_id: !nil)
    if draft != nil
       if draft.video_id != video.id
         draft.clean
         draft.update_attribute(:video_id, video.id)
       end
    end
	  draft = self.messages.create(:status_id => 0, video_id: video.id) if draft == nil 
	  return draft
  end
  def theme_draft(topic) #выдает, а если необходимо создает черновик темы
	draft = Theme.find_by(user_id: self.id, status_id: 0, topic_id: topic.id)
	if draft == nil
		draft = Theme.new(:user_id => self.id, :status_id => 0, topic_id: topic.id, content: '')# if draft == nil 
		draft.save(:validate => false) #отключаем проверку длины названия темы
	end
	return draft
  end
  def article_draft(t=1) 
  	draft = Article.find_by(user_id: self.id, status_id: 0, article_type_id: t)
  	if draft == nil
  		draft = Article.new(:user_id => self.id, :status_id => 0, article_type_id: t, content: '', theme_id: nil)# if draft == nil 
  		draft.save(:validate => false) #отключаем проверку длины названия темы
  	end
	  return draft
  end
  def album_draft 
  	draft = PhotoAlbum.find_by(user_id: self.id, status_id: 0)
  	if draft == nil
  		draft = PhotoAlbum.new(:user_id => self.id, :status_id => 0, :theme_id => nil)# if draft == nil 
  		draft.save(:validate => false) #отключаем проверку длины названия темы
  	end
	  return draft
  end
  def event_draft 
  	draft = Event.find_by(status_id: 0)
  	if draft == nil
  		draft = Event.new(:status_id => 0, content: '', title: '')# if draft == nil 
  		draft.save(:validate => false) #отключаем проверку
    else
      if draft.updated_at + 3.day < Time.now 
        draft.clean 
        draft.update_attribute(:updated_at, Time.now)
      end
    end
  	return draft
  end
  #управление черновиками тем и сообщений end
  
  #Валидация пользователя
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :password, :presence => {:message => "Введите пароль длинной 6-40 символов"},
					   :confirmation => {:message => "Введённый пароль не совпадает с подтверждением"},
					   :length => {:within => 6..40, :message => "Длина пароля должна быть не менее 6 и не более 40 знаков"},
					   :on => :create

  validates :name, :presence => {:message => "Поле 'Ник' не должно быть пустым"},
				   :length => { :maximum => 32, :message => "Ник не может быть длиннее 32-х знаков"},
				   :uniqueness => {:message => "Ник занят другим пользователем"},
				   :on => :create

  validates :email,  :presence => {:message => "Поле 'E-mail' не должно быть пустым"},
				    :format => {:with => email_regex, :message => "Поле 'E-mail' не соответсвует формату адреса электронной почты 'user@mail-provider.ru'"},
				    :uniqueness => {:case_sensitive => false, :message => "E-mail уже используется"},
		  			:allow_nil => true
  
  validate :old_password_exists, :on => :update
  validate :current_password_check, :on => :update
  
  def current_password_check
	if current_password != nil
		errors.add(:current_password, "Необходимо ввести свой текущий пароль") if  current_password.strip == ''
		errors.add(:current_password, "Пароль введён неверно") if current_password.strip != '' and encrypted_password != encrypt(current_password)
	end
  end
  def old_password_exists
	if old_password != nil
		errors.add(:old_password, "Необходимо ввести свой старый пароль") if old_password.strip == ''
		errors.add(:old_password, "Старый пароль введён неверно") if old_password.strip != '' and encrypted_password != encrypt(old_password) 
	end
	if password != nil
		errors.add(:password, "Введите новый пароль длинной 6-40 символов") if password.strip == '' 
		errors.add(:password, "Введённый пароль не совпадает с подтверждением") if password.strip != password_confirmation.strip 
		errors.add(:password, "Длина пароля должна быть не менее 6 и не более 40 знаков") if password.strip.length < 6 or password.strip.length > 40 and password.strip != ''
	end
  end
  #antibot_images----------------------------------------------------------------
  def antibot_images
	[
		{:name => '2G3uup', :value => 'adN7wJ'},
		{:name => 'hcvu907', :value => 'km1F9g'},
		{:name => 'Krfereg', :value => 'cR1wQ'},
		{:name => 'xYp89n', :value => 'tU560m'}
	]
  end
  
  def image_valid?(img_val, img_name)
	img_val == get_antibot_image_by_name(img_name)
  end
  
  def get_default_antibot_image
	array = antibot_images.shuffle
	return array.first
  end
  
  def get_antibot_image_by_name(img_name)
	value = ''
		antibot_images.each do |image|
			value = image[:value] if img_name == image[:name]
		end
	return value
  end
#antibot_images end------------------------------------------------------------
  before_save :encrypt_password
  after_save :make_mailer

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

    def self.authenticate(name, submitted_password)
    user = nil
    users = User.all
    name = name.mb_chars.downcase
    users.each do |u|
     if u.name.mb_chars.downcase == name
       user = u 
       break
     elsif name == u.email.mb_chars.downcase and u.email_status == 'Активен'
       user = u 
       break
     end
    end
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
	def self.authenticate_with_salt(id, cookie_salt)
    user = find_by(id: id)
	  (user && user.salt == cookie_salt) ? user : nil
  end  
 #feed functions for current_user--------------------------------------------------------------------------------
  def theme_with_user_ids_for_feed(is_not_authorized) 
	ids_arr = []
	value = []
	v_status_id = 1 if is_not_authorized
	v_status_id = [1,2] if !is_not_authorized
	userThemesMessages = messages.select("DISTINCT theme_id").where(:theme_id != nil, :status_id => 1)
	theme_where_wrote_ids = themes.select(:id).where(:id => userThemesMessages, :status_id => [1,3], :visibility_status_id => v_status_id)
	self_themes_ids = themes.select(:id).where(:status_id => [1,3], :visibility_status_id => v_status_id)
	ids_arr += theme_where_wrote_ids if theme_where_wrote_ids != [] #Ids тем в которых пользователь писал
	ids_arr += self_themes_ids if self_themes_ids != [] #Ids тем которые пользователь создал
	ids_arr.uniq! if ids_arr != []
	value = Theme.where(id: ids_arr).order('created_at DESC') if ids_arr != []
	return value
  end
  
  def answerMessages(is_not_authorized)
	value = []
	ids_arr = []
	v_status_id = 1 if is_not_authorized
	v_status_id = [1,2] if !is_not_authorized
	myMsgsIDs = messages.select(:id).where(:status_id => 1)
	myThIDs = themes.select(:id).where(:status_id => [1,3], :visibility_status_id => v_status_id)
	if myThIDs != []
		msgsInMyThemes = Message.select(:id).where(:status_id => 1, :theme_id => myThIDs)
  else
    msgsInMyThemes = []
	end
	if myMsgsIDs != []
		answrToMyMsgs = Message.select(:id).where(:message_id => myMsgsIDs, :status_id => 1)
  else
    answrToMyMsgs = []
	end
	ids_arr += msgsInMyThemes if msgsInMyThemes != []
	ids_arr += answrToMyMsgs if answrToMyMsgs != []
	ids_arr -= myMsgsIDs
	ids_arr.uniq! if ids_arr != []
	value = Message.where(id: ids_arr).order('created_at DESC') if ids_arr != []
	return value
  end
  
  def not_current_user_messages #сообщения других юзеров
	  Message.where(theme_id: theme_with_user_ids_for_feed, status_id: 1, user_id: "user_id != #{self.id}")
  end
  
  def themes_without_current_user(is_not_authorized) #Темы в которых пользователь не принимал участия
	result_themes = []
	v_status_id = 1 if is_not_authorized
	v_status_id = [1,2] if !is_not_authorized
	all_themes = Theme.where(:visibility_status_id => v_status_id, :status_id => [1, 3])
	with_user_themes = Theme.where(:user_id => self.id, :visibility_status_id => v_status_id, :status_id => [1, 3])
	result_themes = all_themes - with_user_themes
	return result_themes
  end
 #feed functions for current_user end----------------------------------------------------------------------------
 #conversations
 def get_conversation(user)
   cnv = self.conversations.where(id: user.conversations.where(multiple_users_flag: false).select(:id), multiple_users_flag: false).first
   if cnv.nil?
     cnv = Conversation.create(cnv_users: [self.id, user.id], name: user.name, multiple_users_flag: false)
   end
   return cnv
 end
 #conversations end
 def check_user_activity
  self.avatar? || !self.messages.blank? || !self.themes.blank? || !self.videos.blank? || !self.articles.blank? && !(self.created_at + 1.month < Time.now)
 end
  private
  
  def encrypt_password
    self.salt = make_salt if new_record?
	  self.encrypted_password = encrypt(password) if password != nil and password != '' or password_confirmation != password
  end	
  
  def encrypt(string)
	  secure_hash("#{salt}--#{string}")
  end
  
  def make_salt 
	  secure_hash("#{Time.now.utc}--#{password}")
  end
  
  def secure_hash(string)
	  Digest::SHA2.hexdigest(string)
  end

  #Логирование пользователя end
end
