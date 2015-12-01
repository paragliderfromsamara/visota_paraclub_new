#require 'xmp'
require 'exifr'
require 'open-uri'
require  Rails.root.join("config/xmp")
class Photo < ActiveRecord::Base
  attr_accessor :delete_flag
  attr_accessible :article_id, :category_id, :description, :event_id, :link, :message_id, :name, :photo_album_id, :user_id, :theme_id, :status_id, :delete_flag, :visibility_status_id
  belongs_to :user
  belongs_to :theme #Фото как вложение в тему
  belongs_to :photo_album
  #belongs_to :category
  belongs_to :article
  belongs_to :event #Фото как фото в новости
  belongs_to :message #Фото как вложение в сообщение
  has_many :messages, :dependent  => :delete_all #Комментарии к фото
  has_many :photo_like_marks, :dependent  => :delete_all #Комментарии к фото
  mount_uploader :link, PhotoUploader
  before_destroy :delPhoto
  #photo_relations
  has_many :message_photos
  has_many :theme_photos
  has_many :article_photos
  has_many :event_photos
  #photo_relations end
  
  def comments
	self.messages.where(:status_id=>1).order('created_at ASC')
  end
  
  def views 
	[]
  end
  
  def delPhoto
	self.remove_link!
  end
  
  def parent #{:parent_type, :parent_link, :parent_name}
	type = {:published_in => '', :parent_type => '', :parent_link => '', :parent_name => '', :title_name => '', :link_name => ""}
	type = {:published_in => 'в материале', :parent_type => 'Материал', :parent_link => "/articles/#{article.id.to_s}", :parent_name => article.name, :title_name => "#{article.type_name_single} '#{article.name}'", :link_name => "К материалу"} if article != nil
	type = {:published_in => 'в альбоме', :parent_type => 'Альбом', :parent_link => "/photo_albums/#{photo_album.id.to_s}", :parent_name => photo_album.name, :title_name => "Фотоальбом '#{photo_album.name}'", :link_name => "К альбому"} if photo_album != nil
	#type = {:published_in => 'в новости', :parent_type => 'Новость', :parent_link => "/events/#{event.id.to_s}", :parent_name => event.title, :title_name => "Новость '#{event.title}'"} if event != nil and photo_album == nil
	type = {:published_in => 'в теме', :parent_type => 'Тема', :parent_link => "/themes/#{theme.id.to_s}", :parent_name => theme.name, :title_name => "Тема '#{theme.name}'", :link_name => "К теме"} if theme != nil
	if message != nil
		type = {:published_in => 'в сообщении темы', :parent_type => 'Сообщение в теме', :parent_link => "/themes/#{message.theme.id.to_s}#msg_#{message.id.to_s}", :parent_name => message.theme.name, :title_name => "Сообщение в теме '#{message.theme.name}'", :link_name => "К теме"} if message.theme != nil
	end
	return type
  end
  
  def parent_type
	type = 'Не определён'
	type = 'Фотоальбом' if photo_album != nil
	type = 'Тема' if theme != nil
	type = 'Сообщение' if message != nil
	type = 'Статья' if article != nil
	type = 'Новость' if event != nil
	return type 
  end
  def widthAndHeight
  	p = {:width=>0,:height=>0,:width_th=>0,:height_th=>0}
    image = Magick::Image.read(Rails.root.join("public#{self.link}")).first
    image_th = Magick::Image.read(Rails.root.join("public#{self.link.thumb}")).first
    p[:width] = image.columns
  	p[:height] = image.rows
    p[:width_th] = image_th.columns
    p[:height_th] = image_th.rows
	return p
  end
  
  def getSizeByWidth(width)
    w = nw = self.widthAndHeight[:width].to_f
    h = nh =self.widthAndHeight[:height].to_f
    p = w/h
    if w > width.to_f
      nw = width.to_f
      nh = nw/p.to_f
    end
    return {:height => nh, :width => nw}
  end
  
  def exif_data_xmp(name)
    v = ''
    path = Rails.root.join("public#{self.link}").to_s
    img = EXIFR::JPEG.new(path)
    if img.exif?
      xmp = XMP.parse(img)
     if xmp != nil
        xmp.namespaces.each do |namespace_name|
          namespace = xmp.send(namespace_name)
         namespace.attributes.each do |attr|
            if attr == name 
              v = namespace.send(attr)
            end
          end
        end
      end
    end
    return v
