module PhotoAlbumsHelper
#album block
	def album_index_block(album, i, pathName)
		html = album_table(album, pathName)
		p = {
				:tContent => html, 
				:idLvl_2 => "b_middle",
				:parity => i
			}
		v = top_album_buttons(album, pathName)
		v = (v == '')? '':"<div class = 'c_box'><div class = 'central_field' id = 'm_1000wh'>#{v}</div></div>"
		return "#{v}#{c_box_block(p)}".html_safe
	end
	def album_table(album, pathName)
		"
			<table style = 'width: 100%;'>				
				#{"<tr><td colspan = '2'><h3>#{album.name}</h3></td></tr>" if pathName == 'index' || pathName == 'visota_life'}
				<tr>
					<td align='left' valign='middle'>
						#{albumInformation(album)}
					</td>
					<td align = 'right' valign='middle'>
						<p class = 'istring_m norm medium-opacity'>Размещён #{my_time(album.created_at)}</p>
					</td>
				</tr>
				<tr>
					<td align = 'left' valign='middle' style = 'height:30px;'>
						<span class = 'istring_m norm medium-opacity'>Автор </span>#{link_to album.user.name, album.user, :class => 'b_link_i'}
					</td>
					<td align = 'right' valign='middle'>
						
					</td>
				</tr>
				<tr>
					<td align = 'left' valign='middle' >
						<span class = 'istring_m norm medium-opacity'>Категория </span>#{link_to album.category_name, "/media/?t=albums&c=#{album.category_id}", :class => 'b_link_i', :title => "Все альбомы категории #{album.category_name}"}
					</td>
					<td align = 'right' valign='middle'>
						
					</td>
				</tr>
        #{"<tr><td align = 'left' valign='middle' ><span class = 'istring_m norm medium-opacity'>Создан из темы </span>#{link_to album.theme.name, theme_path(album.theme), :class => 'b_link_i'}</td><td></td></tr>" if !album.theme.nil?}
				#{"<tr><td colspan = '2' align = 'left' valign='top'><p class = 'istring_m norm tb-pad-s'>#{album.description}</p></td></tr>" if album.description != nil and album.description != ''}
				<tr>
					<td colspan = '2'>
						#{album_photos_field(album, pathName)}
					</td>
				</tr>
				<tr>
          <td style = 'height: 40px;' align='left' valign = 'middle'>
            #{bottom_album_buttons(album, pathName)}	
          </td>
          <td align='right' valign = 'middle'>
            #{user_photo_album_like_link(album)}
          </td>
        </tr>
		   </table>
		"
	end
	def album_mini_table(album, pathName='index')
		"
			<table style = 'width: 100%;'>				
				<tr>
          <td align = 'left' valign = 'middle' style = 'width: 60%;'>
            <h3 style = 'height: 14px;' title = '#{album.name}'>#{truncate album.name, length: 26}</h3>
          </td>
          <td align = 'right'>
            <p class = 'istring_m norm medium-opacity'>Размещён #{my_time(album.created_at)}</p>
          </td>
        </tr>
				<tr>
					<td align='left' valign='middle'>
						<span class = 'istring_m norm medium-opacity'>Автор: </span>#{link_to album.user.name, album.user, :class => 'b_link_i'}
					</td>
					<td align = 'right' valign='middle'> 
             #{albumInformation(album)}
					</td>
				</tr>
				<tr>
					<td colspan = '2'>
						<div class = 'm_95p tb-pad-s'>
              #{image_tag album.get_photo.link.big_thumb, width: '100%' if album.get_photo.link?}
            </div>
					</td>
				</tr>
				<tr>
          <td  align='left' valign = 'middle'>
            #{bottom_album_buttons(album, pathName)}	
          </td>
          <td align='right' valign = 'middle'>
            #{user_photo_album_like_link(album)}
          </td>
        </tr>
		   </table>
		"
	end
  def view_mode_albums_list
    if session[:albums_list_type].nil?
      session[:albums_list_type] = (params[:albums_list_type].nil?)? "thumbs" : params[:albums_list_type]
    else
      session[:albums_list_type] = (params[:albums_list_type].nil?)? session[:albums_list_type] : params[:albums_list_type]
    end
    link = ["/media?albums_list_type=list#{"&page=#{params[:page]}" if !params[:page].nil?}", "/media?albums_list_type=thumbs#{"&page=#{params[:page]}" if !params[:page].nil?}"]
	  "<a href = '#{link[0]}' class = 'th-view-mode' data-remote = 'true' id = 'th-as-list'><i class = 'fi-list fi-large#{session[:albums_list_type] == 'list' ? ' fi-blue' : ' fi-grey'}'></i></a>  <a href = '#{link[1]}' class = 'th-view-mode' data-remote = 'true' id = 'th-as-thumbnails'><i class = 'fi-thumbnails fi-large#{session[:albums_list_type] == 'thumbs' ? ' fi-blue' : ' fi-grey' }'></i></a>"
  end
	def album_photos_field(album, pathName)
		value = ''
		photos = []
		width = (pathName == 'visota_life')? '510px':'903px'
		allPhotosCount = album.photos.count 
    if pathName == 'index'
			photos = album.index_photos
		elsif pathName == 'show'
			photos = album.photos
		elsif pathName == 'visota_life'
			photos = album.visota_life_photos
		end
		if photos != []
			photos.each do |p|
				value += "<a href = '#{photo_path(id: p.id, e:'photo_album', e_id:album.id)}' da title = '#{p.description}' alt = '#{photo_path(id: p.id, e:'photo_album', e_id:album.id)}' ><div class = 'inline-blocks inline-mini'><div class = 'central_field' style = 'width: 150px; margin-top: 7px;'><img src = '#{p.link.small_thumb}' style = 'display: none;'/></div></div></a>" if pathName == 'index' || pathName == 'visota_life'
				value += "<a href = '#{photo_path(id: p.id, e:'photo_album', e_id:album.id)}' title = '#{p.description}' alt = '#{photo_path(id: p.id, e:'photo_album', e_id:album.id)}' ><div class = 'inline-blocks inline-thumb'><div class = 'central_field' style = 'width: 250px; margin-top: 15px;'><img src = '#{p.link.thumb}' style = 'display: none;' width = '250px' /></div><div style = 'width: 100px; height: 23px; position: absolute; bottom: 5px; right: 15px;'>#{photoInfo(p)}</div></div></a>" if pathName == 'show'
			end
			value = "<div class = 'central_field' style = 'width: #{width}; padding-top: 10px; padding-bottom:10px;'>#{value}</div>"
      value += "<br /><p class = 'istring_m medium-opacity'>показано #{photos.count} из #{allPhotosCount}</p>" if allPhotosCount > photos.count
		end
		return value
	end
	def top_album_buttons(album, pathName) #кнопки в верхней части блока
		v=[]
		val=''
		if pathName == 'show' and @album != nil
			v = [
				   {:name => 'К списку альбомов', :access => true, :type => 'arrow-right', :link => "/media?t=albums&c=all"}, 
				   {:name => 'Все альбомы пользователя', :access => true, :type => 'arrow-right', :link => "/users/#{@album.user.id.to_s}/photo_albums"},
			     {:name => 'Редактировать', :access => isEntityOwner?(@album), :type => 'pencil', :link => "#{edit_photo_album_path(@album)}"},	
			     {:name => 'Удалить', :access => isEntityOwner?(@album), :type => 'trash', :link => photo_album_path(@album), :rel => 'nofollow', :data_confirm => 'Вы уверены что хотите удалить альбом и всё, что с ним связанно?', :data_method => 'delete'}
		      ]
		end
		val = "#{control_buttons(v)}" if v != []
		return val
	end	
	def bottom_album_buttons(album, pathName) #кнопки в нижней части блока
		v = []
		val = ''
		if pathName == 'index' || pathName == 'visota_life'
			v = [{:name => 'Перейти', :access => true, :type => 'arrow-right', :link => "#{photo_album_path(album)}"}]
      #elsif pathName == 'show' and @album != nil
			#v = [{:name => 'Добавить комментарий', :access => userCanCreateMsg?, :type => 'plus', :id => 'newMsgBut', :link => '#new_message'}]
            val = "#{control_buttons(v)}" if v != []
        else
            val = "#{vk_like_vidget({title: @album.name, description: @album.description.blank? ? "Альбом категории \"#{@album.category[:name]}\"" : @album.description, image: @album.get_photo.link.to_s, url: photo_album_path(@album)})[:button]} <div id = 'vk_but'></div>"
        end

		return val
	end
	def albumInformation(album)
		v = "<div title = 'Фотографий в альбоме' class='stat fi-float-left'><i class = 'fi-camera fi-medium fi-grey'></i><span>#{album.photos.count}</span></div>"
    v += "<div title = 'Комментарии' class='stat fi-float-left'><i class = 'fi-comments fi-medium fi-grey'></i><span>#{album.comments.count.to_s}</span></div>"
		v += "<div class='stat fi-float-left'><i class = 'fi-eye fi-medium fi-grey'></i><span>#{album.views}</span></div>" #{album.views.count}
    return "#{v}"
	end
