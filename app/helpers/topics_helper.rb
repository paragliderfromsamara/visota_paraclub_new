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
		 {:name => "#{(@topic.is_not_equipment?)? 'Добавить тему' : 'Подать объявление'}", :access => userCreateThemeInTopic?(topic), :type => 'plus', :link => "#{new_theme_path(:t => topic.id)}", :id => 'newTheme'},
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
    buttons[buttons.length] = {:name => "Непросмотренные[#{myNotVisitedThemes}]", :access => true, :type => 'b_grey', :link => topic_path(id: @topic.id, th_filter: 'not_visited'), selected: params[:th_filter] == 'not_visited'}
    buttons[buttons.length] = {:name => "Мои темы[#{myThemes}]", :access => true, :type => 'b_grey', :link => topic_path(id: @topic.id, th_filter: 'my'), selected: params[:th_filter] == 'my'}
    buttons[buttons.length] = {:name => "Отслеживаемые темы[#{myNtfThemes}]", :access => true, :type => 'b_grey', :link => topic_path(id: @topic.id, th_filter: 'ntf'), selected: params[:th_filter] == 'ntf'}
    if user_type == 'super_admin'
      delThemes = Theme.where(status_id: 2, topic_id: @topic.id).includes(:messages).size
      buttons[buttons.length] = {:name => "Удалённые темы[#{delThemes}]", :access => true, :type => 'b_grey', :link => topic_path(id: @topic.id, th_filter: 'deleted'), selected: params[:th_filter] == 'deleted'}
    end
    return buttons_in_line(buttons).html_safe
  end
  def is_cur_th_filter_mode_all?
    params[:th_filter] != 'not_visited' && params[:th_filter] != 'my' && params[:th_filter] != 'ntf' && (params[:th_filter] != 'deleted' && user_type == 'super_admin')
  end
	def topic_mini_block_as_list(topic)
		v = ''
		v += "#{link_to(topic.name, topic, :class => 'b_link_bold', :style => 'font-size: 16px;')} <br />"
		themes = topic.last_active_themes(is_not_authorized?, 2)
		entities_count = topic.entities_count(is_not_authorized?)
    v += topic_description(topic)
		v += topic_themes_big_table(themes)
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
	def topic_themes_big_table(themes)
			"
				<table class = 'v_table' id = 'themes_list'>
					<tr>
            <th id = 'first'>
            </th>
						<th>
							Заголовок
						</th>
						<th title = 'Дата создания темы'>
							Дата
						</th>
						<th>
							Автор крайнего сообщения
						</th>
						<th title = 'Дата крайнего сообщения в теме'>
							Дата
						</th>
						<th id = 'last'>
							Информация
						</th>
					</tr>
          #{build_rows(themes)}
				</table>
			"
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
  
  def topicEquipmentPartButtons
    if !@topic.is_not_equipment?
      current_part = @cur_equipment_part[:id]
      vStatus = (is_not_authorized?)? 1 : [1, 2]
      allActualThemes = @topic.themes.rewhere(status_id: 1, visibility_status_id: vStatus)
      buttons = [{:name => "Все актуальные[#{allActualThemes.size}]", :access => true, :type => 'b_grey', :link => topic_path(id: @topic.id), selected: current_part.nil?}]
      if user_type != 'guest' && user_type != 'new_user'
        curPartThemes = @topic.themes.rewhere(status_id: [1,3], visibility_status_id: [1,2], user_id: current_user.id)
        buttons[buttons.size] = {:name => "Мои[#{curPartThemes.size}]", :access => true, :type => 'b_grey', :link => topic_path(id: @topic.id, e_part: 100), selected: current_part == 100}
      end
      Theme.equipment_parts.each do |p|
        curPartThemes = @topic.themes.rewhere(status_id: 1, visibility_status_id: vStatus, equipment_part_id: p[:id])
        buttons[buttons.size] = {:name => "#{p[:name]}[#{curPartThemes.size}]", :access => true, :type => 'b_grey', :link => topic_path(id: @topic.id, e_part: p[:id]), selected: current_part == p[:id]}
      end
      curPartThemes = @topic.themes.rewhere(status_id: 1, visibility_status_id: vStatus, equipment_part_id: nil)
      buttons[buttons.size] = {:name => "Разное[#{curPartThemes.size}]", :access => true, :type => 'b_grey', :link => topic_path(id: @topic.id, e_part: 500), selected: current_part == 500}
      
      curPartThemes = @topic.themes.rewhere(status_id: 3, visibility_status_id: vStatus)
      buttons[buttons.size] = {:name => "Архив[#{curPartThemes.size}]", :access => true, :type => 'b_grey', :link => topic_path(id: @topic.id, e_part: 100500), selected: current_part == 100500}
      
      return buttons_in_line(buttons).html_safe
    else
      return ''
    end
  end
  
  def topic_description(topic=@topic)
   return "" if topic.description.blank?
   return "<p class = 'istring_m norm tb-pad-s'>#{topic.description}</p>"
  end
  
  def topic_index_mode
    mode = (cookies[:topic_index_mode] != 'thumbs' && cookies[:topic_index_mode] != 'list')? 'thumbs' : cookies[:topic_index_mode] 
    p_mode = (params[:t_view_mode] != 'thumbs' && params[:t_view_mode] != 'list')? nil : params[:t_view_mode]
    if !p_mode.nil?
      mode = p_mode
      cookies[:topic_index_mode] = mode
    end
    return [mode, "<a href = '/visota_life?t_view_mode=list' title = 'Показать разделы списком' class = 'th-view-mode' id = 'th-as-list'><i class = 'fi-list fi-large#{mode == 'list' ? ' fi-blue' : ' fi-grey'}'></i></a>  <a href = '/visota_life?t_view_mode=thumbs' title = 'Показать разделы миниатюрами' class = 'th-view-mode' id = 'th-as-thumbnails'><i class = 'fi-thumbnails fi-large#{mode == 'thumbs' ? ' fi-blue' : ' fi-grey' }'></i></a>"] 
  end
end