end
  def exif_data
    exif = []
	if  Magick::Image.read(Rails.root.join("public#{self.link}")).first.format == 'JPEG'
	path = Rails.root.join("public#{self.link}").to_s
    
    exifData = EXIFR::JPEG.new(path)
    image = Magick::Image.read(Rails.root.join("public#{self.link}")).first
    val = image.get_iptc_dataset('lens')
    #xml = Nokogiri::XML(exifData.app1s[1])
   # xmp = XMP.parse(exifData)
   model = exifData.model.to_s #модель камеры
   lens = self.exif_data_xmp('Lens').to_s #модель объектива
   iso = exifData.iso_speed_ratings.to_s #iso
   f_length = exifData.focal_length.to_f #фокусное расстояние
   exposure_time = exifData.exposure_time.to_s
   f_number = exifData.f_number.to_i 
   exposure = self.exif_data_xmp('Exposure').to_s
   artist = exifData.artist.to_s
   software = exifData.software.to_s
    exif = []
    exif[exif.length] = {name: 'Камера', value: model} if model.strip != '' 
    exif[exif.length] = {name: 'Объектив', value: lens} if lens.strip != '' 
    exif[exif.length] = {name: 'iso', value: iso} if iso.strip != '' 
    exif[exif.length] = {name: 'Фокусное расстояние', value: "#{f_length}mm"} if f_length  != 0.0 
    exif[exif.length] = {name: 'Выдержка', value: exposure_time} if exposure_time.strip  != ''
    exif[exif.length] = {name: 'Диафрагма', value: "f/#{f_number}"} if f_number  != 0.0
    exif[exif.length] = {name: 'Экспозиция', value: exposure} if exposure.strip  != ''
    exif[exif.length] = {name: 'Автор', value: artist} if artist.strip  != ''
    exif[exif.length] = {name: "ПО", value: software} if software.strip  != ''
	end
	return exif
  end
  def sel(d)
    hash={}
    d.instance_variables.each {|var| hash[var.to_s.delete("@")] = d.instance_variable_get(var) }
      return hash
  end
  def isHorizontal?
	p = self.widthAndHeight
	return true if p[:width] > p[:height]
	return false
  end
#Управление статусами...  
  def statuses 
	[	
		{:id => 0, :value => 'draft'},	  			#черновики
		{:id => 1, :value => 'normal'},	  			#черновики
		{:id => 2, :value => 'to_delete'},			#в очереди на удаление
		{:id => 3, :value => 'on_deleted_entity'},	#на удалённом объекте
		{:id => 4, :value => 'on_hidden_entity'}	#на скрытом объекте
	]
  end
  def v_statuses #статус отображения
  [
	{:id => 1, :value => 'visible'}, #отображена на родительской сущности
	{:id => 2, :value => 'hidden'} #скрыта на родительской сущности 
	]
  end
  def status
	stat = 'draft'
	statuses.each do |s|
		stat = s[:value] if status_id == s[:id]
	end
	return stat
  end
  
  def v_status #статус отображения
	stat = 'visible'
	v_statuses.each do |s|
		stat = s[:value] if s[:id] == self.visibility_status_id
	end
	return stat
  end
  
  def set_as_on_hidden_entity
	self.update_attribute(:status_id, 4) if self.status_id != 4 #Пометить как видимый
  end
  
#  def set_as_on_visible_entity #сделать прикреплённый к видимой сущности
#	self.update_attribute(:status_id, 1) if self.status_id != 1 #Пометить как видимый
#  end
  
  def set_as_visible
	  self.update_attribute(:visibility_status_id, 1) if self.visibility_status_id != 1 #Пометить как видимый
  end
  
  def set_as_hidden
    self.update_attribute(:visibility_status_id, 2) if self.visibility_status_id != 2 #Пометить как скрытый
  end
  
# def isNotFullDelete?
#	v = false
#	if self.status == 'normal'
#		if self.photo_album != nil
#			if self.photo_album.status == 'normal'
#				v = true
#			end
#		end
#	end
#	return v
#  end
  
#  def set_as_delete
#	self.update_attribute(:status_id, 2)
#	if messages != []
#		messages.each do |msg|
#			msg.update_attribute(:status_id, 3)
#		end
#	end #Пометить на удаление
#	
#  
#  end
  
 # def set_as_on_deleted_entity #Пометить как прикреплённый к удалённому объекту
#	self.update_attribute(:status_id, 3)
#	if messages != []
#		messages.each do |msg|
#			msg.update_attributes(:status_id=> 3)
#		end
#	end
#  end
  
#  def statusIsValid? #проверка статуса сообщения
#	if self.status_id == 0 || self.status_id == 2 || self.status_id == 3
#		return false #нет если удалён, черновик, или на удалённой сущности
#	else
#		return true  #да во всех остальных случаях
#	end
#  end
#Управление статусами end...
end