#album block end
	def album_errors
		@name_error = ''
		@description_error = ''
		@photos_error = ''
		@name_f_color = ''
		@description_f_color = ''
		@photos_f_color = ''
		if @albumToForm.errors[:name] != nil and @albumToForm.errors[:name] != []
			@name_f_color = "err"
			@albumToForm.errors[:name].each do |err|
				@name_error += "#{err}"
			end
		end
		if @albumToForm.errors[:description] != nil and @albumToForm.errors[:description] != []
			@description_f_color = "err"
			@albumToForm.errors[:description].each do |err|
				@description_error += "#{err}"
			end
		end
		if (@albumToForm.errors[:photos] != nil and @albumToForm.errors[:photos] != [])
			@photos_f_color = "err"
			@albumToForm.errors[:photos].each do |err|
				@photos_error += "#{err}"
			end
		end
    if  @albumToForm.errors[:deleted_photos] != nil and @albumToForm.errors[:deleted_photos] != []
      @photos_f_color = "err"
			@albumToForm.errors[:deleted_photos].each do |err|
				@photos_error += "#{err}"
			end
    end
	end
	def initPhotoAlbumForm
			@albumToForm = current_user.album_draft if @albumToForm == nil
			if action_name == 'new' || action_name == 'create' || action_name == 'make_album'
				@buttName = 'Создать альбом'
			elsif action_name == 'edit' || action_name == 'update'
				@buttName = 'Внести изменения'
			end
			album_errors
	end
	def albums_paths_buttons #buttons => {:name => 'Перейти', :title => "Перейти на страницу пилота", :access => ['all'], :type => 'b_green', :link => user_path(user)}
		al = PhotoAlbum.new
		link = photo_albums_path
		link = "/users/#{@user.id}/photo_albums" if @user != nil
		cur = params[:c]
		all_but = {:name => 'Все', :access => true, :type => 'b_grey', :link => link} 
		all_but[:selected] = true if cur == nil or cur == []
		buttons_array = [
							all_but   
						]
		al.categories.each do |c|
			if @user == nil
				cAlbums = PhotoAlbum.where(category_id: c[:value], status_id: 1)
			else
				cAlbums = PhotoAlbum.where(category_id: c[:value], status_id: 1, user_id: @user.id)
			end
			but = {:name => "#{c[:name]} [#{cAlbums.count}]", :access => true, :type => 'b_grey', :link => link + "?c=" +c[:path_name]}
			but[:selected] = true if cur == c[:path_name]
			buttons_array[buttons_array.length] = but
			
		end
		return buttons_in_line(buttons_array)
	end
