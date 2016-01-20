#13.02.2014 - Добавлена функция my_collection_select(collection, list_name, form_name, base_item, prompt)
#14.02.2014 - Добавлена функция buttons_in_line([{},{}])
#26.03.2014 - select_topic_for_comments(c_id) соответствие категорий контента темам гостевой
#29.07.2014 - добавлена панелька для администратора

module ApplicationHelper
require 'open-uri' #для парсера

def authority_message
  "
    <div style = 'background-color: #417eb5; color: white;' class = 'm_1600wh'>
      <div class = 'm_1000wh tb-pad-s'>
        <i class = 'fi-alert fi-large'></i> Для того чтобы принять участие в общении, делиться фотографиями и видеозаписями - Вам необходимо <a style = 'font-size: 14px;' class = 'w_link_u' href = '/authorization'>авторизоваться</a>. 
      </div>
    </div>
  ".html_safe
end
def current_path
  request.env['PATH_INFO']
end
def oldMessagesPerPage
  25
end
def vk_like_vidget
  {
    script: '<script data-turbolinks-track="true" type="text/javascript" src="//vk.com/js/api/openapi.js?121"></script>
             <script data-turbolinks-track="true" type="text/javascript">
                VK.init({apiId: 5201088, onlyWidgets: true});
             </script>',
    button: '<div id="vk_like"></div>
             <script type="text/javascript">
               VK.Widgets.Like("vk_like", {type: "mini", verb: 1, height: 18});
             </script>' 
  }
end
def meta_content
  (@meta_content == nil)? "Круглогодичное обучение полетам на параплане, мотопараплане и кайтах. Помощь в выборе и приобретении снаряжения" : @meta_content
