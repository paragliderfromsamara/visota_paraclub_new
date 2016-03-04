require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  test "Сообщение не должно быть без текста и фотографий" do
     message = Message.new(
							:user_id => 15,
							:content => '',
							:theme_id => 1,
							:topic_id => 1,
							:status_id =>1
						   )
	 assert(!message.save, "Сохранёно сообщение без текста и фотографий")
  end
  
  test "Сообщение может быть без текста но с фотографиями" do
    message = Message.new(
							:user_id => 20,
							:content => '',
							:theme_id => 1,
							:topic_id => 1,
							:status_id =>0
						   )
   assert(message.save, 'Не удалось сохранить черновик')
   photo = Photo.create(user_id: 20)
   message.entity_photos.create(photo_id: photo.id)
   message = Message.find(message.id)
	 assert(message.update_attributes(status_id:1), "Не удалось сохранить сообщение только с фотографиями")
  end
  
  test "Сообщение не должно быть слишком длинным" do
     message = Message.new(
							:user_id => 15,
							:content => overMaxThemeContent,
							:theme_id => 1,
							:topic_id => 1,
							:status_id =>1
						   )
	 assert(!message.save, "Сохранено сообщение с превышением максимальной длины")
  end
  
  test "Перед сохранением должен находить в тексте фотографии и делать их не видимымы" do
    user = users(:club_pilot)
    theme = themes(:themeVisibleOpen)
    message = user.theme_message_draft(theme)
    photo = Photo.create(user_id: user.id)
    message.entity_photos.create(photo_id: photo.id)
    message = Message.find(message.id)
    assert message.visible_photos.count == 1, "Фотография не добавилась к сообщению"
    message.update_attributes(status_id: 1, content: "#Photo#{photo.id} #{defaultTextContent}")
    message = Message.find(message.id)
    assert message.visible_photos.count == 0, "Фотография не скрылась после добавления ее хэш тэга в текст"
  end
  
  test "Из сообщение должно превращаться в тему, а его сообщения-потомки переноситься вместе с ним" do
    messageForNewTheme = messages(:messageForNewThemeCreation)
    
  end
end
