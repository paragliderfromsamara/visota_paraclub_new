module TopicsHelper
	
	def index_topic_buttons(topic=nil)
    if topic.nil?
  		[
  		 {:name => 'Перейти в раздел', :access => true, :link => "/followed_themes", :type => 'arrow-right', :id => 'showTopic' }
      ]
    else
		[
		 {:name => 'Перейти в раздел', :access => true, :link => "#{topic_path(topic)}", :type => 'arrow-right', :id => 'showTopic' },
		 #{:name => "Добавить тему в раздел \"#{topic.name}\"", :access => userCreateThemeInTopic?(topic), :type => 'add', :link => "#{new_theme_path(:t => topic.id)}", :id => 'newTheme'}, 
		 {:name => 'Редактировать', :access => is_super_admin?, :type => 'pencil', :link => "#{edit_topic_path(topic)}", :id => 'editTopic'}
		]
    end
	end
	def top_index_topic_buttons
    activeVotes = Vote.active_votes.count
		return "#{control_buttons([{:name => "Опросы#{" (активных: #{activeVotes})"if activeVotes > 0}", :access => true, :type => 'graph-bar', :link => votes_path}, {:name => 'Новый раздел', :access => is_super_admin?, :type => 'plus', :link => "#{new_topic_path}", :id => 'newTopic'}])}"
	end
	def show_topic_buttons(topic)
		[
		 {:name => "Добавить тему", :access => userCreateThemeInTopic?(topic), :type => 'plus', :link => "#{new_theme_path(:t => topic.id)}", :id => 'newTheme'},
     {:name => "Пометить все как прочитанные", :access => signed_in?, :type => 'checkbox', :link => "#{topic_path(topic)}}/set_as_read_all_themes", :id => 'setAsRead', remote: true}
		]
	end
	def visota_life_panel
    activeVotes = Vote.active_votes.count
		v = {:name => "Опросы#{" (активных: #{activeVotes})"if activeVotes > 0}", :access => true, :type => 'grey', :link => votes_path}
	#	m = {:name => "Архив сообщений с para.saminfo.ru", :access => true, :type => 'grey', :link => old_messages_path}
	#	m[:selected] = true if controller.controller_name == 'old_messages'
		b = [v]
		return b
	end
  def topic_themes_filter
    buttons = []
    allThemes = @topic.themes.size
    myThemes = @topic.themes.where(user_id: current_user.id).size
    myNtfThemes = @topic.themes.where(id: current_user.theme_notifications.select(:theme_id)).size
    myNotVisitedThemes = @topic.themes.where(id: current_user.not_readed_themes_ids(@topic, is_not_authorized?)).size
    buttons[buttons.length] = {:name => "Все[#{allThemes}]", :access => true, :type => 'b_grey', :link => topic_path(id: @topic.id), selected: is_cur_th_filter_mode_all?}
    buttons[buttons.length] = {:name => "Не просмотренные[#{myNotVisitedThemes}]", :access => true, :type => 'b_grey', :link => topic_path(id: @topic.id, th_filter: 'not_visited'), selected: params[:th_filter] == 'not_visited'}
    buttons[buttons.length] = {:name => "Мои темы[#{myThemes}]", :access => true, :type => 'b_grey', :link => topic_path(id: @topic.id, th_filter: 'my'), selected: params[:th_filter] == 'my'}
    buttons[buttons.length] = {:name => "Отслеживаемые темы[#{myNtfThemes}]", :access => true, :type => 'b_grey', :link => topic_path(id: @topic.id, th_filter: 'ntf'), selected: params[:th_filter] == 'ntf'}
    return buttons_in_line(buttons).html_safe
  end
  def is_cur_th_filter_mode_all?
    params[:th_filter] != 'not_visited' && params[:th_filter] != 'my' && params[:th_filter] != 'ntf'
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
		v += "#{link_to(topic.name, topic, :class => 'b_link_bold', :style => 'font-size: 16px;')} <br />"
		themes = topic.last_active_themes(is_not_authorized?)
		entities_count = topic.entities_count(is_not_authorized?)
    v += topic_description(topic)
		v += topic_themes_table(themes)
		v += "<div class = 'central_field' style = 'width: 100%;'>
						<table style = 'width: 100%;'>
							<tr>
								<td align = 'left' valign = 'middle'>
									#{ control_buttons(index_topic_buttons(topic)).html_safe }
								</td>
								<td style = 'width: 150px;'>
									<p class = 'istring_m norm medium-opacity'>Тем: #{ entities_count[:cThemes]} Сообщений: #{ entities_count[:cMessages] }</p>
								</td>
							</tr>
						</table>
					</div>"
		return v
	end
	def guest_book_vl_block
		"
		#{ link_to('Архив сообщений с para.saminfo.ru', old_messages_path, :class => 'b_link_bold', :style => 'font-size: 1em;') } <br />
		<div class = 'central_field' style = 'width: 100%; height: 160px;'>
			<div class = 'central_field' style = 'width: 90%;'>
				<p class = 'istring_m medium-opacity'>Здесь размещены сообщения сохранённые с старого сайта, который располагался по адресу <a class = 'b_link_i' rel = 'nofollow' target ='_blank' href='http://para.saminfo.ru/'>para.saminfo.ru...</a></p>
			</div>
		</div>
		<div class = 'central_field' style = 'width: 100%;'>
			<table style = 'width: 100%;'>
				<tr>
					<td align = 'left' valign = 'middle'>
						#{ control_buttons([{:name=> 'Перейти в раздел', :type => 'arrow-right', :link => old_messages_path, :access=>true}]).html_safe }
					</td>
					<td style = 'width: 200px;'>
						<p class = 'istring_m norm medium-opacity'>Сообщений: #{ OldMessage.all.count }</p>
					</td>
				</tr>
			</table>
		</div>
		"
	end
  
  def topic_themes_table(themes)
		v = ''
    if themes != []
			v += "<div style = 'width: 100%; height: 160px;'><table class = 'v_table' id = 'themes_list_vl'><tr><th id = 'first'></th><th>Тема</th><th>Автор крайнего сообщения</th><th>Дата</th></tr>"
			themes.each do |theme|
        thReadInfo = theme.theme_read_info(current_user)
        msg = thReadInfo[:last_message]
        link = thReadInfo[:link]
        not_read_txt = thReadInfo[:info]
				m = ''
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
								<tbody title = '#{theme.name}' class = 't_link' link_to = '#{link}'>
								<tr>
                  <td id = 'first' class = 'new_msg_counter'>
                    #{not_read_txt}
                  </td>
									<td class = 't_name'>
										#{truncate(theme.name, :length => 20)}
									</td>
									#{m}									
								</tr>
								</tbody>"
			end
			v += "</table></div>"

		else
			v += "<div style = 'width: 100%; height: 200px;'><p class = 'istring_m'>В данном разделе нет ни одной темы</p></div>"
		end
		return v
  end
  
  def tracked_themes
		v = ''
		v += "#{link_to("Отслеживаемые темы", "/tracked_themes", :class => 'b_link_bold', :style => 'font-size: 1em;')} <br />"
		themes = current_user.tracked_themes(is_not_authorized?).limit(4)
		entities_count = {cThemes: 0, cMessages: 0}
		v += topic_themes_table(themes)
		v += "<div class = 'central_field' style = 'width: 100%;'>
						<table style = 'width: 100%;'>
							<tr>
								<td align = 'left' valign = 'middle'>
									
								</td>
								<td style = 'width: 150px;'>
									<p class = 'istring_m norm medium-opacity'>Тем: #{ entities_count[:cThemes]} Сообщений: #{ entities_count[:cMessages] }</p>
								</td>
							</tr>
						</table>
					</div>"
		return v
  end
  
  
  def topic_description(topic=@topic)
   return "" if topic.description.blank?
   return "<p class = 'istring_m norm tb-pad-s'>#{topic.description}</p>"
  end
end
