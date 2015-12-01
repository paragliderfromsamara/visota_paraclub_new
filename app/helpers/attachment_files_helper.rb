module AttachmentFilesHelper
	def list_attachments(attachment_files) #вложенные файлы
		value = ''
		if attachment_files != [] and attachment_files != nil
			value = '<div class = "c-box ch-block"><div class = "central_field tb-pad-s" style = "width: 98%;"><span class = "istring">Вложения: <br /><ul class = "af-uploaded-field">'
			attachment_files.each do |file|
				value += "<li class = \"af-item_list\"><a class = 'b_link' href = '#{file.link}'>#{file.name}</a> <span class = 'istring_m medium-opacity'>(#{file.alter_size})</span></li> "
				value += "</ul></div></div>" if file == attachment_files.last
			end
		end
		return value
  end
end
