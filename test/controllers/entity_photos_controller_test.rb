require 'test_helper'

class EntityPhotosControllerTest < ActionController::TestCase
  setup do 
    @superAdminEntityPhoto = entity_photos(:superAdminAlbumEntityPhoto_2)
    @adminEntityPhoto = entity_photos(:adminAlbumEntityPhoto_2)
    @clubPilotEntityPhoto = entity_photos(:clubPilotAlbumEntityPhoto_2)
    @clubFriendEntityPhoto = entity_photos(:clubFriendAlbumEntityPhoto_2)
    @managerEntityPhoto = entity_photos(:managerAlbumEntityPhoto_2)
    @entityForAdminDelete = entity_photos(:adminDelTestAlbumEntity)
    @entityForSuperAdminDelete = entity_photos(:superAdminDelTestAlbumEntity)
  end
  
  test "guest shouldn't remove entity_photo" do 
    comeAsGuest
    assert_no_difference('EntityPhoto.count', 'Гостю удалось удалить фото-ссылку') do
      delete :destroy, id: @adminEntityPhoto
    end
  end
  
  test "new_user shouldn't remove entity_photo" do 
    comeAsNewUser
    assert_no_difference('EntityPhoto.count', 'Неавторизованному пользователю удалось удалить фото-ссылку') do
      delete :destroy, id: @adminEntityPhoto
    end
  end
  
  test "club_friend should remove self entity_photo and sholdn't remove alien entity_photo" do 
    comeAsClubFriend
    assert_no_difference('EntityPhoto.count', 'Другу клуба удалось удалить чужую фото-ссылку') do
      delete :destroy, id: @adminEntityPhoto
    end
    assert_difference('EntityPhoto.count',-1, 'Другу клуба не удалось удалить свою фото-ссылку') do
      delete :destroy, id: @clubFriendEntityPhoto
    end
  end
  
  test "club_pilot should remove self entity_photo and sholdn't remove alien entity_photo" do 
    comeAsClubPilot
    assert_no_difference('EntityPhoto.count', 'Клубному пилоту удалось удалить чужую фото-ссылку') do
      delete :destroy, id: @adminEntityPhoto
    end
    assert_difference('EntityPhoto.count',-1, 'Клубному пилоту не удалось удалить свою фото-ссылку') do
      delete :destroy, id: @clubPilotEntityPhoto
    end
  end
  
  test "manager should remove self entity_photo and sholdn't remove alien entity_photo" do 
    comeAsManager
    assert_no_difference('EntityPhoto.count', 'Руководителю клуба удалось удалить чужую фото-ссылку') do
      delete :destroy, id: @adminEntityPhoto
    end
    assert_difference('EntityPhoto.count',-1, 'Руководителю клуба не удалось удалить свою фото-ссылку') do
      delete :destroy, id: @managerEntityPhoto
    end
  end
  
  test "admin should remove self entity_photo and shouldn remove alien entity_photo" do 
    comeAsAdmin
    assert_difference('EntityPhoto.count', -1, 'Администратору не удалось удалить чужую фото-ссылку') do
      delete :destroy, id: @entityForAdminDelete
    end
    assert_difference('EntityPhoto.count',-1, 'Администратору не удалось удалить свою фото-ссылку') do
      delete :destroy, id: @adminEntityPhoto
    end
  end
  
  test "super_admin should remove self entity_photo and should remove alien entity_photo" do 
    comeAsSuperAdmin
    assert_difference('EntityPhoto.count', -1, 'Руководителю клуба удалось удалить чужую фото-ссылку') do
      delete :destroy, id: @entityForSuperAdminDelete
    end
    assert_difference('EntityPhoto.count',-1, 'Руководителю клуба не удалось удалить свою фото-ссылку') do
      delete :destroy, id: @superAdminEntityPhoto
    end
  end
  #test "should get destroy" do
  #  get :destroy
  #  assert_response :success
  #end

end