end
  def waitline(id)
    "
		<div style = 'display:none;' id = '#{id}' class = 'wl'>
			<div class = 'wl-item'>
			</div>
			<div class = 'wl-item'>
			</div>
			<div class = 'wl-item'>
			</div>
			<div class = 'wl-item'>
			</div>
			<div class = 'wl-item'>
			</div>
		</div>
    " 
  end 
	def alter_logo
		logo = "/img/main_page.jpg"
		logo = @alter_logo if @alter_logo != nil
		return "background-image: url(#{logo});background-size: cover;"
	end
	def header_1 #h1 тэг
		("<div class = 'm_1000wh tb-pad-m'><h1>#{@header}</h1></div>").html_safe if @header != nil 
	end
	def header_2 #h2 тэг
		("<h2>#{@title_2}</h2>").html_safe if @title_2 != nil
	end
	def js_functions 
		return @add_functions.html_safe if @add_functions != nil
	end
	def central_field_style #динамичный стиль для central_field
		style_hash = {:width => '1100px', :min_width => '1100px', :height => '700px'}
		if @cf_style != nil
			style_hash[:width] = @cf_style[:width] if @cf_style[:width] != nil 
			style_hash[:min_width] = @cf_style[:min_width] if @cf_style[:min_width] != nil 
			style_hash[:height] = @cf_style[:height] if @cf_style[:height] != nil 
		end
		return "style = 'width: #{style_hash[:width]}; min-width: #{style_hash[:min_width]}; height: #{style_hash[:height]};'"
	end
	
	def select_topic_for_comments(c_id)
		if c_id != nil
			if c_id == 4 or c_id == 5 #Свободные полёты и Моторные полеты в раздел Парапланеризм
				return 1
			elsif c_id == 2 #Кайтинг в кайтинг
				return 2
			elsif c_id == 1 or c_id == 3 #Клубные мероприятия в клубные мероприятия
				return 4
			elsif c_id == 1 #Разное в беседку
				return 3
			else 
				return 3
			end
		end
	end
	
	def my_title
		if @title != nil and @title != ''
			return @title
		else
			return '"ВЫСОТА"-Самарский Парапланерный Клуб'
		end
	end
  def topImageMainPage
    path = "/sliderImages/main_"
    arr = [1, 2]
    return {link: "#{path}#{arr.shuffle.first}.jpg", BlockHeight: 531}
  end
	def topImages
		path = "/sliderImages/"
		arr = [
				{link: "#{path}2.jpg", BlockHeight: 397},
				{link: "#{path}3.jpg", BlockHeight: 397},
				{link: "#{path}4.jpg", BlockHeight: 397},
				{link: "#{path}5.jpg", BlockHeight: 397},
        {link: "#{path}6.jpg", BlockHeight: 397},
        {link: "#{path}7.jpg", BlockHeight: 422},
        {link: "#{path}default.png", BlockHeight: 296}
			  ]
		return arr
  end

  def primaryMenuItems
	  [{
	   :name => 'О клубе', 
	   :link => "/about_us", 
	   :title => "История клуба",
	   :drop_items => 'none'
	  },
    {
    	   :name => 'Новости', 
    	   :link => "/events", 
    	   :title => "История клуба",
    	   :drop_items => 'none'
    	  },
	  {
	   :name => 'Обучение', 
	   :link => "/school", 
	   :title => "История клуба",
	   :drop_items => 'none'
	  },
	  {
	   :name => 'Снаряжение', 
	   :link => "/equipment", 
	   :title => "Снаряжение",
	   :drop_items => 'none'
	  },
    {
     :name => 'Контакты', 
     :link => "/contacts", 
     :title => "Контактная информация",
     :drop_items => 'none'
    },
    {
     :name => 'Медиа', 
     :link => "/media", 
     :title => "Фото и видео",
     :drop_items => 'none'
    },
	  {
	   :name => 'Общение', 
	   :link => "/visota_life", 
	   :title => "Фотографии, общение, видео",
	   :drop_items => 'none'
	  }
	]
  end
  def visota_life_buttons #buttons => {:name => 'Перейти', :title => "Перейти на страницу пилота", :access => ['all'], :type => 'b_green', :link => user_path(user)}
	user = User.new
	buttons_array = [
					 {:name => "Общение", :access => true, :type => 'b_grey', :link => '/communication'}, 
					 {:name => "Опросы", :access => true, :type => 'b_grey', :link => '/votes'}, 
					 {:name => "Фото альбомы", :access => true, :type => 'b_grey', :link => '/photo_albums'}, 
					 {:name => "Видео", :access => true, :type => 'b_grey', :link => '/videos'}, 
					 {:name => "Материалы", :access => true, :type => 'b_grey', :link => '/articles'}
					 ]
	buttons_array[@active_button][:selected] = true if @active_button != nil
	buttons_in_line(buttons_array)
  end
	def secondaryMenuItems
	[
					  {
					   :name => 'Новости', 
					   :link => "/events", 
					   :title => "Новости",
					   :drop_items => 'none'
					  },
					  {
					   :name => 'Фото', 
					   :link => "/photo_albums", 
					   :title => "Фотоальбомы",
					   # :links_list => [
										# {:name => 'Свободные полёты', :link => "/photo_albums?category=paragliding"},
										# {:name => 'Моторные полёты', :link => "/photo_albums?category=power_paragliding"},
										# {:name => 'Кайтинг', :link => "/photo_albums?category=kiting"},
										# {:name => 'Клубные мероприятия', :link => "/photo_albums?category=club_events"},
										# {:name => 'Разное', :link => "/photo_albums?category=another"}
									   # ],
						:link_list_width => '170px',
						:id => 'nav_photos',
						:drop_items => 'none'
					  },
					  {
					   :name => 'Видео', 
					   :link => "/videos", 
					   :title => "Видеоматериалы",
					   # :links_list => [
										# {:name => 'Свободные полёты', :link => "/videos?category=paragliding"},
										# {:name => 'Моторные полёты', :link => "/videos?category=power_paragliding"},
										# {:name => 'Кайтинг', :link => "/videos?category=kiting"},
										# {:name => 'Клубные мероприятия', :link => "/videos?category=club_events"},
										# {:name => 'Разное', :link => "/videos?category=another"}
									   # ],
						:link_list_width => '170px',
						:id => 'nav_videos',
						:drop_items => 'none'
					  },
					  {
					   :name => 'Общение', 
					   :link => "/visota_life", 
					   :title => "в прошлом Гостевая",
					   :links_list => topic_link_list,
					   :link_list_width => '170px',
					   :id => 'nav_topics',
					   :drop_items => 'none'
					  },
					  {
					  :name => 'Материалы', 
					   :link => "/articles", 
					   :title => "Отчёты, Отзывы, Документация, полезные ссылки",
					   #:links_list => [
										# {:name => 'Отчёты', :link => '/reports'},
										# {:name => 'Статьи', :link => '/club_articles'},
										# {:name => 'Отзывы', :link => '/reviews'},
										# {:name => 'Отчёты о ЛП', :link => '/flight_accidents'},
										# {:name => 'Восставшие из руин', :link => '/risen_from_the_ruin'},
										# {:name => 'Документы', :link => '/documents'}
									   # ],
						:link_list_width => '170px',
						:id => 'nav_materials',
					  :drop_items => 'none'
					 }
					 ]
	end
	def user_session_menu
			b = [
					#{:name => 'Лента событий', :link => '/feed'},
          {:name => 'Погода', :link => '/wheather'},
          {:name => 'Пилоты', :link => '/pilots'},
					{:name => 'Профиль', :link => user_path(current_user)}
			    ]
		v = ''
		b.each do |i|
			v += (current_page?(i[:link]))? "<li id = 'c_nav_li' link_to = '#{i[:link]}'>#{i[:name]}</li>" : "<li link_to = '#{i[:link]}'>#{i[:name]}</li>"
		end
		return "<ul id = 'userMenu'>#{v}</ul>"
	end
	def topMainMenu #меню в шапке сайта
		value = ""
		primaryMenuItems.each do |item|
			value += "<a href = '#{item[:link]}'><li id = '#{is_selected(item)}'><span>#{item[:name]}</span></li></a>"
		end
		return "<ul>#{value}</ul>"
	end
	def bottomMainMenu
		value = ""
		primaryMenuItems.each do |item|
			value += "<a href = '#{item[:link]}'><li><span>#{item[:name]}</span></li></a>"
		end
		
		return "<ul>#{value}</ul>"
  end
	def is_selected(item)
			if @curMenuItem == item[:name] || current_page?(item[:link])
				return 'c_nav_li' 
			end
	end
  
	def menu_drop_list(item) #Формирует выпадающие списки основного меню.
		value = ''
		if item[:links_list] != nil and item[:links_list] != []
			item[:links_list].each do |sub_item|
				value += "<a style = 'text-decoration: none;' href = '#{sub_item[:link]}'><li style = 'display: block; font-size: 12pt;' class = 's_nav_li'>#{sub_item[:name]}</li></a>"
			end
		end
		return "<div style = 'display: none; width: #{item[:link_list_width]};' class = 'menu_drop_list'><ul>#{value}</ul></div>"
	end
