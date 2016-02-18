class ActiveRecord::Base
 #categories-------
  def categories #в старой версии была отдельная таблица в базе
		[	
			{:value => 5, :name => 'Свободные полёты', :path_name => 'paragliding'},
			{:value => 4, :name => 'Моторные полёты', :path_name => 'power_paragliding'},
			{:value => 2, :name => 'Кайтинг', :path_name => 'kiting'},
			{:value => 3, :name => 'Клубные мероприятия', :path_name => 'club_events'},
			{:value => 1, :name => 'Разное', :path_name => 'another'}	
		]
  end
  
  def category_name
	  category[:name]
  end
  
  def cur_category_id
	category[:value]
  end
  def category_path
	category[:path_name]
  end
  def category
     cat = categories.last 
	categories.each do |group|
		cat = group if category_id == group[:value]
	end
   return cat
  end
  
  #статусы...  
  def statuses 
	[	
		{:id => 0, :value => 'draft', :ru => 'Черновик'},	  #черновики
		{:id => 1, :value => 'visible', :ru => 'Отображён'},  #отображенные
		{:id => 2, :value => 'hidden', :ru => 'Скрыт'},	  #скрытые
		{:id => 4, :value => 'to_delete', :ru => 'В удалённых'} #в очереди на удаление
	]
  end
  
  def status
	stat = 'draft'
	statuses.each do |s|
		stat = s[:value] if status_id == s[:id]
	end
	return stat
  end
  
  def status_ru
	stat = 'Не определён'
	statuses.each do |s|
		stat = s[:ru] if status_id == s[:id]
	end
	return stat
  end
#статусы end...
end
