class AttachmentFile < ActiveRecord::Base
   attr_accessor :directory, :uploaded_file
   attr_accessible :name, :article_id, :message_id, :event_id, :user_id, :link, :theme_id, :size, :directory, :uploaded_file
   belongs_to :user
   belongs_to :article
   belongs_to :event
   belongs_to :message
   belongs_to :theme
   #mount_uploader :link, AttachmentFileUploader
   before_save :add_file_to_tmp, on: :create
   after_create :replace_file_from_temp, on: :create
   before_destroy :delete_file_in_folder
   
   
   def add_file_to_tmp
     if new_record?
       tmp_folder = getTmpFolderName
       save_dir = "public/#{tmp_folder}"
       uploaded_io = self.uploaded_file
       FileUtils.mkdir_p(save_dir) unless File.exists?("#{Rails.root}/#{save_dir}")
  		 File.open(Rails.root.join(save_dir, uploaded_io.original_filename), 'wb') do |file|
  			  file.write(uploaded_io.read)
  		 end
       dir_link = "/#{tmp_folder}/" + uploaded_io.original_filename
       self.size = uploaded_io.size
       self.name = uploaded_io.original_filename
       self.link = dir_link
     end
   end
   def replace_file_from_temp
      cur_link = "public#{self.link}"
			save_dir = "public/#{newFilePath}"
      if File.exists?("#{Rails.root}/#{cur_link}")
        FileUtils.mkdir_p(save_dir) unless File.exists?("#{Rails.root}/#{save_dir}/#{self.name}")
        f = File.open(Rails.root.join(cur_link))
  			File.open(Rails.root.join(save_dir, self.name), 'wb') do |file|
  				file.write(f.read)
  			end
        delDir = ("#{Rails.root}/#{cur_link}").gsub(self.name, "")
        File.delete("#{Rails.root}/#{cur_link}")
        FileUtils.rmdir delDir
      end
			dir_link = "/#{newFilePath}/" + self.name
			self.update_attribute(:link, dir_link)
   end
   
   def delete_file_in_folder
    del_link = ("#{Rails.root}/public#{self.link}").gsub(self.name, "")
		File.delete("#{Rails.root}/public#{self.link}")
    FileUtils.rmdir del_link
   end
   
   def get_file_size
	   file_size = File.size("#{Rails.root}/public#{self.link}")
	   self.update_attribute(:size, file_size)
   end
   
   def alter_size
	if size == nil
		get_file_size
	end
	if size != nil
		alt_size = size
		measure = 'байт'
		if size < 1000
			alt_size = size
			measure = 'байт'
		elsif size >= 1000 && size < 1000000
			alt_size = size/1000
			measure = 'Кбайт'
		elsif size >= 1000000 && size < 1000000000
			alt_size = size/1000000
			measure = 'Mбайт'
		elsif size >= 1000000000 
			alt_size = size/1000000000
			measure = 'Гбайт'
		end
		return "#{alt_size.to_s} #{measure}"
	else
		return ''
	end
   end
   private 
   
   def getTmpFolderName
     "uploads/attachment_files/tmp/#{Time.now.strftime("%Y-%m-%d-%H-%M-%S-%6N")}"
   end
   def newFilePath
     "uploads/attachment_files/#{self.directory}/#{self.id}"
   end
end
