require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  setup do
    @albumPhoto = photos(:defaultPhoto17)
    @albumPhoto_2 = photos(:defaultPhoto21)
  end

  test "photos_path accessible for user_type = guest" do
    comeAsGuest
    type = 'Гостю'
    get :index
    assert_redirected_to '/media?t=albums'
    
    get :show, :id => @albumPhoto, e: 'photo_album', e_id: '10' 
    assert_response :success, "#{type} не удалось посмотреть на фото в альбоме"
    assert_select('form.message_form', 0, "#{type} видно форму комментария")
    
    
    put :update, :id => @albumPhoto, :photo => { :category_id => @albumPhoto.category_id, :description => @albumPhoto.description, :photo_album_id => @albumPhoto.photo_album_id, :user_id => @albumPhoto.user_id }
    assert_redirected_to '/404', "#{type} удалось обновить чужую фотографию"
    #assert_not_nil assigns(:photos)
  end
  
  test "photos_path accessible for user_type = new_user" do
    comeAsNewUser
    type = 'Неавторизованному пользователю'
    get :index
    assert_redirected_to '/media?t=albums'
    
    get :show, :id => @albumPhoto, e: 'photo_album', e_id: '10' 
    assert_response :success, "#{type} не удалось посмотреть на фото в альбоме"
    assert_select('form.message_form', 0, "#{type} видно форму комментария")
    
    put :update, :id => @albumPhoto, :photo => { :category_id => @albumPhoto.category_id, :description => @albumPhoto.description, :photo_album_id => @albumPhoto.photo_album_id, :user_id => @albumPhoto.user_id }
    assert_redirected_to '/404', "#{type} удалось обновить чужую фотографию"
    #assert_not_nil assigns(:photos)
  end
  
  test "photos_path accessible for user_type = club_pilot" do
    comeAsClubPilot
    myPhoto = photos(:clubPilotPhoto)
    type = 'Клубному пилоту'
    get :index
    assert_redirected_to '/media?t=albums'
    
    get :show, :id => myPhoto, e: 'photo_album', e_id: '20201' 
    assert_response :success, "#{type} не удалось посмотреть своё фото в альбоме"
    assert_select('form.message_form', 1, "#{type} не видно форму комментария")
    
    
    put :update, :id => myPhoto, format:'json', :photo => { :category_id => myPhoto.category_id, :description => myPhoto.description, :photo_album_id => myPhoto.photo_album_id, :user_id => myPhoto.user_id }
    assert_response :success, "#{type} не удалось обновить свою фотографию"
    
    assert_difference('Photo.count', -1, "#{type} не удалось удалить свою фотографию") do
      delete :destroy, format: 'json', :id => myPhoto
    end
    assert_response :success
    
    get :show, :id => @albumPhoto, e: 'photo_album', e_id: '10' 
    assert_response :success, "#{type} не удалось посмотреть чужое фото в альбоме"
    assert_select('form.message_form', 1, "#{type} не видно форму комментария")
    
    put :update, :id => @albumPhoto, :photo => { :category_id => @albumPhoto.category_id, :description => @albumPhoto.description, :photo_album_id => @albumPhoto.photo_album_id, :user_id => @albumPhoto.user_id }
    assert_redirected_to '/404', "#{type} удалось обновить чужую фотографию"
    
    assert_no_difference('Photo.count', "#{type} удалось удалить чужую фотографию") do
      delete :destroy, :id => @albumPhoto
    end
    assert_redirected_to '/404'
    #assert_not_nil assigns(:photos)
  end
  
  test "photos_path accessible for user_type = club_friend" do
    comeAsClubFriend
    myPhoto = photos(:clubFriendPhoto)
    
    type = 'Другу клуба'
    get :index
    assert_redirected_to '/media?t=albums'
    
    get :show, :id => myPhoto, e: 'photo_album', e_id: '20301' 
    assert_response :success, "#{type} не удалось посмотреть своё фото в альбоме"
    assert_select('form.message_form', 1, "#{type} не видно форму комментария")
    
    put :update, :id => myPhoto, format:'json', :photo => { :category_id => myPhoto.category_id, :description => myPhoto.description, :photo_album_id => myPhoto.photo_album_id, :user_id => myPhoto.user_id }
    assert_response :success, "#{type} не удалось обновить свою фотографию"
    
    assert_difference('Photo.count', -1, "#{type} не удалось удалить свою фотографию") do
      delete :destroy, format: 'json', :id => myPhoto
    end
    assert_response :success
    
    
    get :show, :id => @albumPhoto, e: 'photo_album', e_id: '10' 
    assert_response :success, "#{type} не удалось посмотреть на фото в альбоме"
    assert_select('form.message_form', 1, "#{type} не видно форму комментария")
    
    put :update, :id => @albumPhoto, :photo => { :category_id => @albumPhoto.category_id, :description => @albumPhoto.description, :photo_album_id => @albumPhoto.photo_album_id, :user_id => @albumPhoto.user_id }
    assert_redirected_to '/404', "#{type} удалось обновить чужую фотографию"
    #assert_not_nil assigns(:photos)
    
    assert_no_difference('Photo.count', "#{type} удалось удалить чужую фотографию") do
      delete :destroy, :id => @albumPhoto
    end
    assert_redirected_to '/404'
  end
  
  test "photos_path accessible for user_type = manager" do
    comeAsManager
    myPhoto = photos(:managerPhoto)
    type = 'Руководителю'
    get :index
    assert_redirected_to '/media?t=albums'
    
    get :show, :id => myPhoto, e: 'photo_album', e_id: '20601' 
    assert_response :success, "#{type} не удалось посмотреть своё фото в альбоме"
    assert_select('form.message_form', 1, "#{type} не видно форму комментария")
    
    put :update, :id => myPhoto, format:'json', :photo => { :category_id => myPhoto.category_id, :description => myPhoto.description, :photo_album_id => myPhoto.photo_album_id, :user_id => myPhoto.user_id }
    assert_response :success, "#{type} не удалось обновить свою фотографию"
    
    assert_difference('Photo.count', -1, "#{type} не удалось удалить свою фотографию") do
      delete :destroy, format: 'json', :id => myPhoto
    end
    assert_response :success
    
    get :show, :id => @albumPhoto, e: 'photo_album', e_id: '10' 
    assert_response :success, "#{type} не удалось посмотреть на фото в альбоме"
    assert_select('form.message_form', 1, "#{type} не видно форму комментария")
    
    put :update, :id => @albumPhoto, :photo => { :category_id => @albumPhoto.category_id, :description => @albumPhoto.description, :photo_album_id => @albumPhoto.photo_album_id, :user_id => @albumPhoto.user_id }
    assert_redirected_to '/404', "#{type} удалось обновить чужую фотографию"
    #assert_not_nil assigns(:photos)
    
    assert_no_difference('Photo.count', "#{type} удалось удалить чужую фотографию") do
      delete :destroy, :id => @albumPhoto
    end
    assert_redirected_to '/404'
  end
  
  test "photos_path accessible for user_type = admin" do
    comeAsAdmin
    myPhoto = photos(:adminPhoto)
    type = 'Администратору'
    get :index
    assert_redirected_to '/media?t=albums'
    
    get :show, :id => myPhoto, e: 'photo_album', e_id: '20101' 
    assert_response :success, "#{type} не удалось посмотреть своё фото в альбоме"
    assert_select('form.message_form', 1, "#{type} не видно форму комментария")
    
    put :update, :id => myPhoto, format:'json', :photo => { :category_id => myPhoto.category_id, :description => myPhoto.description, :photo_album_id => myPhoto.photo_album_id, :user_id => myPhoto.user_id }
    assert_response :success, "#{type} не удалось обновить свою фотографию"
    
    assert_difference('Photo.count', -1, "#{type} не удалось удалить свою фотографию") do
      delete :destroy, format: 'json', :id => myPhoto
    end
    assert_response :success
    
    get :show, :id => @albumPhoto, e: 'photo_album', e_id: '10' 
    assert_response :success, "#{type} не удалось посмотреть на фото в альбоме"
    assert_select('form.message_form', 1, "#{type} не видно форму комментария")
    
    put :update, :id => @albumPhoto, :photo => { :category_id => @albumPhoto.category_id, :description => @albumPhoto.description, :photo_album_id => @albumPhoto.photo_album_id, :user_id => @albumPhoto.user_id }
    assert_redirected_to '/404', "#{type} удалось обновить чужую фотографию"
    
    assert_difference('Photo.count',-1, "#{type} не удалось удалить чужую фотографию") do
      delete :destroy, :id => @albumPhoto
    end
    #assert_not_nil assigns(:photos)
  end
  
  test "photos_path accessible for user_type = super_admin" do
    comeAsSuperAdmin
    myPhoto = photos(:superAdminPhoto)
    type = 'Главному администратору'
    get :index
    assert_redirected_to '/media?t=albums'
    
    get :show, :id => myPhoto, e: 'photo_album', e_id: '20001' 
    assert_response :success, "#{type} не удалось посмотреть своё фото в альбоме"
    assert_select('form.message_form', 1, "#{type} не видно форму комментария")
    
    put :update, :id => myPhoto, format:'json', :photo => { :category_id => myPhoto.category_id, :description => myPhoto.description, :photo_album_id => myPhoto.photo_album_id, :user_id => myPhoto.user_id }
    assert_response :success, "#{type} не удалось обновить свою фотографию"
    
    assert_difference('Photo.count', -1, "#{type} не удалось удалить свою фотографию") do
      delete :destroy, format: 'json', :id => myPhoto
    end
    assert_response :success
    
    get :show, :id => @albumPhoto_2, e: 'photo_album', e_id: '10' 
    assert_response :success, "#{type} не удалось посмотреть на фото в альбоме"
    assert_select('form.message_form', 1, "#{type} не видно форму комментария")
    
    put :update, :id => @albumPhoto_2, format:'json', :photo => { :category_id => @albumPhoto_2.category_id, :description => @albumPhoto_2.description, :photo_album_id => @albumPhoto_2.photo_album_id, :user_id => @albumPhoto_2.user_id }
    assert_response :success, "#{type} не удалось обновить чужую фотографию"
   
    assert_difference('Photo.count',-1, "#{type} не удалось удалить чужую фотографию") do
      delete :destroy, :id => @albumPhoto_2
    end
    #assert_not_nil assigns(:photos)
  end
end
