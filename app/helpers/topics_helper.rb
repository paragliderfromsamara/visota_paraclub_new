module TopicsHelper
	
	def index_topic_buttons(topic)
		[
		 {:name => 'Перейти в раздел', :access => true, :link => "#{topic_path(topic)}", :type => 'follow', :id => 'showTopic' },
		 #{:name => "Добавить тему в раздел \"#{topic.name}\"", :access => userCreateThemeInTopic?(topic), :type => 'add', :link => "#{new_theme_path(:t => topic.id)}", :id => 'newTheme'}, 
		 {:name => 'Редактировать', :access => is_super_admin?, :type => 'edit', :link => "#{edit_topic_path(topic)}", :id => 'editTopic'}
		]
	end
	def top_index_topic_buttons
		"#{control_buttons([{:name => "Опросы", :access => true, :type => 'follow', :link => votes_path}, {:name => 'Новый раздел', :access => is_super_admin?, :type => 'add', :link => "#{new_topic_path}", :id => 'newTopic'}])}"
	end
	def show_topic_buttons(topic)
		[
		 {:name => "Добавить тему", :access => userCreateThemeInTopic?(topic), :type => 'add', :link => "#{new_theme_path(:t => topic.id)}", :id => 'newTheme'}, 
		]
	end
	def visota_life_panel

		v = {:name => "Опросы", :access => true, :type => 'grey', :link => votes_path}
	#	m = {:name => "Архив сообщений с para.saminfo.ru", :access => true, :type => 'grey', :link => old_messages_path}
	#	m[:selected] = true if controller.controller_name == 'old_messages'
		b = [v]
		return b
	end
	def topics_list_in_vl
		v = ''
		topics = Topic.all
		i = 0
		j = 0
		if topics != []
			topics.each do |t|
				i += 1
				v += "<div class = 'section group'>" if i == 1
				v += "<div class = 'col span_6_of_12'>"
				v += topic_mini_block_content(t)
				v += "</div>"
				if i == 2
					v += "</div>"
					i = 0
				end
				if t == topics.last
					i += 1
					v += "</div><div class = 'section group'>" if i == 1  
					v += "<div class = 'col span_6_of_12'>#{guest_book_vl_block}</div>"
					v += "</div>"
				end
			end
		end
		return v
	end
	def topic_mini_block_content(topic)
		v = ''
		v += "#{link_to(topic.name, topic, :class => 'b_link_bold', :style => 'font-size: 1em;')} <br />"
		themes = topic.last_active_themes(is_not_authorized?)
		entities_count = topic.entities_count(is_not_authorized?)
		if themes != []
			v += "<div style = 'width: 100%; height: 200px;'><table class = 'v_table' id = 'themes_list_vl'><tr><th id = 'first'>Тема</th><th>Автор крайнего сообщения</th><th>Дата</th></tr>"
			themes.each do |theme|
				m = ''
				msg = theme.last_message
				if msg != nil
					m = "<td class = 'usr'>
							#{ msg.user.name }
						 </td>
						 <td class = 'date'>
							#{ my_time(msg.created_at) }
						 </td>"
				else
					m = "<td class = 'usr'>
							#{ theme.user.name }
						 </td>
						 <td class = 'date'>
							#{ my_time(theme.created_at) }
						 </td>"
				end
				v += "
								<tbody title = '#{theme.name}' class = 't_link' link_to = '#{theme_path(theme)}'>
								<tr>
									<td class = 't_name' id = 'first'>
										#{truncate(theme.name, :length => 19)}
									</td>
									#{m}									
								</tr>
								</tbody>"
			end
			v += "</table></div>
						<div class = 'central_field' style = 'width: 100%;'>
							<table style = 'width: 100%;'>
								<tr>
									<td align = 'left' valign = 'middle'>
										#{ control_buttons(index_topic_buttons(topic)).html_safe }
									</td>
									<td style = 'width: 200px;'>
										<p class = 'istring_m norm medium-opacity'>Тем: #{ entities_count[:cThemes]} Сообщений: #{ entities_count[:cMessages] }</p>
									</td>
								</tr>
							</table>
						</div>"
		else
			v += "<div style = 'width: 100%; height: 200px;'><p class = 'istring_m'>В данном разделе нет ни одной темы</p></div>"
		end
		return v
	end
	def guest_book_vl_block
		"
		#{ link_to('Архив сообщений с para.saminfo.ru', old_messages_path, :class => 'b_link_bold', :style => 'font-size: 1em;') } <br />
		<div class = 'central_field' style = 'width: 100%; height: 200px;'>
			<div class = 'central_field' style = 'width: 90%;'>
				<p class = 'istring_m medium-opacity'>Здесь размещены сообщения сохранённые с старого сайта, который располагался по адресу <a class = 'b_link_i' rel = 'nofollow' target ='_blank' href='http://para.saminfo.ru/'>para.saminfo.ru...</a></p>
			</div>
		</div>
		<div class = 'central_field' style = 'width: 100%;'>
			<table style = 'width: 100%;'>
				<tr>
					<td align = 'left' valign = 'middle'>
						#{ control_buttons([{:name=> 'Перейти в раздел', :type => 'follow', :link => old_messages_path, :access=>true}]).html_safe }
					</td>
					<td style = 'width: 200px;'>
						<p class = 'istring_m norm medium-opacity'>Сообщений: #{ OldMessage.all.count }</p>
					</td>
				</tr>
			</table>
		</div>
		
		"
	end
end