#slider
	def topSlider
		"
						<div class='slider'>
						<ul>
							<li><img src='/sliderImages/1.jpg' alt=''></li>
							<li><img src='/sliderImages/2.jpg' alt=''></li>
							<li><img src='/sliderImages/3.jpg' alt=''></li>
						</ul>
						</div>"
	end
	
#slider end
	def topic_link_list #Формирует массив для формирования выпадающего списка.
		val_arr = []
		topics = Topic.all(:order => 'name ASC')
		topics.each do |topic|
			val_arr[val_arr.length] = {:name => topic.name, :link => topic_path(topic)}
		end
		val_arr[val_arr.length] = {:name => 'Старая гостевая', :link => '/old_messages'}
		return val_arr
	end
	
  def my_notice
    if notice != nil && notice != ''
    "
     <div class = 'notice'> 
         <div class = 'm_1000wh'>
             <p id='notice' class = 'tb-pad-s'>#{notice}</p>
         </div>
     </div>
    ".html_safe
    else
      ''
    end
  end
  def my_alert
    if flash[:alert] != nil && flash[:alert] != ''
    "
     <div class = 'alert'> 
         <div class = 'm_1000wh'>
             <p id='alert' class = 'tb-pad-s'>#{flash[:alert]}</p>
         </div>
     </div>
    ".html_safe
    else
      ''
    end
  end
  def whoIsOnlineMenu    
    if signed_in?
      signedTxt = ""
      stps = Step.users_online
      stps[:signed] -= [current_user]
      signedTxt = "<span class = 'istring_m'>Сейчас на сайте#{' только' if stps[:signed].size == 0 && stps[:unsigned] == 0}</span> <span style = 'font-size: 12px;' class = 'bi-string'>Вы</span>"
      if stps[:signed].size > 0
        stps[:signed].each do |u|
          signedTxt += (stps[:signed].last == u)? " <span class = 'istring_m'>и</span> " : "<span class = 'istring_m'>,</span> "
          signedTxt += link_to u.name, u, class: 'b_link_i'
        end
      end
      if stps[:unsigned] > 0
        signedTxt += (stps[:signed].size == 0)? " <span class = 'istring_m'>и</span> " : " <span class = 'istring_m'>, а также</span> "
        signedTxt += (stps[:unsigned] == 1)? "<span style = 'font-size: 12px;' class = 'bi-string'>Гость</span>" : "<span style = 'font-size: 12px;' class = 'istring_m'>#{stps[:unsigned]}</span> <span style = 'font-size: 12px;' class = 'bi-string'>Гостей</span>" 
      end
      return "<div class = 'c_box even'><div class = 'm_1000wh tb-pad-s'>#{signedTxt}</div></div>".html_safe
    else
      return ""
    end
    
    #if signed.size > 0
    #  if signed.size == 1 
   # end
    #<% stps = Step.users_online %>
    # 
    #    <div class = 'm_1000wh tb-pad-s'>
    #        <% stps[:signed].each do |u| %>
    #            <%=link_to u.name, u, class: "b_link_i"%>
    #        <% end %> | <span class = 'istring_m'>Гостей:(<%= stps[:unsigned] %>)</span>
    #    </div>
    #</div>
  end
	def wheather_panel
	"
		<div id = 'wheather_panel' class = 'wheather_panel'>
			<div  id = 'wheather_button' align = 'center'  class = 'wheather_link'>
				<b><a style = 'position: relative;'><img src = '/files/wheather.png' style = 'height: 80px; padding-top: 5px;'></a></b>
			</div>
			<div id = 'wheather' style = 'display: block;' class = 'wheather_content'>
					<div id = 'wheather_blocks' style = 'text-align: center; height: 100%; margin-left: 10px; padding-right: 5px; display: none; position: relative;'>
							<br />
							<a class = 'b_link' target = '_blank' href = 'http://rp5.ru/7259/ru'><b>Самара</b></a>
							<br />
							<EMBED src='http://rp5.ru/informer/100x100/1/17.swf' loop=false menu=false quality=high scale=noscale wmode=transparent bgcolor=#CCCCCC flashvars='id=7259&lang=ru&um=00000' WIDTH='100' HEIGHT='100' NAME='loader' ALIGN='' TYPE='application/x-shockwave-flash' PLUGINSPAGE= 'http://www.macromedia.com/go/getflashplayer'></EMBED>
					</div>
					<div id = 'wheather_blocks' style = 'text-align: center; height: 100%; display: none; position: relative; padding-right: 5px;'>
							<br />
							<a class = 'b_link' target = '_blank'  href = 'http://rp5.ru/123798/ru'><b>Б. Раковка</b></a><br />
							<br />
							<EMBED src='http://rp5.ru/informer/100x100/1/17.swf' loop=false menu=false quality=high scale=noscale wmode=transparent bgcolor=#CCCCCC flashvars='id=123798&lang=ru&um=00000' WIDTH='100' HEIGHT='100' NAME='loader' ALIGN='' TYPE='application/x-shockwave-flash' PLUGINSPAGE= 'http://www.macromedia.com/go/getflashplayer'></EMBED>
					</div>
					<div id = 'wheather_blocks' style = 'text-align: center; height: 100%; display: none; position: relative; padding-right: 5px;'>
						<a href='http://6.pogoda.by/28807' title='Прогноз атмосферного давления,скорости и направления ветра по данным UKMET. Самара' target='_blank'>
						<img src='http://pogoda.by/mg/366/egrr_W28807.gif' width='366' height='100' border='1' alt='График элементов погоды P, Ws, Wa г. Самара прогноз на 126 ч.'></a>
					</div>
					<div id = 'wheather_blocks' style = 'height: 100%; display: none; position: relative; width: 140px; '>
							<a class = 'b_link' target = '_blank' href = 'http://meteo.paraplan.net/forecast/summary.html?place=4954'><b>Подробный прогноз по Самаре</b></a> <hr />
							<a class = 'b_link' target = '_blank' href = 'http://meteoinfo.by/radar/?q=RUSM&t=10'><b>Радиолокационная карта метеоявлений</b></a><br><br>
					</div>
			</div>
		</div>
	"
	end
	def my_collection_select(collection, list_name, form_name, base_item, prompt) #структура collection [{:value => integer, :name => string}]
		if collection != {} and collection != nil and list_name != nil and list_name != '' and form_name != nil and form_name != ''
			options = ""
			options += "<option value = ''>#{prompt}</option>" if prompt != '' and base_item == {}
			options += "<option value = '#{base_item[:value]}'>#{base_item[:name]}</option>" if base_item != {}
			collection.each do |item|
				options += "<option value = '#{item[:value]}'>#{item[:name]}</option>" if item != base_item
			end
			return ("<select class = 'c_select' id = '#{form_name}_#{list_name}' name = '#{form_name}[#{list_name}]'>#{options}</select>").html_safe
		else
			return ("<select class = 'c_select'><option>Пусто</option></select>").html_safe
		end
	end