#не актуально....
	def photo_comment_block(message, visibility)
		"<div class = 'bl_1' style = 'display: #{visibility};' id = 'm_#{message.id}'>
			<div class = 'bl_2_h'>
				<p>#{message.created_at.to_s(:ru_datetime)}</p>
			</div>
			<div class = 'bl_1_body'>
				<table style = 'width: 98%;'>
					<tr>
						#{"<td align = 'center' valign = 'top' style = 'width: 50px;'>
							<div >
								#{image_tag message.photo.link.small, :style => 'display: block; position: relative;'}
							</div>
						</td>" if message.photo != nil}
						<td align = 'left' valign = 'top'>
							#{message.user.empty_card} <hr />
							#{answer_to_msg(message)}
							<p align = 'left' id = 'content'>#{message.content_html}</p>
							<br />
							#{message.message_updater}
						</td>
					</tr>
				</table>
				
			</div>
			<div id = 'answr' class = 'central_field' style = 'width: 99%; z-index: 1000;'></div>
			<div class = 'bl_1_bottom'>
				#{buttons_in_line(comment_buttons_bottom(message))}
			</div>
		</div>"
	end
	
	def comment_buttons_bottom(message)
		arr = []
		arr[arr.length] =  {:name => 'Читать все комментарии', :access => ['all'], :type => 'b_grey', :link => photo_path(message.photo) + '#comments'} if message.photo != nil
		arr[arr.length] =  {:name => 'Ответить', :access => ['super_admin', 'admin', 'manager', 'club_pilot', 'friend'], :type => 'b_green', :onclick => 'makeAnswer(' + "#{message.id}" + ', this)', :id => 'answer_but'}
		arr[arr.length] =  {:name => 'Изменить', :access => ['super_admin', 'admin', message.user.id], :type => 'b_green', :link => "#{edit_message_path(message)}"}
		arr[arr.length] =  {:name => 'Удалить', :access => ['super_admin', 'admin'], :type => 'b_green', :link => "#"}
		return arr
	end

	def index_albums_buttons
		[	
		 {:name => 'Добавить новый альбом', :access => !is_not_authorized?, :type => 'plus', :link => new_photo_album_path}
		]
	end
	def user_albums_buttons
		[
		{:name => 'К странице пользователя', :access => true, :type => 'b_grey', :link => "#{user_path(@user)}"},
		{:name => 'Все фотоальбомы', :access => true, :type => 'b_grey', :link => "/media?t=albums&c=all"}
		]
	end

	def album_control_buttons
		[
		 {:name => 'Добавить фотографии', :access => ['super_admin', 'admin', @album.user_id], :type => 'b_green', :id => 'toggle_but'},
		 {:name => "Изменить фотографии", :access => [@album.user_id], :type => 'b_green', :link => "/edit_photos?e=pa&e_id=#{@album.id}"}
		]
	end
	def add_photo_form
		form = form_for(@album, :action => :update, :html => {:method => :put, :multipart => true}) do |f|
				("
					<input type = 'hidden' name = 'update_type' value = 'add_photos' />
					#{f.file_field :photos, :multiple => true} #{f.submit 'Загрузить фотографии'}
				").html_safe
				end
		container = "<div id = 'add_phts'>#{buttons_in_line(album_control_buttons)}<div class = 'g_field' id = 'toggle_ent' style = 'position: relative; width: 98%; display: none; z-index: 1000; top: 5px;'>#{form}</div></div>"		
		return container.html_safe
	end
	
end
