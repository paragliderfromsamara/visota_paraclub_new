require 'test_helper'

class PhotoAlbumsControllerTest < ActionController::TestCase
  setup do
    @photo_album = photo_albums(:albumOne)
    @photo_album_2 = photo_albums(:albumTwo)
    @photo_album_3 = photo_albums(:albumThree) #for Admin Test
    @photo_album_4 = photo_albums(:albumFour) #for Super Admin Test
    @clubFriendAlbum = photo_albums(:clubFriendAlbum)
    @clubPilotAlbum = photo_albums(:clubPilotAlbum)
    @managerAlbum = photo_albums(:managerAlbum)
    @adminAlbum = photo_albums(:adminAlbum)
    @superAdminAlbum = photo_albums(:superAdminAlbum)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:albums)
  end
  test "test for user_type = guest" do 
    comeAsGuest
    type = "Гостю"
    get :index
    assert_response :success,  "#{type} не удалось посмотреть список альбомов"
    
    get :new
    assert_redirected_to '/404', "#{type} удалось зайти на страницу создания альбома" 
    
    get :show, :id => @photo_album
    assert_response :success, '#{type} не может посмотреть альбом'
    
    get :edit, :id => @photo_album
    assert_redirected_to '/404', "#{type} удалось увидеть страницу редактирования альбома"
    
    put :update, :id => @photo_album, :photo_album => { :article_id => @photo_album.article_id, :category_id => @photo_album.category_id, :description => @photo_album.description, :name => @photo_album.name, :photo_id => @photo_album.photo_id, :user_id => @photo_album.user_id, :status_id => 1 }
    assert_redirected_to '/404', "#{type} удалось обновить чужой альбом"
    
    assert_no_difference('PhotoAlbum.count', "#{type} удалось удалить чужой альбом") do
      delete :destroy, :id => @photo_album
    end
    assert_redirected_to '/404'
  end
  
  test "test for user_type = new_user" do 
    comeAsNewUser
    type = "Неавторизованному пользователю"
    get :index
    assert_response :success,  "#{type} не удалось посмотреть список альбомов"
    
    get :new
    assert_redirected_to '/404', "#{type} удалось зайти на страницу создания альбома" 
    
    get :show, :id => @photo_album
    assert_response :success, '#{type} не может посмотреть альбом'
    
    get :edit, :id => @photo_album
    assert_redirected_to '/404', "#{type} удалось увидеть страницу редактирования чужого альбома"
    
    put :update, :id => @photo_album, :photo_album => { :article_id => @photo_album.article_id, :category_id => @photo_album.category_id, :description => @photo_album.description, :name => @photo_album.name, :photo_id => @photo_album.photo_id, :user_id => @photo_album.user_id, :status_id => 1 }
    assert_redirected_to '/404', "#{type} удалось обновить чужой альбом"
    
    assert_no_difference('PhotoAlbum.count', "#{type} удалось удалить чужой альбом") do
      delete :destroy, :id => @photo_album
    end
    assert_redirected_to '/404'
  end
  
  test "test for user_type = bunned" do 
    comeAsBunned
    type = "Заблокированному пользователю"
    get :index
    assert_response :success,  "#{type} не удалось посмотреть список альбомов"
    
    get :new
    assert_redirected_to '/404', "#{type} удалось зайти на страницу создания альбома" 
    
    get :show, :id => @photo_album
    assert_response :success, '#{type} не может посмотреть альбом'

    get :edit, :id => @photo_album
    assert_redirected_to '/404', "#{type} удалось увидеть страницу редактирования чужого альбома"
    
    put :update, :id => @photo_album, :photo_album => { :article_id => @photo_album.article_id, :category_id => @photo_album.category_id, :description => @photo_album.description, :name => @photo_album.name, :photo_id => @photo_album.photo_id, :user_id => @photo_album.user_id, :status_id => 1 }
    assert_redirected_to '/404', "#{type} удалось обновить чужой альбом"
    
    assert_no_difference('PhotoAlbum.count', "#{type} удалось удалить чужой альбом") do
      delete :destroy, :id => @photo_album
    end
    assert_redirected_to '/404'
  end
  
  test "test for user_type = club_friend" do 
    comeAsClubFriend
    type = "Другу клуба"
    get :index
    assert_response :success,  "#{type} не удалось посмотреть список альбомов"
    
    get :new
    assert_response :success, '#{type} не может зайти на страницу создания альбома' 
    
    get :show, :id => @photo_album
    assert_response :success, '#{type} не может посмотреть альбом'
    
    get :edit, :id =>  @photo_album.id
    assert_redirected_to '/404', "#{type} удалось увидеть страницу редактирования чужого альбома"
    
    put :update, :id => @photo_album.id, :photo_album => { :article_id => @photo_album.article_id, :category_id => @photo_album.category_id, :description => @photo_album.description, :name => @photo_album.name, :photo_id => @photo_album.photo_id, :user_id => @photo_album.user_id, :status_id => 1 }
    assert_redirected_to '/404', "#{type} удалось обновить чужой альбом"
    
    #@albumToForm = @clubFriendAlbum
    get :edit, :id => @clubFriendAlbum.id
    assert_response :success, '#{type} не удалось зайти на страницу редактирования своего альбома'
    
    put :update, :id => @clubFriendAlbum.id, :photo_album => { :article_id => @clubFriendAlbum.article_id, :category_id => @clubFriendAlbum.category_id, :description => @clubFriendAlbum.description, :name => @clubFriendAlbum.name, :photo_id => @clubFriendAlbum.photo_id, :user_id => @clubFriendAlbum.user_id, :status_id => 1 }
    assert_redirected_to photo_album_path(@clubFriendAlbum)#, "#{type} не удалось обновить свой альбом"

    assert_no_difference('PhotoAlbum.count', "#{type} удалось удалить чужой альбом") do
      delete :destroy, :id => @photo_album
    end
    assert_redirected_to '/404'
    
    assert_difference('PhotoAlbum.count', -1,"#{type} не может удалить свой альбом") do
      delete :destroy, :id => @clubFriendAlbum
    end
    assert_redirected_to '/media?t=albums&c=all'
  end
  
  test "test for user_type = club_pilot" do 
    comeAsClubPilot
    type = "Клубному пилоту"
    get :index
    assert_response :success,  "#{type} не удалось посмотреть список альбомов"
    
    get :new
    assert_response :success, '#{type} не может зайти на страницу создания альбома' 
    
    get :show, :id => @photo_album
    assert_response :success, '#{type} не может посмотреть альбом'
    
    get :edit, :id => @photo_album
    assert_redirected_to '/404', "#{type} удалось увидеть страницу редактирования чужого альбома"
    
    put :update, :id => @photo_album, :photo_album => { :category_id => @photo_album.category_id, :description => @photo_album.description, :name => @photo_album.name, :user_id => @photo_album.user_id, :status_id => 1 }
    assert_redirected_to '/404', "#{type} удалось обновить чужой альбом"
    
    #@albumToForm = @clubPilotAlbum
    get :edit, :id => @clubPilotAlbum
    assert_response :success, '#{type} не удалось зайти на страницу редактирования своего альбома'
    
    put :update, :id => @clubPilotAlbum, :photo_album => {:category_id => @clubPilotAlbum.category_id, :description => @clubPilotAlbum.description, :name => @clubPilotAlbum.name, :user_id => @clubPilotAlbum.user_id, :status_id => 1 }
    assert_redirected_to photo_album_path(@clubPilotAlbum), "#{type} не удалось обновить свой альбом"

    assert_no_difference('PhotoAlbum.count', "#{type} удалось удалить чужой альбом") do
      delete :destroy, :id => @photo_album
    end
    assert_redirected_to '/404'
    
    assert_difference('PhotoAlbum.count', -1,"#{type} не может удалить свой альбом") do
      delete :destroy, :id => @clubPilotAlbum
    end
    assert_redirected_to '/media?t=albums&c=all'
  end
  
  test "test for user_type = manager" do 
    comeAsManager
    type = "Руководителю клуба"
    get :index
    assert_response :success,  "#{type} не удалось посмотреть список альбомов"
    
    get :new
    assert_response :success, '#{type} не может зайти на страницу создания альбома' 
    
    get :show, :id => @photo_album
    assert_response :success, '#{type} не может посмотреть альбом'
    
    get :edit, :id => @photo_album
    assert_redirected_to '/404', "#{type} удалось увидеть страницу редактирования чужого альбома"
    
    put :update, :id => @photo_album, :photo_album => { :category_id => @photo_album.category_id, :description => @photo_album.description, :name => @photo_album.name, :user_id => @photo_album.user_id, :status_id => 1 }
    assert_redirected_to '/404', "#{type} удалось обновить чужой альбом"
    
    #@albumToForm = @clubPilotAlbum
    get :edit, :id => @managerAlbum
    assert_response :success, '#{type} не удалось зайти на страницу редактирования своего альбома'
    
    put :update, :id => @managerAlbum, :photo_album => {:category_id => @managerAlbum.category_id, :description => @managerAlbum.description, :name => @managerAlbum.name, :user_id => @managerAlbum.user_id, :status_id => 1 }
    assert_redirected_to photo_album_path(@managerAlbum), "#{type} не удалось обновить свой альбом"

    assert_no_difference('PhotoAlbum.count', "#{type} удалось удалить чужой альбом") do
      delete :destroy, :id => @photo_album
    end
    assert_redirected_to '/404'
    
    assert_difference('PhotoAlbum.count', -1,"#{type} не может удалить свой альбом") do
      delete :destroy, :id => @managerAlbum
    end
    assert_redirected_to '/media?t=albums&c=all'
  end
  
  test "test for user_type = admin" do 
    comeAsAdmin
    type = "Администратору"
    get :index
    assert_response :success,  "#{type} не удалось посмотреть список альбомов"
    
    get :new
    assert_response :success, '#{type} не может зайти на страницу создания альбома' 
    
    get :show, :id => @photo_album_3
    assert_response :success, '#{type} не может посмотреть альбом'
    
    get :edit, :id => @photo_album_3
    assert_redirected_to '/404', "#{type} удалось увидеть страницу редактирования чужого альбома"
    
    put :update, :id => @photo_album_3, :photo_album => { :category_id => @photo_album_3.category_id, :description => @photo_album_3.description, :name => @photo_album_3.name, :user_id => @photo_album_3.user_id, :status_id => 1 }
    assert_redirected_to '/404', "#{type} удалось обновить чужой альбом"
    
    #@albumToForm = @clubPilotAlbum
    get :edit, :id => @adminAlbum
    assert_response :success, '#{type} не удалось зайти на страницу редактирования своего альбома'
    
    put :update, :id => @adminAlbum, :photo_album => {:category_id => @adminAlbum.category_id, :description => @adminAlbum.description, :name => @adminAlbum.name, :user_id => @adminAlbum.user_id, :status_id => 1 }
    assert_redirected_to photo_album_path(@adminAlbum), "#{type} не удалось обновить свой альбом"

    assert_difference('PhotoAlbum.count', -1,"#{type} не может удалить чужой альбом") do
      delete :destroy, :id => @photo_album_3
    end
    
    assert_difference('PhotoAlbum.count', -1,"#{type} не может удалить свой альбом") do
      delete :destroy, :id => @adminAlbum
    end
    assert_redirected_to '/media?t=albums&c=all'
  end
  
  test "test for user_type = super_admin" do 
    comeAsSuperAdmin
    type = "Главному администратору"
    get :index
    assert_response :success,  "#{type} не удалось посмотреть список альбомов"
    
    get :new
    assert_response :success, '#{type} не может зайти на страницу создания альбома' 
    
    get :show, :id => @photo_album
    assert_response :success, '#{type} не может посмотреть альбом'
    
    get :edit, :id => @photo_album_4
    assert_response :success, "#{type} не удалось увидеть страницу редактирования чужого альбома"
    
    put :update, :id => @photo_album_4, :photo_album => { :category_id => @photo_album_4.category_id, :description => @photo_album_4.description, :name => @photo_album_4.name, :user_id => @photo_album_4.user_id, :status_id => 1 }
    assert_redirected_to photo_album_path(@photo_album_4), "#{type} не удалось обновить чужой альбом"
    
    #@albumToForm = @clubPilotAlbum
    get :edit, :id => @photo_album_4
    assert_response :success, '#{type} не удалось зайти на страницу редактирования своего альбома'
    
    put :update, :id => @superAdminAlbum, :photo_album => {:category_id => @superAdminAlbum.category_id, :description => @superAdminAlbum.description, :name => @superAdminAlbum.name, :user_id => @superAdminAlbum.user_id, :status_id => 1 }
    assert_redirected_to photo_album_path(@superAdminAlbum), "#{type} не удалось обновить свой альбом"

    assert_difference('PhotoAlbum.count', -1,"#{type} не может удалить чужой альбом") do
      delete :destroy, :id => @photo_album_4
    end
    
    assert_difference('PhotoAlbum.count', -1,"#{type} не может удалить свой альбом") do
      delete :destroy, :id => @superAdminAlbum
    end
    assert_redirected_to '/media?t=albums&c=all'
  end
  
  test "SuperAdmin, Admin, Manager, ClubPilot and ClubFriend should get new" do
    comeAsSuperAdmin
    get :new
    assert_response :success, 'Супер администратору не удалось зайти на страницу создания альбома'
    comeAsAdmin
    get :new
    assert_response :success, 'Администратору не удалось зайти на страницу создания альбома'
    comeAsManager
    get :new
    assert_response :success, 'Руководителю не удалось зайти на страницу создания альбома'
    comeAsClubPilot
    get :new
    assert_response :success, 'Клубному пилоту не удалось зайти на страницу создания альбома'
    comeAsClubFriend
    get :new
    assert_response :success, 'Другу клуба не удалось зайти на страницу создания альбома'
  end

  #test "should create photo_album" do
  #  assert_difference('PhotoAlbum.count') do
  #    post :create, :photo_album => { :article_id => @photo_album.article_id, :category_id => @photo_album.category_id, :description => @photo_album.description, :name => @photo_album.name, :photo_id => @photo_album.photo_id, :user_id => @photo_album.user_id }
  #  end

  #  assert_redirected_to photo_album_path(assigns(:photo_album))
  #end

  
end
