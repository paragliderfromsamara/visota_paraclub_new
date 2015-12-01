module MessagesHelper
	def my_message_errors
		@content_error = "" 
		@content_f_class = "norm"
		if @formMessage.errors[:content] != [] and @formMessage.errors[:content] != nil
			@content_f_color = "err"
			@formMessage.errors[:content].each do |err|
				@content_error += "#{err}<br />"
			end
		end
	end
	def message_theme_box(message, show_buttons, i) 
		p = {
				:tContent => message_body(message, show_buttons), 
				:fContent => answrToMsg(message), 
				:classLvl_1 => 'msgs', 
				:idLvl_1 => "m_#{message.id}", 
				:classLvl_2 => 'pb-top-s', 
				#:idLvl_2 => '', 
				:classBg => 'cWrapper', 
				:parity => i
			}
		return c_box_block(p)
	end
	def answrToMsg(m)
		return "<div class = 'answr' id = 'answr_to_#{m.id}' style='display: none;'></div>" if user_type != 'guest' and user_type != 'bunned'
	end 
	def author_string(m)
		t = ''
		if m.theme != nil
			t = 'Автор темы' if m.user == m.theme.user
		end
		if m.video != nil
			t = 'Автор видео' if m.user == m.video.user
		end
		if m.photo != nil
			t = 'Автор фото' if m.user == m.photo.user
		end
		if m.photo_album != nil
			t = 'Автор альбома' if m.user == m.photo_album.user
		end
		t = "<p class = 'istring_m medium-opacity'>#{t}</p>" if t != ''
		return t
			#{'' if message.user == message.theme.user}
	end
	def message_body(message, show_buttons)
		tread = message.get_visible_tread.count
		html = "
				<a name = 'msg_#{message.id}'></a>
				<table>
					<tr>
						<td valign = 'middle' align = 'left'  colspan = '2' style='height: 45px;'>
							<p class = 'istring_m norm medium-opacity'>Написано #{message.created_at.to_s(:ru_datetime)} #{answer_to_msg(message)}</p>
						</td>
					</tr>
					<tbody id = 'middle'>
						<td id = 'usr'>
							#{message_user_row(message)}
							<br />
								#{author_string(message)}
						</td>
						<td>
							<div class = 'central_field' style = 'width: 95%;'>
								#{message_photo(message)}
								<span align = 'left' id = 'content' class = 'mText'>#{message.content_html}</span>
								
								<br />
								#{message.message_updater}
								#{"<br /><div class = 'central_field' style = 'width: 760px;'>#{message_list_photos(message)}</div>" if message.visible_photos != []}
								#{"<br />#{list_attachments(message.attachment_files)}" if message.attachment_files != []}
							</div>
						</td>
					</tbody>
					<tr>
						<td colspan = '2' valign = 'middle'>
							<table style = 'width: 100%; height: 100%;'>
								<tr>
									<td align = 'left' valign = 'middle' style = 'width: 60%;'>
										#{control_buttons(msg_block_buttons_bottom_in_theme(message, tread)) if show_buttons == true and @theme != nil}
										#{control_buttons(msg_block_buttons_bottom_in_video(message, tread)) if show_buttons == true and @video != nil}
										#{control_buttons(msg_block_buttons_bottom_in_album(message, tread)) if show_buttons == true and @album != nil}
									</td>
									<td align = 'right' valign = 'middle'>
										<span  class = 'istring_m norm medium-opacity'>Ответов: #{tread}</span>
									</td>
								</tr> 
							</table>
						</td>
					</tr>			
				</table>	
		"
		return html
	end
	def gsub_test(text)
	   text.gsub(/\[fNum\](\n|\r)+((\d+\.\s.*(\n|\r)+)+)\[\/fNum\]/) do #\n((\d+\.\s.*\n)*)(\n)*\ \n\d+\.\s.*\n\[\/fNum\]
		c = $2
		if c != '' and c != nil 
			c = c.gsub(/(\d+)\.\s(.*)(\n|\r)/){"<li type = '1' value = #{$1}>#{$2}</li>"}
			"<ul class = 'cnt-un-num'>#{c}</ul>"
		else
			''
		end
		%{<ul class = 'cnt-un-num'>#{c}</ul>}
	  end
	end
	
	def message_photo(message)
		if message.photo != nil
			return "<div class = 'central_field' style = 'width:500px;'><p class='istring_m medium-opacity'>Комментарий к фотографии</p>#{image_tag message.photo.link, :width => '500px' if message.photo.isHorizontal?}#{image_tag message.photo.link, :height => '250px' if !message.photo.isHorizontal?}</div><br />" if message.photo != @photo 
		end
		return ''
	end
	def message_user_row(message)
		if message.user_id == nil or message.user_id == 0 and message.user_name != nil and message.user_name != ''
			return "<span id = 'u_name' class = 'istring_m norm'>#{message.user_name}</span><br />#{image_tag('/files/undefined.png', :width => '90px')}"
		elsif message.user_id != nil and message.user_id != 0
			return "#{link_to message.user.name, message.user, :class => 'b_link_i', :id => 'u_name'}<br />#{image_tag(message.user.alter_avatar, :width => '90px')}"
		elsif message.user_name == nil and message.user_name == '' and message.user_id == nil or message.user_id == 0 	
			return "<span class = 'istring_m norm'>Гость</span><br />#{image_tag('/files/undefined.png', :width => '90px')}"
		end
	end
	def answer_to_msg(message)		
		if message.message == nil
			return ""
		else
			if message.message.user != current_user
				answer_to = message.message.user.name
				if message.theme != nil
					answer_to += " (Автору темы)" if message.message.user == message.theme.user
				end
				if message.message.user != message.user and message.message.status_id == 1 
					return "<a id = 'ans_link' class = 'b_link_i' href = '#m_#{message.message.id.to_s}'>ответ пользователю #{answer_to}</a>"
				else
					return ""
				end
			else
				if message.message.user != message.user and message.message.status_id == 1 
					return "<a id = 'ans_link' class = 'b_link_i' href = '#m_#{message.message.id.to_s}'>ответил Вам</a>"
				else
					return ""
				end
			end
		end
	end
	def msg_block_buttons_bottom_in_theme(message, treadCount)
		buttons = []
		buttons += [{:name => 'Ответить', :access => userCanCreateMsgInTheme?(message.theme), :type => 'comments', :alt => message.id, :id => 'answer_but'}] if (user_type != 'bunned' and user_type != 'guest' || (user_type == 'new_user' and @theme.topic_id == 6)) if @theme.status == 'open'
		#buttons += [{:name => 'Смотреть ответы', :access => true, :type => 'arrow-right', :link => "#{message_path(message.id)}"}] if treadCount != 0 and @message != message
		buttons += [{:name => 'Изменить', :access => userCanEditMsg?(message), :type => 'pencil', :link => "#{edit_message_path(message)}"}]
		buttons += [{:name => 'Удалить', :access => userCanDeleteMessage?(message), :type => 'trash', :link => message_path(message), :rel => 'nofollow', :data_confirm => 'Вы уверены что хотите удалить сообщение?', :data_method => 'delete'}] if @theme.status == 'open'
		buttons[buttons.length] = {:name => 'Перенести сообщение', :type => "page-export", :access => is_admin?, :link => "/messages/#{message.id}/replace_message"}
		return buttons
	end
	def msg_block_buttons_bottom_in_video(message, treadCount)
		buttons = [{:name => 'Ответить', :access => !is_not_authorized?, :type => 'comments', :alt => message.id, :id => 'answer_but'}]
		#buttons += [{:name => 'Смотреть ответы', :access => true, :type => 'arrow-right', :link => "#{message_path(message)}"}] if treadCount != 0 and @message != message
		buttons += [
					      {:name => 'Изменить', :access => userCanEditMsg?(message), :type => 'pencil', :link => "#{edit_message_path(message)}"}, 
				        {:name => 'Удалить', :access => userCanDeleteMessage?(message), :type => 'trash', :link => message_path(message), :rel => 'nofollow', :data_confirm => 'Вы уверены что хотите удалить сообщение?', :data_method => 'delete'}
				       ]
		return buttons
	end
	def msg_block_buttons_bottom_in_album(message, treadCount)
	    buttons = [{:name => 'Ответить', :access => !is_not_authorized?, :type => 'comments', :alt => message.id, :id => 'answer_but'}]
		#buttons += [{:name => 'Смотреть ответы', :access => true, :type => 'arrow-right', :link => "#{message_path(message)}"}] if treadCount != 0 and @message != message
		buttons += [
					        {:name => 'Изменить', :access => userCanEditMsg?(message), :type => 'pencil', :link => "#{edit_message_path(message)}"}, 
					        {:name => 'Удалить', :access => userCanDeleteMessage?(message), :type => 'trash', :link => message_path(message), :rel => 'nofollow', :data_confirm => 'Вы уверены что хотите удалить сообщение?', :data_method => 'delete'}
				       ]
		return buttons
	end
end