#Блок отрисовки кнопок----------------------------------------------------------
def draw_in_line(buttons) #buttons => {:name => 'Перейти', :title => "Перейти на страницу пилота", :access => ['all'], :type => 'b_green', :link => user_path(user)}
	value = ""
	if @active_button != nil
		buttons[@active_button][:selected]
	end
	if buttons != nil and buttons != []
		buttons.each do |button|
			if button[:access] == true
				button[:type] = 'c_loc_li' if button[:selected] == true
				value += "<a #{button_attrs(button)}><li id = '#{button[:type]}'>#{button[:name]}</li></a>"
			end
		end
	end
	return value
end

def buttons_in_line(buttons) 
  "<ul class = 'l_menu'>#{draw_in_line(buttons)}</ul>"
end

def buttons_in_line_b(buttons) 
  "<ul class = 'l_menu_b'>#{draw_in_line(buttons)}</ul>"
end

def button_attrs(button)
	val = ''
	val += "href = '#{button[:link]}'" if button[:link] != '' and button[:link] != nil
	val += "data-confirm = '#{button[:data_confirm]}'" if button[:data_confirm] != '' and button[:data_confirm] != nil
	val += "data-method = '#{button[:data_method]}'" if button[:data_method] != '' and button[:data_method] != nil
	val += "rel = '#{button[:rel]}'" if button[:rel] != '' and button[:rel] != nil
	val += "onclick = '#{button[:onclick]}'" if button[:onclick] != '' and button[:onclick] != nil
	val += "id = '#{button[:id]}'" if button[:id] != '' and button[:id] != nil
	val += "title = '#{button[:title]}'" if button[:title] != '' and button[:title] != nil
	val += "name = '#{button[:e_name]}'" if button[:e_name] != '' and button[:e_name] != nil
	val += "alt = '#{button[:alt]}'" if button[:alt] != '' and button[:alt] != nil
	val += "data-remote = '#{button[:remote]}'" if button[:remote] != '' and button[:remote] != nil
	val += "data-value = '#{button[:value]}'" if button[:value] != '' and button[:value] != nil
	return val
