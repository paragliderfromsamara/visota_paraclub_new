module ThemesHelper
	def hidden_check_box(f)
		return "#{ f.hidden_field :visibility_status_id, :value => 1}"	if is_not_authorized?  
		return "<br />#{ f.label :visibility_status_id, ('<i class = "fi-shield fi-grey fi-medium"></i> Скрыть от не авторизованных пользователей').html_safe} #{ f.check_box :visibility_status_id, {:class=>'check_box'}, '2', '1'}<br />" if !is_not_authorized?
	end
	def themes_table(themes, ads = @ads)
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
          #{"<tr><th class = 'splitter' colspan = 6 >Закреплённые темы</th></tr>#{build_rows(ads)}" if !ads.blank?}
					<tr><th class = 'splitter' colspan = 6>#{themesFilterHash[:cat_name] }</th></tr>
          #{build_rows(themes)}
				</table>
			"
	end
  def view_mode_themes_list
    if session[:themes_list_type] == nil
      session[:themes_list_type] = (params[:themes_list_type] == nil)? "thumbs" : params[:themes_list_type]
    else
      session[:themes_list_type] = (params[:themes_list_type] == nil)? session[:themes_list_type] : params[:themes_list_type]
    end
    if controller.controller_name == 'topics' && controller.action_name == 'show'
      link = ["#{topic_path(id: @topic.id, themes_list_type: 'list')}#{"&page=#{params[:page]}" if !params[:page].nil?}#{"&th_filter=#{params[:th_filter]}" if !params[:th_filter].nil?}", "#{topic_path(id: @topic.id, themes_list_type: 'thumbs')}#{"&page=#{params[:page]}" if !params[:page].nil?}#{"&th_filter=#{params[:th_filter]}" if !params[:th_filter].nil?}"]
    else
      link = ["#{themes_path(themes_list_type: 'list')}#{"&page=#{params[:page]}" if !params[:page].nil?}#{"&th_filter=#{params[:th_filter]}" if !params[:th_filter].nil?}", "#{themes_path(themes_list_type: 'thumbs')}#{"&page=#{params[:page]}" if !params[:page].nil?}#{"&th_filter=#{params[:th_filter]}" if !params[:th_filter].nil?}"]
    end
	  "<a href = '#{link[0]}' class = 'th-view-mode' data-remote = 'true' id = 'th-as-list'><i class = 'fi-list fi-large#{session[:themes_list_type] == 'list' ? ' fi-blue' : ' fi-grey'}'></i></a>  <a href = '#{link[1]}' class = 'th-view-mode' data-remote = 'true' id = 'th-as-thumbnails'><i class = 'fi-list-thumbnails fi-large#{session[:themes_list_type] == 'thumbs' ? ' fi-blue' : ' fi-grey' }'></i></a>"
  end
	def build_rows(themes)
		rows = ''
    if themes.size != 0
  		themes.each do |th|
        thReadInfo = th.theme_read_info(current_user)
        last_msg = thReadInfo[:last_message]
  			rows += "<tbody class = 't_link' link_to = '#{thReadInfo[:link]}' title = '#{th.name}'>"
  			rows += '<tr>'
        rows += "<td id = 'first' class = 'new_msg_counter'>#{thReadInfo[:info]}</td><td class = 't_name'>#{truncate(th.name, :length => 45)}</td><td class = 'date'>#{my_time(th.created_at)}</td>"
  			if last_msg != nil
  				rows += "<td>#{last_msg.user.name}</td><td class = 'date'>#{my_time(last_msg.created_at)}</td>"
  			else
  				rows += "<td class = 'usr'>#{th.user.name}</td><td class = 'date'>#{my_time(th.created_at)}</td>"
  			end
  			rows += "<td class = 'stat' valign = 'top' id = 'last'>#{themeInformation(th)}</td>"
  			rows += '</tr>'
  			rows += "</tbody>"
  		end
    else
      rows += "<tr><th class = 'no-entities' colspan = 6 ><p class = 'istring norm tb-pad-m medium-opacity'> #{themesFilterHash[:empty_msg]}</p></th></tr>"
    end
		return rows
	end
  
	def themeInformation(theme)
		mCount = (@messages == nil)? theme.messages.size : @messages.size 
        h = theme.statusHash
		vh = theme.vStatusHash
		v = ''
		v += "<div class='stat fi-float-left' title = '#{vh[:ru]}'>#{drawIcon(vh[:img], 'medium', 'grey')}</div>" if vh[:value] == 'hidden'
		v += "<div class='stat fi-float-left' title = '#{h[:ru]}'>#{drawIcon(h[:img], 'medium', 'grey')}</div>"
		v += "<div class='stat fi-float-left'>#{drawIcon('comments', 'medium', 'grey')}<span>#{mCount}</span></div>"
		v += "<div class='stat fi-float-left'>#{drawIcon('eye', 'medium', 'grey')}<span>#{theme.views}</span></div>"
    v += "<div class='stat fi-float-left'>#{drawIcon('graph-bar', 'medium', 'grey')}</div>" if !theme.vote.nil?
		return v
	end
	def theme_show_block(showBut)
		showBut = false if params[:but] == 'false'
		html = theme_body(@theme, showBut)
		p = {
				:tContent => html, 
				:idLvl_2 => 'thBody',
        :idLvl_1 => "t_#{@theme.id}",
				:classLvl_2 => 'tb-pad-m',
				:parity => 0
			}
		return c_box_block(p)
	end
  def themes_list_item(theme, i)
    v = ''
    bottom_links = control_buttons([{:name => 'Перейти к теме', :access => userCanSeeTheme?(theme), :type => 'arrow-right',  :link => "/themes/#{theme.id}"}])
		p = {
				:tContent => "<h3 class = 'tb-pad-s'>#{theme.name}</h3>" + theme_body(theme, false) + bottom_links, 
				:classLvl_1 => 'mainEntity', 
				:classLvl_2 => 'tb-pad-m',
				:parity => i
			}
		return c_box_block(p)  
  end
	def theme_body(theme, showBut)
		"<table style = 'width: 100%;'>
			<tr>
				<td valign = 'middle' align = 'left'  style='height: 45px;'>
					#{themeInformation(theme)} #{"<span class = 'istring medium-opacity'>(#{theme.status(:ru)})<span>" if user_type == 'super_admin' && theme.status_id == 2}
				</td>
				<td valign = 'middle' align = 'right' style='height: 45px;'>
					<p class = 'istring_m norm'>Тема создана #{my_time(theme.created_at)}</p>
				</td>
			</tr>
			<tr>
				<td valign = 'middle' align = 'left' colspan = '2'>
					<span class = 'istring_m norm'>Автор темы: </span>#{link_to theme.user.name, theme.user, :class => 'b_link_i'}
				</td>
			</tr>
			<tbody id = 'middle'>
				<tr>
				<td  colspan = '2'>
						<div id = 'content' class = 'mText'>#{theme.content_html}</div>
						#{theme.updater_string}
            #{"<div id = 'vtValues'>#{vote_values_table(theme.vote)}</div>" if !theme.vote.nil?}
						#{"<br /><div class = 'central_field' style = 'width: 1000px;' id ='thPhotosField'>#{theme_list_photos(theme)}</div>" if theme.photos != []}
						#{"<br />#{list_attachments(theme.attachment_files)}" if theme.attachment_files != []}
				</td>
				</tr>
			</tbody>
			<tr>
				<td colspan = '2'>
					<div>
						#{theme_owner_buttons if showBut == true and !params[:preview_mode]}
					</div>
				</td>
			</tr>
		</table>		
		"
	end
  
  def themesFilterHash
    if @topic.is_not_equipment?
      if params[:th_filter] == 'my'
        {empty_msg: 'В разделе нет ни одного созданной Вами темы...', cat_name: 'Мои темы'}
      elsif params[:th_filter] == 'not_visited'     
        {empty_msg: 'В разделе нет ни одной непросмотренной Вами темы...', cat_name: 'Непросмотренные темы'}
      elsif params[:th_filter] == 'ntf'
        {empty_msg: 'В разделе нет ни одной отслеживаемой Вами темы...', cat_name: 'Отслеживаемые темы'}
       
      elsif params[:th_filter] == 'deleted' && user_type == 'super_admin'
        {empty_msg: 'В разделе нет ни одной удалённой темы...', cat_name: 'Удалённые темы'}
      else
        {empty_msg: 'В разделе нет ни одной темы...', cat_name: 'Все темы'}
      end
    else
      #to_do
      {empty_msg: 'В категории нет ни одного объявления...', cat_name: @cur_equipment_part[:name]}
    end
  end
  
	def theme_owner_buttons #в контроллере themes#show
		buttons_array = []
		buttons_array += [{:name => 'Новое сообщение', :access => userCanCreateMsgInTheme?(@theme), :type => 'comment', :id => 'newMsgBut'}]
		buttons_array += [themeNotificationButton(@theme.id)] if signed_in? and user_type != 'deleted'  && @theme.status_id != 2
		buttons_array += [
							        {:name => "Редактировать", :access => userCanEditTheme?(@theme) && @theme.status_id != 2, :type => 'pencil', :link => "#{edit_theme_path(@theme)}", :id => 'editTheme'}
						         ]
		buttons_array[buttons_array.length] = {:name => 'Объединить с...', :access => is_super_admin? && @theme.status_id != 2, :type => 'shuffle', :link => theme_path(@theme) + "/merge_themes", :title => "Объединить с другой темой", :id => 'mergeTheme'}
		buttons_array[buttons_array.length] = {:name => 'Закрыть тему', :access => userCanSwitchTheme?(@theme) && @theme.status_id != 2, :type => 'lock',  :link => "/themes/#{@theme.id}/theme_switcher?to_do=close", :rel => 'nofollow', :id => 'themeClose'}  if @theme.status != 'closed'
		buttons_array[buttons_array.length] = {:name => 'Открыть тему', :access => userCanSwitchTheme?(@theme) && @theme.status_id != 2, :type => 'unlock',  :link => "/themes/#{@theme.id}/theme_switcher?to_do=open", :rel => 'nofollow', :id=> 'themeOpen'} if @theme.status != 'open'
		buttons_array[buttons_array.length] = {:name => 'Удалить', :access => userCanSwitchTheme?(@theme), :type => 'trash', :link => theme_path(@theme), :rel => 'nofollow', :data_confirm => 'Вы уверены что хотите удалить тему?', :data_method => 'delete', :id=> 'deleteTheme'} if @theme.status != 'closed' || @theme.status != 'open'
		buttons_array[buttons_array.length] = {:name => 'Восстановить', :access => is_super_admin? && @theme.status_id == 2, :type => 'refresh', :link => "/themes/#{@theme.id}/recovery", :rel => 'nofollow', :data_confirm => 'Вы уверены что хотите восстановить тему?', :id=> 'recoveryTheme'} if @theme.status != 'closed' || @theme.status != 'open'
    buttons_array[buttons_array.length] = {:name => 'Создать статью из темы', :access => is_admin? && @theme.status_id != 2, :type => 'book-bookmark', :link => theme_path(@theme) + '/make_article'}
		buttons_array[buttons_array.length] = {:name => 'Создать фотоальбом из темы', :access => @theme.all_photos_in_theme.size > 3 && @theme.status_id != 2 , :type => 'photo', :link => theme_path(@theme) + '/make_album'} if is_admin?
    return control_buttons(buttons_array).html_safe
	end
	def is_form_for_ads?
    userCanCreateAds? and params[:add_ads] == 'true'
  end
	def theme_errors
		@content_error = ''
		@content_f_color = ''
		@name_error = ''
		@name_f_color = ''
		if @formTheme.errors[:content] != [] and @formTheme.errors[:content] != nil
			@content_f_color = "err"
			@formTheme.errors[:content].each do |err|
				@content_error += "#{err}; <br />"
			end
		end
		if @formTheme.errors[:name] != [] and @formTheme.errors[:name] != nil
			@name_f_color = "err"
			@formTheme.errors[:name].each do |err|
				@name_error += "#{err}; <br />"
			end
		end
	end
end
