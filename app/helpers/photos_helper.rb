module PhotosHelper

	def photo_pagination 
		cur_index = @photos.index(@photo) #Текущий элемент
		phsCount = @photos.count #Номер последнего элемента
		max_number_in_line = 7 #Максимальное количесво номеров в ряд (ДОЛЖНО БЫТЬ НЕЧЁТНЫМ!!!)
		val = ''
		@f='none'
		@l='none'
		@c='none'
		offset = (max_number_in_line-1)/2
		if phsCount < max_number_in_line
			i = 0
			@photos.each do |p|
				if i == cur_index
					val += "<div class = 'ph-paginate ph-cur' style = 'background-image:url(\"#{p.link.thumb}\");' ></div>"
				else
					val += "<div class='ph-paginate' link_to='#{photo_path(id: p.id, e: params[:e], e_id: params[:e_id])}' style = 'background-image:url(\"#{p.link.thumb}\");'></div>"
				end
				i += 1	
			end
		else
			fVisible = 0
			lVisible = 0
			if (cur_index + offset) > (phsCount-1)
				fVisible = phsCount-max_number_in_line
				lVisible = phsCount-1
			elsif(cur_index - offset) < 0
				fVisible = 0
				lVisible = max_number_in_line-1
			elsif !((cur_index + offset) > (phsCount-1)) && !((cur_index - offset) < 0)
				fVisible = cur_index - offset
				lVisible = cur_index + offset
			end
			@f=fVisible
			@l=lVisible
			@c= cur_index
			i = 0
			@photos.each do |p|
				if i == cur_index
					val += "<div class = 'ph-paginate ph-cur' style = 'background-image:url(\"#{p.link.thumb}\");' ></div>"
				elsif !(i<fVisible) and !(i>lVisible) 
					val += "<a href = '#{photo_path(id: p.id, e: params[:e], e_id: params[:e_id])}'><div class='ph-paginate' style = 'background-image:url(\"#{p.link.thumb}\");'></div></a>"
				else
					val += "<a href = '#{photo_path(id: p.id, e: params[:e], e_id: params[:e_id])}'><div class='ph-paginate ph-h' style = 'background-image:url(\"#{p.link.thumb}\");'></div></a>"
				end
				i+=1
			end
		end
		return "#{val}"
	end
	
	def make_numbers_string(start_index, end_index, cur_index)
		value = ''
		i = 0
		@photos.each do |p|
			if i == cur_index
				value += "#{image_tag(@photos[i].link.thumb, :class => 'ph-paginate ph-cur')}"
			elsif !(i<start_index) and !(i>end_index) and i != cur_index
				value += "<a href = '#{photo_path(id: p.id, e: params[:e], e_id: params[:e_id])}'>#{image_tag(p.link.thumb, :class => 'ph-paginate ph-cur')}</a>"
			elsif (i<start_index) or (i>end_index)	
				value += "<a href = '#{photo_path(id: p.id, e: params[:e], e_id: params[:e_id])}'>#{image_tag(p.link.thumb, :class => 'ph-paginate ph-cur ph-h')}</a>"
			end
			i += 1
		end
		return value
	end
	
	def photo_nav_bar
		value = ''
		#value += "#{link_to(image_tag(@photo.user.alter_avatar_thumb), @photo.user, :title => 'Перейти к странице пользователя ' + @photo.user.name)}" if @photo.user != nil
		value += "#{link_to 'К альбому', @photo.photo_album} <span style = 'font-family: Tahoma;'>|</span> #{link_to('Все альбомы', photo_albums_path)}" if @photo.photo_album != nil
		return value
	end
	
	def photo_info
		value = ''
		value += "<tr><td align = 'left' valign = 'middle'><span class = 'istring_m norm'>Фото разместил</span> #{link_to @photo.user.name, @photo.user, :class=>'b_link_i'}</td></tr>" if @photo.user != nil
	  value += "<tr><td align = 'left' valign = 'middle'><span class = 'istring_m norm'>Описание:</span> <span class = 'istring_m'>#{@photo.description}</span></td></tr>" if !@photo.description.blank?
  #	value += "<tr><td align = 'left' valign = 'middle'><span class = 'istring_m norm'>Размещено #{@photo.parent[:published_in]}</span> #{link_to(@photo.parent[:parent_name], @photo.parent[:parent_link], :class => 'b_link_i')}</td></tr>" 
    return "<table style = 'width: 98%; font-size: 14pt;'>#{value}</table>"
	end
	def photoInfo(photo)
		v = "<div title = 'Комментарии' class='stat fi-float-left'><i class = 'fi-comments fi-medium fi-grey'></i><span>#{photo.comments.count.to_s}</span></div>"
    v += "<div title = 'Просмотры' class='stat fi-float-left'><i class = 'fi-eye fi-medium fi-grey'></i><span>#{photo.views}</span></div>"
		return "<div class = 'medium-opacity' id = 'right_f'>#{v}</div>"
	end
	def photo_comment_button
		control_buttons([{:name => 'Добавить комментарий', :access => userCanCreateMsg?, :type => 'add', :id => 'newMsgBut'}])
	end
	
	def message_list_photos(msg)
		value = ''
		phts = msg.visible_photos
		if phts != []
			phts.each do |photo|
				value += "<a href = '#{photo.link}' data-lightbox = 'msg_#{msg.id}' title = '#{photo.description}' alt = '#{photo_path(photo)}' ><div class = 'inline-blocks inline-thumb-no-info'><div class = 'central_field' style = 'width: 250px; margin-top: 15px;'><img #{"style = 'display: none;'" if params[:preview_mode] != 'true'} width = '250px' src = '#{photo.link.thumb}' /></div></div></a>"
			end
		end
		return value
	end
	
	def theme_list_photos(th)
		value = ''
		phts = th.visible_photos
		if phts != []
			phts.each do |photo|
				value += "<a href = '#{photo.link}' data-lightbox = 'th_#{th.id}' title = '#{photo.description}' alt = '#{photo_path(photo)}' ><div class = 'inline-blocks inline-thumb-no-info'><div class = 'central_field' style = 'width: 250px; margin-top: 15px;'><img #{"style = 'display: none;'" if params[:preview_mode] != 'true'}  width = '250px' src = '#{photo.link.thumb}' /></div></div></a>"
			end
		end
		return value
	end
	def article_list_photos(ar)
		value = ''
		phts = ar.visible_photos
		if phts != []
			phts.each do |photo|
				value += "<a href = '#{photo.link}' data-lightbox = 'ar_#{ar.id}' title = '#{photo.description}' alt = '#{photo_path(photo)}' ><div class = 'inline-blocks inline-thumb-no-info'><div class = 'central_field' style = 'width: 250px; margin-top: 15px;'><img #{"style = 'display: none;'" if params[:preview_mode] != 'true'} style = 'display: none;' width = '250px' src = '#{photo.link.thumb}' /></div></div></a>"
			end
		end
		return value
	end
    
    def edit_photos_item(e, f = nil)
        photo = e.photo
        return "" if photo.nil? || e.nil?
        v = photo_mini_form(photo).html_safe
        f = f.nil? ? userCanDeleteEntityPhoto?(e) : f
        b = "<ul id = 'edit_ph_menu'>"
        b += "<a class='b_link pointer addHashCode' hashCode= '#Photo#{photo.id.to_s}' title = 'Нажмите, чтобы встроить фото в текст...'><li><p>Встроить в текст</p></li></a>" if (params[:hashToCont] == 'true' || @hashToCont == true) and @entity != 'photo_album'
        b += "<a class = 'del-photo-but b_link pointer' photo_id = '#{e.id }'><li><p>Удалить</p></li></a>" if f
        b += "<a class='b_link pointer set-as-main' set_photo_id='#{photo.id.to_s }' title = 'Сделать главной фотографией альбома...'><li><p>Установить как фото альбома</p></li></a>" if @entity == 'photo_album'
        b += "</ul>"
        return "<li class = 'ph-list-items' id = 'img_#{photo.id.to_s }'>
                    <div class = 'ph-block-c'>
                        <div class = 'central_field' >
                            <div >
                                #{image_tag(photo.link.thumb, :class => 'album_thumb_photo')}
                            </div>
                            <div style = 'height: 50px;'>
                                #{v}
                                #{b}
                            </div>
                            
                        </div>
                    </div>
                </li>"
    end
    def photo_mini_form(photo)
        form_for(photo, remote: true, html: {class: "photo_form"}) do |f|
            "
                <div style = 'width: 100%; height: 20px;' ><p style= 'display: none; color: green;' class = 'istring' id = 'notice'>Фото успешно обновлено</p></div>
                #{f.text_area(:description, :rows => '3', :cols => '30', :defaultRows => 3, :value => photo.description, style: "width: #{photo.widthAndHeight[:width_th]-6}px; position:;top: 5px;", placeholder: "Описание фото")}
            ".html_safe
        end 
    end
end