end

def control_buttons(buttons)
	value = ""
	if buttons != nil and buttons != []
		buttons.each do |button|
			if button[:access] == true
				button[:type] = 'c_loc_li' if button[:selected] == true
				value += "<a #{button_attrs(button)}><li>"
				value += "<div style = 'padding-right: 5px;' class = 'fi-float-left'>#{drawIcon(button[:type], 'medium', 'blue')}</div>" if button[:type] != nil and button[:type] != ''
				value += "#{button[:name]}</li></a>"
			end
		end
		value = "<div id = 'cButWrapper' ><ul class = 'ctrl_but'>#{value}</ul></div>" if value != ""
	end
	return value
end
#icons-draw
def drawIcon(name, size, color)
  "<i class = 'fi-#{name} fi-#{size} fi-#{color}'></i>"
end
#icons end
#my_search engine


def themes_search(p)
	themeParams = p[:th]
	themes = []
	if themeParams != nil and themeParams != []
	else
		return themes
	end
end
def isLikebleText?(dwnCaseText, qText)
	i = 0
	p = 0.0
	arr = dwnCaseText.mb_chars.split(/\s/)
	arr_2 = qText.mb_chars.split(/\s/)
	if arr.length > 0
		arr.each do |s|
			arr_2.each do |qS|
				i+= 1 if s.mb_chars.index(qS) != -1 and s.mb_chars.index(qS) != nil and qS.mb_chars.length > 3 #ищем в тексте совпадения
			end
		end
	end
	p = (i.to_f)/(arr_2.length.to_f)*100 #определяем процент совпадений
	return true if p > 30
	return false
	#todo
