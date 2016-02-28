require 'test_helper'

class ThemeTest < ActiveSupport::TestCase
  test "Тест основных валидаций темы" do
	themeWithLongName = Theme.new(:name => 'Новая тема с именем более ста символов. Новая тема с именем более ста символов. Новая тема с именем более ста символов',
						:content => "Новая тема с именем более ста символов",
						:status_id => 1,
						:topic_id => 1,
						:visibility_status_id => 1,
						:user_id => 20)
	
	assert(!themeWithLongName.save, "Удалось сохранить тему выше ограничения") 
	
	themeNormal = Theme.new(	:name => 'Тест на сохранение нормальной темы',
								:content => "Новая тема с именем более ста символов",
								:topic_id => 1,
								:status_id => 1,
								:visibility_status_id => 1,
								:user_id => 20)
	assert(themeNormal.save, "Не удалось сохранить тему: #{themeNormal.errors.each {|err| err.each {|m| "#{m}; "}}}") 
  
	themeWithoutName = Theme.new(	:name => '',
						:content => "Тест на сохранение темы без заголовка",
						:topic_id => 1,
						:status_id => 1,
						:visibility_status_id => 1,
						:user_id => 20)
	
	assert(!themeWithoutName.save, "Удалось сохранить тему без заголовка") 
  
    themeWithoutContent = Theme.new(:name => 'Тест на сохранение темы без содержимого',
									:content => "",
									:topic_id => 1,
									:status_id => 1,
									:visibility_status_id => 1,
									:user_id => 20)
	
	assert(!themeWithoutContent.save, "Удалось сохранить тему без содержимого")
    
	
	themeLongContent = Theme.new(	:name => 'Тест на сохранение темы с длинным содержимым',
						:content => "#{overMaxThemeContent}",
						:topic_id => 1,
						:status_id => 1,
						:visibility_status_id => 1,
						:user_id => 20)
	
	assert(!themeLongContent.save, "Тест на сохранение темы с длинным содержимым") 
  
	themeWithoutContentButWithPhotos = Theme.create(	:name => 'Тест на сохранение темы без содержимого, но с фотографиями',
												  :content => '',
													:topic_id => 1,
													:status_id => 0,
													:visibility_status_id => 1,
													:user_id => 15)
  photo = photos(:defaultPhoto1)
  themeWithoutContentButWithPhotos.entity_photos.create(photo_id:photo.id)
  themeWithoutContentButWithPhotos = Theme.find(themeWithoutContentButWithPhotos.id)
	assert(themeWithoutContentButWithPhotos.update_attributes(status_id:1), "Тест на сохранение темы без содержимого, но с фотографиями ПРОВАЛЕН") 
  
	theme1 = Theme.new(	:name => 'Тема с одинаковым названием',
						:content => "Тема с одинаковым название",
						:topic_id => 1,
						:status_id => 1,
						:visibility_status_id => 1,
						:user_id => 20)
						
	theme2 = Theme.new(	:name => 'Тема с одинаковым названием',
						:content => "Тема с одинаковым названием",
						:topic_id => 1,
						:status_id => 1,
						:visibility_status_id => 1,
						:user_id => 15)
						
	assert(!(theme1.save&&theme2.save), "Удалось сохранить две темы с одинаковыми названиями") 
  end
	  
  test 'Тест на изменение флага видимости темы' do 
	u = users(:club_friend)
	themeByClubFriend = Theme.new(
								:name => 'Тест флага видимости',
								:content => 'Тема для теста изменения флага видимости...',
								:status_id => 1, 
								:user_id => u.id,
								:topic_id => 1
								)
	assert(themeByClubFriend.save, "Не удалось сохранить тему: #{themeByClubFriend.errors.each {|err| err.each {|m| "#{m}; "}}}") 
    themeByClubFriend = Theme.find_by_name('Тест флага видимости')
	assert(themeByClubFriend.visibility_status_id == 1, "Visibility_status_id равный null после сохранения не стал равный 1") 
    themeByClubFriend.set_as_hidden
	themeByClubFriend = Theme.find_by_name('Тест флага видимости')
	assert(themeByClubFriend.visibility_status_id == 2, "Visibility_status_id после вызова set_as_hidden не стал равный 2") 
    themeByClubFriend.set_as_visible
	themeByClubFriend = Theme.find_by_name('Тест флага видимости')
	assert(themeByClubFriend.visibility_status_id == 1, "Visibility_status_id после вызова set_as_hidden не стал равный 1") 
  end
  
  test 'Тест на измение статуса темы Открыта/Закрыта' do 
	u = users(:club_friend)
	themeByClubFriend = Theme.new(
								:name => 'Тест статусов Открыта/Закрыта',
								:content => 'Тест на измение статуса темы Открыта/Закрыта',
								:status_id => 1, 
								:user_id => u.id,
								:topic_id => 1
								)
	assert(themeByClubFriend.save, "Не удалось сохранить тему: #{themeByClubFriend.errors.each {|err| err.each {|m| "#{m}; "}}}") 
    themeByClubFriend.do_close(u)
	msg = Message.find_by_content_and_theme_id('Тема закрыта', themeByClubFriend.id)
	assert(themeByClubFriend.status_id == 3 && msg != nil, "Status_id не стал равный 3") 
    themeByClubFriend.do_open(u)
	msg = Message.find_by_content_and_theme_id('Тема возобновлена', themeByClubFriend.id)
	assert(themeByClubFriend.status_id == 1, "Status_id не стал равный 1")
  end
  
  test "Тест на удаление темы и всего что с ней связано" do
    theme = themes(:themeForDestroyTest)
    themeSteps = theme.steps.size
    stepsCount = Step.count
    themeNtfs = theme.theme_notifications.size
    messageCount = Message.count
    thNtfsSize = ThemeNotification.count
    themePhotosNewVal = Photo.count - theme.photos.size
    themeEntityPhotosNewVal = EntityPhoto.count - theme.entity_photos.size
    messages = theme.messages.size
    assert_difference("Theme.count", -1, 'Не удалось удалить тему') do
      theme.destroy
    end
    assert messageCount - messages == Message.count, "Сообщения темы удалить не удалось"
    assert thNtfsSize - themeNtfs == ThemeNotification.count, "Подписки на тему удалить не удалось"
    assert stepsCount - themeSteps == Step.count, "Steps темы удалить не удалось"
    assert (themePhotosNewVal == Photo.count) && (themeEntityPhotosNewVal == EntityPhoto.count), "Фотографии удалить не удалось"
  end
    
  test "Тест на недопустимость создания новости из темы без заголовка" do
    user = users(:manager)
    theme = user.theme_draft(Topic.first)
    eCount = Event.count
    assert_no_difference("Event.count", 'Удалось создать новость из темы без заголовка') do
      theme.update_attributes(
                              status_id: 1,
                              visibility_status_id: 1,
                              make_event_flag: 'true', 
                              event_display_area_id: 2, 
                              name: '', 
                              content: 'Тема для теста создания новости из темы'
                              )
    end
  end
  
  test "Тест на недопустимость создания новости из темы со статусом 0" do
    user = users(:manager)
    theme = user.theme_draft(Topic.first)
    eCount = Event.count
    assert_no_difference("Event.count", 'Удалось создать новость из темы без заголовка') do
      theme.update_attributes(
                              status_id: 0,
                              visibility_status_id: 1,
                              make_event_flag: 'true', 
                              event_display_area_id: 2, 
                              name: 'Тест на недопустимость создания новости из темы со статусом 0', 
                              content: 'Тема для теста создания новости из темы'
                              )
    end
  end
  
  test "Тест на недопустимость создания новости из темы со статусом видимости 2" do
    user = users(:manager)
    theme = user.theme_draft(Topic.first)
    eCount = Event.count
    assert_no_difference("Event.count", 'Удалось создать новость из темы без заголовка') do
      theme.update_attributes(
                              status_id: 1,
                              visibility_status_id: 2,
                              make_event_flag: 'true', 
                              event_display_area_id: 2, 
                              name: 'Тест на недопустимость создания новости из темы со статусом видимости 2', 
                              content: 'Тема для теста создания новости из темы'
                              )
    end
  end
  
  test "Тест на недопустимость создания новости из темы без флага создания новости из темы" do
    user = users(:manager)
    theme = user.theme_draft(Topic.first)
    eCount = Event.count
    assert_no_difference("Event.count", 'Удалось создать новость из темы без заголовка') do
      theme.update_attributes(
                              status_id: 1,
                              visibility_status_id: 1,
                              #make_event_flag: 'true', 
                              event_display_area_id: 2, 
                              name: 'Тест на недопустимость создания новости из темы без флага создания новости из темы', 
                              content: 'Тема для теста создания новости из темы'
                              )
    end
  end
  
  test "Тест на создание темы с новостью" do
    user = users(:manager)
    theme = user.theme_draft(Topic.first)
    assert_difference("Event.count", 1, 'Не удалось создать новость из темы') do
      theme.update_attributes(
                              status_id: 1,
                              visibility_status_id: 1,
                              make_event_flag: 'true', 
                              event_display_area_id: 2, 
                              name: 'ThemeForEventCreationTest', 
                              content: 'Тема для теста создания новости из темы'
                              )
    end
    #assert eCount + 1 == Event.count
  end
  
end
