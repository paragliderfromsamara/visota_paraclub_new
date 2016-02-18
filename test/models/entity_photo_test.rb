require 'test_helper'

class EntityPhotoTest < ActiveSupport::TestCase
  setup do
    @singleEntityPhoto = entity_photos(:singleEntityPhotoForDestroyTest)
    @multipleEntityPhoto = entity_photos(:multipleEntityPhotoForDestroyTest)
  end
  
  test "should destroy photo when destroy entity_photo" do
    c = Photo.count
    assert_difference('EntityPhoto.count', -1, 'Не удалось удалить фото-ссылку') do 
      @singleEntityPhoto.destroy
    end
    assert Photo.count == c-1, "Фотография не удалилась"
  end
  
  test "shouldn't destroy photo when destroy entity_photo" do
    c = Photo.count
    assert_difference('EntityPhoto.count', -1, 'Не удалось удалить фото-ссылку') do 
      @multipleEntityPhoto.destroy
    end
    assert Photo.count == c, "Фотография удалилась"
  end
  # test "the truth" do
  #   assert true
  # end
end