end
#my_search engine end
# def button_accessed?(access_list)
	# enable = false
	# if user_type != 'guest'
		# enable = true if access_list.index(user_type) != nil || access_list.index(current_user.id) != nil || access_list[0] == 'all'
	# else
		# enable = true if access_list[0] == 'all' || access_list.index(user_type) != nil
	# end
	
	# return enable
# end


#Блок отрисовки кнопок end------------------------------------------------------
  def mySubmitButton(text, elId)
    "
      <ul class = 'myBut'>
          <li id = '#{elId}_button' onclick = 'submitMyForm(\"#{elId}\", this)'>
            #{text}
          </li>
      </ul>
    "
  end 
  
  def myLinkButton(text, link)
    "
      <ul class = 'myBut'>
          <a href='#{link}'>
          <li>
            #{text}
          </li>
          </a>
      </ul>
    "
  end
	def my_time(date)
		time = Time.now
		value = ''
		if time.year == date.year and time.month == date.month
			days_difference = time.day - date.day
			if days_difference == 0
				value = date.strftime("в %H:%M")
			elsif days_difference == 1 
				value = date.strftime("Вчера")
			elsif days_difference == -1 
				value = date.strftime("Завтра")
			elsif days_difference < -1 
				value = "#{date.strftime("%d #{ru_month(date.month.to_i, 'rod_padej')}")}"
			elsif days_difference > 1 
				value = "#{date.strftime("%d #{ru_month(date.month.to_i, 'rod_padej')}")}"
			end
		elsif time.year == date.year and time.month != date.month
			value = "#{date.strftime("%d #{ru_month(date.month.to_i, 'rod_padej')}")}"
		elsif time.year != date.year
			value = "#{date.strftime("%d.%m.%Y")}"
		end
		return value
	end
	
	def ru_month(m, type) #type == partial or full or родительный падеж
		value = ''
		month_array = [
						[1, 'Январь', 'Янв.', 'Января'],
						[2, 'Февраль', 'Фев.', 'Февраля'],
						[3, 'Март', 'Мар.', 'Марта'],
						[4, 'Апрель', 'Апр.', 'Апреля'],
						[5, 'Май', 'Май', 'Мая'],
						[6, 'Июнь', 'Июн.', 'Июня'],
						[7, 'Июль', 'Июл.', 'Июля'],
						[8, 'Август', 'Авг.', 'Августа'],
						[9, 'Сентябрь', 'Сент.', 'Сентября'],
						[10, 'Октябрь', 'Окт.', 'Октября'],
						[11, 'Ноябрь', 'Ноя.', 'Ноября'],
						[12, 'Декабрь', 'Дек.', 'Декабря']
					  ]
		month_array.each do |month|
			value = month[1] if month[0] == m and type == 'full'
			value = month[2] if month[0] == m and type == 'partial'
			value = month[3] if month[0] == m and type == 'rod_padej'
		end
	return value
  end
  
  	
  #smiles_part
  def smiles_draw
	smiles_count = 34
	onclick = 'presssmile(this)'
	smiles_path = '/smiles/'
	value = ''
	i = 0
	begin
		i += 1
		value += "<img class = 'smiles' src='#{smiles_path}#{i}.gif' title='' smilecode ='*sm#{i}*' onclick='#{onclick}'>"
	end until(i == smiles_count)
	return ("<div class = 'smiles_field'>#{value}</div>").html_safe
  end
  #smiles_part end
  
  
  def hidden_object_count
	themes = Theme.find_all_by_status_id(2)
	messages = Message.find_all_by_status_id(2)
	photos = Photo.find_all_by_status_id(2)
	return themes.count + messages.count + photos.count
  end
  
  def deleted_object_count
	themes = Theme.find_all_by_status_id(3)
	messages = Message.find_all_by_status_id(3)
	photos = Photo.find_all_by_status_id(3)
	return themes.count + messages.count + photos.count
  end
  def disabled_events_count
	events = Event.find_all_by_status_id(1)
	return events.count.to_s
  end

