require 'test_helper'

class PhotoAlbumTest < ActiveSupport::TestCase
  test "Нельзя создать альбом без фотографий" do
     album = PhotoAlbum.new(
								:user_id => 20,
								:name => "Тестовый альбом",
								:category_id => 1,
								:status_id => 1,
								:visibility_status_id => 1
							)
	 assert(!album.save, "Удалось создать альбом без фотографий")
  end
  
  test "Можно создать сохранить альбом-черновик без фотографий и названия" do
     album = PhotoAlbum.new(
								:user_id => 44,
								:category_id => 1,
								:status_id => 0,
								:visibility_status_id => 1
							)
	 assert(album.save, "Не удалось создать альбом-черновик без фотографий")
  end
  
  test "Можно создать альбом при наличии валидного названия, описания и фотографий" do
     album = PhotoAlbum.new(
								:user_id => 15,
								:name => 'Тестовый альбом 2',
								:category_id => 1,
								:status_id => 1,
								:visibility_status_id => 1,
								:description => 'Описание'
							)
	 assert(album.save, "Не удалось создать альбом при наличии валидного названия, описания и фотографий")
  end
  
  test "Нельзя создать альбом без названия" do
     album = PhotoAlbum.new(
								:user_id => 15,
								:category_id => 1,
								:status_id => 1,
								:visibility_status_id => 1
							)
	 assert(!album.save, "Удалось создать альбом без названия")
  end
  
  test "Нельзя создать альбом с длинным описанием" do
     album = PhotoAlbum.new(
								:user_id => 15,
								:name => 'Альбом с длинным описанием',
								:category_id => 1,
								:status_id => 1,
								:visibility_status_id => 1,
								:description => defaultTextContent
							)
	 assert(!album.save, "Удалось создать альбом с длинным описанием")
  end
  
  test "Нельзя создать альбом с одинаковыми именами" do
     album1 = PhotoAlbum.new(   :user_id => 25,
								:name => 'Альбом с повторяющимся именем',
								:category_id => 1,
								:status_id => 1,
								:visibility_status_id => 1,
								:description => ''
							)
	 album2 = PhotoAlbum.new(   :user_id => 33,
								:name => 'Альбом с повторяющимся именем',
								:category_id => 1,
								:status_id => 1,
								:visibility_status_id => 1,
								:description => ''
							)	
	 assert(!(album1.save&&album2.save), "Удалось создать два альбома с одинаковыми именами")
  end
end
