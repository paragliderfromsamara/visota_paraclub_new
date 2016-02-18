require 'test_helper'

class VideosControllerTest < ActionController::TestCase
  setup do
    @video = videos(:youtube)
    @video_2 = videos(:vimeo)
  end

  test "should get index" do
    get :index
    assert_redirected_to "/media?t=videos", "Не удалось переадресовать пользователя на страницу медиа"
    #assert_response :success
    #assert_not_nil assigns(:videos)
  end
  
  test "video controller access test for user_group = guest" do
    comeAsGuest
    type = 'Гостю'
    
    get :new
    assert_redirected_to '/404', "#{type} удалось зайти на страницу добавления нового видео"
    
    assert_no_difference('Video.count', "#{type} удалось добавить видео") do
      post :create, :video => { :article_id => @video.article_id, :category_id => @video.category_id, :link => @video.link, :name => @video.name, :user_id => @video.user_id }
    end
    
  	get :show, :id => @video
    assert_response :success, "#{type} не удалось зайти на страницу видео"
    assert_select('a#editVideo', 0, "#{type} видит кнопку 'Изменить видео' на странице чужого видео")
    assert_select('a#delVideo', 0, "#{type} видит кнопку 'Удалить' на странице чужого видео")
    
    get :edit, :id => @video
    assert_redirected_to '/404', "#{type} удалось зайти на страницу редактирования видео"
    
    put :update, :id => @video, :video => { :article_id => @video.article_id, :category_id => @video.category_id, :event_id => @video.event_id, :link => @video.link, :name => @video.name, :user_id => @video.user_id }
    assert_redirected_to '/404', "#{type} удалось обновить видео"
    
    assert_no_difference('Video.count', "#{type} удалось удалить видео") do
        delete :destroy, :id => @video
    end
  end
  
  
  test "video controller access test for user_group = new_user" do
    comeAsNewUser
    type = 'Неавторизованному пользователю'
    
    get :new
    assert_redirected_to '/404', "#{type} удалось зайти на страницу добавления нового видео"
    
    assert_no_difference('Video.count', "#{type} удалось добавить видео") do
      post :create, :video => { :article_id => @video.article_id, :category_id => @video.category_id, :link => @video.link, :name => @video.name, :user_id => @video.user_id }
    end
    
  	get :show, :id => @video
    assert_response :success, "#{type} не удалось зайти на страницу видео"
    assert_select('a#editVideo', 0, "#{type} видит кнопку 'Изменить видео' на странице чужого видео")
    assert_select('a#delVideo', 0, "#{type} видит кнопку 'Удалить' на странице чужого видео")
    
    get :edit, :id => @video
    assert_redirected_to '/404', "#{type} удалось зайти на страницу редактирования видео"
    
    put :update, :id => @video, :video => { :article_id => @video.article_id, :category_id => @video.category_id, :event_id => @video.event_id, :link => @video.link, :name => @video.name, :user_id => @video.user_id }
    assert_redirected_to '/404', "#{type} удалось обновить видео"
    
    assert_no_difference('Video.count', "#{type} удалось удалить видео") do
        delete :destroy, :id => @video
    end
  end
  
  test "video controller access test for user_group = club_friend" do
    u = comeAsClubFriend
    type = 'Другу клуба'
    my_video = videos(:club_friend_video)
    get :new
     assert_response :success, "#{type} не удалось зайти на страницу добавления нового видео"
    
    assert_difference('Video.count', 1, "#{type} не удалось добавить видео") do
      post :create, :video => { :category_id => 1, :link => "https://youtu.be/1OWw6_zNnjM", :name => "Default club_friend video", :user_id => u.id }
    end
    #видео текущего пользователя
  	get :show, :id => my_video
    assert_response :success, "#{type} не удалось зайти на страницу своего видео"
    assert_select('a#editVideo', 1, "#{type} не видит кнопку 'Изменить видео' на странице своего видео")
    assert_select('a#delVideo', 1, "#{type} не видит кнопку 'Удалить' на странице своего видео")
    
    get :edit, :id => my_video
    assert_response :success, "#{type} не удалось зайти на страницу редактирования чужого видео"
    
    put :update, :id => my_video, :video => { :category_id => 2, :link => my_video.link, :name => my_video.name, :user_id => my_video.user_id }
    assert_redirected_to video_path(my_video), "#{type} не удалось обновить свое видео"
    
    assert_difference('Video.count', -1,"#{type} не удалось удалить свое видео") do
        delete :destroy, :id => my_video
    end
    assert_redirected_to '/media?t=videos&c=all'
    
    #видео другого пользователя
  	get :show, :id => @video
    assert_response :success, "#{type} не удалось зайти на страницу чужого видео"
    assert_select('a#editVideo', 0, "#{type} видит кнопку 'Изменить видео' на странице чужого видео")
    assert_select('a#delVideo', 0, "#{type} видит кнопку 'Удалить' на странице чужого видео")
    
    
    get :edit, :id => @video
    assert_redirected_to '/404', "#{type} удалось зайти на страницу редактирования своего видео"
    
    put :update, :id => @video, :video => { :article_id => @video.article_id, :category_id => @video.category_id, :event_id => @video.event_id, :link => @video.link, :name => @video.name, :user_id => @video.user_id }
    assert_redirected_to '/404', "#{type} удалось обновить чужое видео"
    
    assert_no_difference('Video.count', "#{type} удалось удалить чужое видео") do
        delete :destroy, :id => @video
    end
  end
  
  test "video controller access test for user_group = club_pilot" do
    u = comeAsClubPilot
    type = 'Клубному пилоту'
    my_video = videos(:club_pilot_video)
    get :new
     assert_response :success, "#{type} не удалось зайти на страницу добавления нового видео"
    
    assert_difference('Video.count', 1, "#{type} не удалось добавить видео") do
      post :create, :video => { :category_id => 1, :link => "https://youtu.be/1OWw6_zNnjM", :name => "Default club_friend video", :user_id => u.id }
    end
    #видео текущего пользователя
  	get :show, :id => my_video
    assert_response :success, "#{type} не удалось зайти на страницу своего видео"
    assert_select('a#editVideo', 1, "#{type} не видит кнопку 'Изменить видео' на странице своего видео")
    assert_select('a#delVideo', 1, "#{type} не видит кнопку 'Удалить' на странице своего видео")
    
    get :edit, :id => my_video
    assert_response :success, "#{type} не удалось зайти на страницу редактирования своего видео"
    
    put :update, :id => my_video, :video => { :category_id => 2, :link => my_video.link, :name => my_video.name, :user_id => my_video.user_id }
    assert_redirected_to video_path(my_video), "#{type} не удалось обновить свое видео"
    
    assert_difference('Video.count', -1,"#{type} не удалось удалить свое видео") do
        delete :destroy, :id => my_video
    end
    assert_redirected_to '/media?t=videos&c=all'
    
    #видео другого пользователя
  	get :show, :id => @video
    assert_response :success, "#{type} не удалось зайти на страницу чужого видео"
    assert_select('a#editVideo', 0, "#{type} видит кнопку 'Изменить видео' на странице чужого видео")
    assert_select('a#delVideo', 0, "#{type} видит кнопку 'Удалить' на странице чужого видео")
    
    get :edit, :id => @video
    assert_redirected_to '/404', "#{type} удалось зайти на страницу редактирования чужого видео"
    
    put :update, :id => @video, :video => { :article_id => @video.article_id, :category_id => @video.category_id, :event_id => @video.event_id, :link => @video.link, :name => @video.name, :user_id => @video.user_id }
    assert_redirected_to '/404', "#{type} удалось обновить чужое видео"
    
    assert_no_difference('Video.count', "#{type} удалось удалить чужое видео") do
        delete :destroy, :id => @video
    end
  end
  
  test "video controller access test for user_group = manager" do
    u = comeAsManager
    type = 'Руководителю клуба'
    my_video = videos(:manager_video)
    get :new
     assert_response :success, "#{type} не удалось зайти на страницу добавления нового видео"
    
    assert_difference('Video.count', 1, "#{type} не удалось добавить видео") do
      post :create, :video => { :category_id => 1, :link => "https://youtu.be/1OWw6_zNnjM", :name => "Default club_friend video", :user_id => u.id }
    end
    #видео текущего пользователя
  	get :show, :id => my_video
    assert_response :success, "#{type} не удалось зайти на страницу своего видео"
    assert_select('a#editVideo', 1, "#{type} не видит кнопку 'Изменить видео' на странице своего видео")
    assert_select('a#delVideo', 1, "#{type} не видит кнопку 'Удалить' на странице своего видео")
    
    
    get :edit, :id => my_video
    assert_response :success, "#{type} не удалось зайти на страницу редактирования своего видео"
    
    put :update, :id => my_video, :video => { :category_id => 2, :link => my_video.link, :name => my_video.name, :user_id => my_video.user_id }
    assert_redirected_to video_path(my_video), "#{type} не удалось обновить свое видео"
    
    assert_difference('Video.count', -1,"#{type} не удалось удалить свое видео") do
        delete :destroy, :id => my_video
    end
    assert_redirected_to '/media?t=videos&c=all'
    
    #видео другого пользователя
  	get :show, :id => @video
    assert_response :success, "#{type} не удалось зайти на страницу чужого видео"
    assert_select('a#editVideo', 0, "#{type} видит кнопку 'Изменить видео' на странице чужого видео")
    assert_select('a#delVideo', 0, "#{type} видит кнопку 'Удалить' на странице чужого видео")
    
    
    get :edit, :id => @video
    assert_redirected_to '/404', "#{type} удалось зайти на страницу редактирования чужого видео"
    
    put :update, :id => @video, :video => { :article_id => @video.article_id, :category_id => @video.category_id, :event_id => @video.event_id, :link => @video.link, :name => @video.name, :user_id => @video.user_id }
    assert_redirected_to '/404', "#{type} удалось обновить чужое видео"
    
    assert_no_difference('Video.count', "#{type} удалось удалить чужое видео") do
        delete :destroy, :id => @video
    end
  end
  
  test "video controller access test for user_group = admin" do
    u = comeAsAdmin
    type = 'Администратору'
    my_video = videos(:admin_video)
    get :new
     assert_response :success, "#{type} не удалось зайти на страницу добавления нового видео"
    
    assert_difference('Video.count', 1, "#{type} не удалось добавить видео") do
      post :create, :video => { :category_id => 1, :link => "https://youtu.be/1OWw6_zNnjM", :name => "Default club_friend video", :user_id => u.id }
    end
    #видео текущего пользователя
  	get :show, :id => my_video
    assert_response :success, "#{type} не удалось зайти на страницу своего видео"
    assert_select('a#editVideo', 1, "#{type} не видит кнопку 'Изменить видео' на странице своего видео")
    assert_select('a#delVideo', 1, "#{type} не видит кнопку 'Удалить' на странице своего видео")
    
    
    get :edit, :id => my_video
    assert_response :success, "#{type} не удалось зайти на страницу редактирования своего видео"
    
    put :update, :id => my_video, :video => { :category_id => 2, :link => my_video.link, :name => my_video.name, :user_id => my_video.user_id }
    assert_redirected_to video_path(my_video), "#{type} не удалось обновить свое видео"
    
    assert_difference('Video.count', -1,"#{type} не удалось удалить свое видео") do
        delete :destroy, :id => my_video
    end
    assert_redirected_to '/media?t=videos&c=all'
    
    #видео другого пользователя
  	get :show, :id => @video
    assert_response :success, "#{type} не удалось зайти на страницу чужого видео"
    assert_select('a#editVideo', 0, "#{type} видит кнопку 'Изменить видео' на странице чужого видео")
    assert_select('a#delVideo', 1, "#{type} не видит кнопку 'Удалить' на странице чужого видео")
    
    
    get :edit, :id => @video
    assert_redirected_to '/404', "#{type} удалось зайти на страницу редактирования чужого видео"
    
    put :update, :id => @video, :video => { :article_id => @video.article_id, :category_id => @video.category_id, :event_id => @video.event_id, :link => @video.link, :name => @video.name, :user_id => @video.user_id }
    assert_redirected_to '/404', "#{type} удалось обновить чужое видео"
    
    assert_difference('Video.count',-1, "#{type} не удалось удалить чужое видео") do
        delete :destroy, :id => @video
    end
  end
  test "video controller access test for user_group = super_admin" do
    u = comeAsSuperAdmin
    
    type = 'Главному администратору'
    my_video = videos(:super_admin_video)
    get :new
     assert_response :success, "#{type} не удалось зайти на страницу добавления нового видео"
    
    assert_difference('Video.count', 1, "#{type} не удалось добавить видео") do
      post :create, :video => { :category_id => 1, :link => "https://youtu.be/1OWw6_zNnjM", :name => "Default club_friend video", :user_id => u.id }
    end
    #видео текущего пользователя
  	get :show, :id => my_video
    assert_response :success, "#{type} не удалось зайти на страницу своего видео"
    assert_select('a#editVideo', 1, "#{type} не видит кнопку 'Изменить видео' на странице своего видео")
    assert_select('a#delVideo', 1, "#{type} не видит кнопку 'Удалить' на странице своего видео")
    
    
    get :edit, :id => my_video
    assert_response :success, "#{type} не удалось зайти на страницу редактирования своего видео"
    
    put :update, :id => my_video, :video => { :category_id => 2, :link => my_video.link, :name => my_video.name, :user_id => my_video.user_id }
    assert_redirected_to video_path(my_video), "#{type} не удалось обновить свое видео"
    
    assert_difference('Video.count', -1,"#{type} не удалось удалить свое видео") do
        delete :destroy, :id => my_video
    end
    assert_redirected_to '/media?t=videos&c=all'
    
    #видео другого пользователя
  	get :show, :id => @video_2
    assert_response :success, "#{type} не удалось зайти на страницу чужого видео"
    assert_select('a#editVideo', 1, "#{type} не видит кнопку 'Изменить видео' на странице чужого видео")
    assert_select('a#delVideo', 1, "#{type} не видит кнопку 'Удалить' на странице чужого видео")
    
    get :edit, :id => @video_2
    assert_response :success, "#{type} не удалось зайти на страницу редактирования чужого видео"
    
    put :update, :id => @video_2, :video => { :article_id => @video_2.article_id, :category_id => @video_2.category_id, :event_id => @video_2.event_id, :link => @video_2.link, :name => @video_2.name, :user_id => @video_2.user_id }
    assert_redirected_to video_path( @video_2), "#{type} не удалось обновить чужое видео"
    
    assert_difference('Video.count', -1, "#{type} не удалось удалить чужое видео") do
      delete :destroy, :id => @video_2
    end
  end

end