#Основные блоки
	# def main_entity_block(p)
		# ("
		
		# ")
	# end
	def c_box_block(p) #p = {:tContent => '', :fContent =>'', :classLvl_1 => '', :idLvl_1 => '', :classLvl_2 => '', :idLvl_2 => '', :classBg => '', :parity => integer}
		parity = '' 
		if p[:parity] != nil
			parity = ' odd' if p[:parity].odd?
			parity = ' even' if p[:parity].even?
		end
		val = ""
		tContent = ""
		fContent = ""
		bg = ""
		tContent = "<div class = 'm_1000wh#{" "+p[:classLvl_2] if p[:classLvl_2] != nil}'#{" id='#{p[:idLvl_2]}'" if p[:idLvl_2] != nil}>#{p[:tContent]}</div>" if p[:tContent] != nil
		fContent = p[:fContent] if p[:fContent] != nil
		bg = "<div class='#{p[:classBg]}'></div>" if p[:classBg] != nil
		val = "
				<div class = 'c_box#{" "+p[:classLvl_1] if p[:classLvl_1] != nil}#{parity}'#{" id='#{p[:idLvl_1]}'" if p[:idLvl_1] != nil}>
					#{bg}#{tContent}#{fContent}					
				</div>
			  "
		return val
	end

  def navigation_string #Навигационная строка 
	value = ''
	@path_array.each do |path|
		value += " <span id = 'splitter'><i class = 'fi-arrow-right'></i></span> " if @path_array.first != path
		value += "#{link_to truncate(path[:name], :length => 50), path[:link], :title => path[:name], :class => 'b_link', :id => 'first'}" if @path_array.first == path
		value += "#{link_to truncate(path[:name], :length => 50), path[:link], :title => path[:name], :class => 'b_link'}" if path != @path_array.last and @path_array.first != path
		value += "<span id = 'cur_path'>#{truncate(path[:name], :length => 50)}</span>" if path == @path_array.last
	end
	return "<div class = 'nav_string'>#{value}</div>"
  end
#Основные блоки	end


end
