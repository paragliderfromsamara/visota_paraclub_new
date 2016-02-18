require 'test_helper'

class TopicsControllerTest < ActionController::TestCase
  setup do
    @topic = topics(:typicalTopic)
	@super_admin = users(:super_admin)
	@admin = users(:admin)
	@club_pilot = users(:club_pilot)
	@club_friend = users(:club_friend)
	@new_user = users(:new_user)
	@bunned = users(:bunned)
	@manager = users(:manager)
	@deleted = users(:deleted)
  end
#Topics_path
  test "Видимость Topics_path для Guest" do
    comeAsGuest
	user_type = 'Guest'
	get :index
    assert_response :success, "#{user_type} не смог попасть в topics/index"
    assert_not_nil assigns(:topics), "#{user_type} не видит список разделов"
	assert_select('a#newTopic', 0, "#{user_type} видит кнопку добавления нового раздела")
	assert_select('a#editTopic', 0, "#{user_type} видит кнопку редактирования раздела")
	#assert_select('a#newTheme', 0, "#{user_type} видит кнопку добавления новой темы")
	
  end
  test "Видимость Topics_path для NewUser" do
    comeAsNewUser
	user_type = 'Guest'
	get :index
    assert_response :success, "#{user_type} не смог попасть в topics/index"
    assert_not_nil assigns(:topics), "#{user_type} не видит список разделов"
	assert_select('a#newTopic', 0, "#{user_type} видит кнопку добавления нового раздела")
	assert_select('a#editTopic', 0, "#{user_type} видит кнопку редактирования раздела")
	#assert_select('a#newTheme', 1, "#{user_type} не видит кнопку добавления новой темы в раздел FAQ")
  end

  test "Видимость Topics_path для Bunned" do
    comeAsBunned
	user_type = 'Bunned'
	get :index
    assert_response :success, "#{user_type} не смог попасть в topics/index"
    assert_not_nil assigns(:topics), "#{user_type} не видит список разделов"
	assert_select('a#newTopic', 0, "#{user_type} видит кнопку добавления нового раздела")
	assert_select('a#editTopic', 0, "#{user_type} видит кнопку редактирования раздела")
	#assert_select('a#newTheme', 0, "#{user_type} видит кнопку добавления новой темы в раздел")
  end
  
  test "Видимость Topics_path для Deleted" do
    comeAsDeleted
	user_type = 'Deleted'
	get :index
    assert_response :success, "#{user_type} не смог попасть в topics/index"
    assert_not_nil assigns(:topics), "#{user_type} не видит список разделов"
	assert_select('a#newTopic', 0, "#{user_type} видит кнопку добавления нового раздела")
	assert_select('a#editTopic', 0, "#{user_type} видит кнопку редактирования раздела")
	#assert_select('a#newTheme', 0, "#{user_type} видит кнопку добавления новой темы в раздел")
  end
  
  test "Видимость Topics_path для Manager" do
    comeAsManager
	user_type = 'Manager'
	get :index
    assert_response :success, "#{user_type} не смог попасть в topics/index"
    assert_not_nil assigns(:topics), "#{user_type} не видит список разделов"
	assert_select('a#newTopic', 0, "#{user_type} видит кнопку добавления нового раздела")
	assert_select('a#editTopic', 0, "#{user_type} видит кнопку редактирования раздела")
	#assert_select('a#newTheme', assigns(:topics).count, "#{user_type} не видит кнопки добавления новой темы в разделы")
  end
  
  test "Видимость Topics_path для ClubPilot" do
    comeAsClubPilot
	user_type = 'ClubPilot'
	get :index
    assert_response :success, "#{user_type} не смог попасть в topics/index"
    assert_not_nil assigns(:topics), "#{user_type} не видит список разделов"
	assert_select('a#newTopic', 0, "#{user_type} видит кнопку добавления нового раздела")
	assert_select('a#editTopic', 0, "#{user_type} видит кнопку редактирования раздела")
	#assert_select('a#newTheme', assigns(:topics).count, "#{user_type} не видит кнопки добавления новой темы в разделы")
  end
  
  test "Видимость Topics_path для ClubFriend" do
    comeAsClubFriend
	user_type = 'ClubFriend'
	get :index
    assert_response :success, "#{user_type} не смог попасть в topics/index"
    assert_not_nil assigns(:topics), "#{user_type} не видит список разделов"
	assert_select('a#newTopic', 0, "#{user_type} видит кнопку добавления нового раздела")
	assert_select('a#editTopic', 0, "#{user_type} видит кнопку редактирования раздела")
	#assert_select('a#newTheme', assigns(:topics).count, "#{user_type} не видит кнопки добавления новой темы в разделы")
  end
  
  test "Видимость Topics_path для Admin" do
    comeAsAdmin
	user_type = 'Admin'
	get :index
    assert_response :success, "#{user_type} не смог попасть в topics/index"
    assert_not_nil assigns(:topics), "#{user_type} не видит список разделов"
	assert_select('a#newTopic', 0, "#{user_type} видит кнопку добавления нового раздела")
	assert_select('a#editTopic', 0, "#{user_type} видит кнопку редактирования раздела")
	#assert_select('a#newTheme', assigns(:topics).count, "#{user_type} не видит кнопки добавления новой темы в разделы")
  end
  
  test "Видимость Topics_path для SuperAdmin" do
    comeAsSuperAdmin
	user_type = 'SuperAdmin'
	get :index
    assert_response :success, "#{user_type} не смог попасть в topics/index"
    assert_not_nil assigns(:topics), "#{user_type} не видит список разделов"
	assert_select('a#newTopic', 1, "#{user_type} не видит кнопку добавления нового раздела")
	assert_select('a#editTopic', assigns(:topics).count, "#{user_type} не видит кнопку редактирования раздела")
	#assert_select('a#newTheme', assigns(:topics).count, "#{user_type} не видит кнопки добавления новой темы в разделы")
  end
#Topics_path end  

  test "Видимость new_topic_path для SuperAdmin" do
	comeAsSuperAdmin
	user_type = 'SuperAdmin'
    get :new
    assert_response :success, "#{user_type} не смог зайти на страницу добавления нового раздела" 
  end
  test "Видимость new_topic_path для Admin" do
	comeAsAdmin
	user_type = 'Admin'
    get :new
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу добавления нового раздела" 
  end
  test "Видимость new_topic_path для Manager" do
	comeAsManager
	user_type = 'Manager'
    get :new
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу добавления нового раздела" 
  end
  test "Видимость new_topic_path для ClubPilot" do
	comeAsClubPilot
	user_type = 'ClubPilot'
    get :new
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу добавления нового раздела" 
  end
  test "Видимость new_topic_path для ClubFriend" do
	comeAsClubFriend
	user_type = 'ClubFriend'
    get :new
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу добавления нового раздела" 
  end
  test "Видимость new_topic_path для NewUser" do
	comeAsNewUser
	user_type = 'NewUser'
    get :new
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу добавления нового раздела" 
  end
  test "Видимость new_topic_path для Bunned" do
	comeAsBunned
	user_type = 'Bunned'
    get :new
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу добавления нового раздела" 
  end
  test "Видимость new_topic_path для Deleted" do
	comeAsDeleted
	user_type = 'Deleted'
    get :new
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу добавления нового раздела" 
  end
  test "Видимость new_topic_path для Guest" do
	comeAsGuest
	user_type = 'Guest'
    get :new
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу добавления нового раздела" 
  end
#new_topic_path end 
#create_topic_path  
  test "Доступность new_topic_path для SuperAdmin" do
	comeAsSuperAdmin
	user_type = 'SuperAdmin'
    assert_difference('Topic.count', 1, "#{user_type} не смог добавить новый раздел") do
      post :create, :topic => { :description => @topic.description, :name => @topic.name }
    end
    assert_redirected_to topic_path(assigns(:topic))
  end
  test "Доступность new_topic_path для Admin" do
	comeAsAdmin
	user_type = 'Admin'
    assert_no_difference('Topic.count', "#{user_type} смог добавить новый раздел") do
      post :create, :topic => { :description => @topic.description, :name => @topic.name }
    end
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность new_topic_path для Manager" do
	comeAsManager
	user_type = 'Manager'
    assert_no_difference('Topic.count', "#{user_type} смог добавить новый раздел") do
      post :create, :topic => { :description => @topic.description, :name => @topic.name }
    end
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность new_topic_path для ClubFriend" do
	comeAsClubFriend
	user_type = 'ClubFriend'
    assert_no_difference('Topic.count', "#{user_type} смог добавить новый раздел") do
      post :create, :topic => { :description => @topic.description, :name => @topic.name }
    end
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность new_topic_path для ClubPilot" do
	comeAsClubFriend
	user_type = 'ClubPilot'
    assert_no_difference('Topic.count', "#{user_type} смог добавить новый раздел") do
      post :create, :topic => { :description => @topic.description, :name => @topic.name }
    end
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность new_topic_path для NewUser" do
	comeAsNewUser
	user_type = 'NewUser'
    assert_no_difference('Topic.count', "#{user_type} смог добавить новый раздел") do
      post :create, :topic => { :description => @topic.description, :name => @topic.name }
    end
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность new_topic_path для Bunned" do
	comeAsBunned
	user_type = 'Bunned'
    assert_no_difference('Topic.count', "#{user_type} смог добавить новый раздел") do
      post :create, :topic => { :description => @topic.description, :name => @topic.name }
    end
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность new_topic_path для Deleted" do
	comeAsDeleted
	user_type = 'Deleted'
    assert_no_difference('Topic.count', "#{user_type} смог добавить новый раздел") do
      post :create, :topic => { :description => @topic.description, :name => @topic.name }
    end
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность new_topic_path для Guest" do
	comeAsGuest
	user_type = 'Guest'
    assert_no_difference('Topic.count', "#{user_type} смог добавить новый раздел") do
      post :create, :topic => { :description => @topic.description, :name => @topic.name }
    end
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
	
  end
#create_topic_path end 

#edit_topic_path
  test "Доступность edit_topic_path для SuperAdmin" do
	comeAsSuperAdmin
	user_type = "SuperAdmin"
    get :edit, :id => @topic
    assert_response :success, "#{user_type} не смог зайти на страницу изменения раздела"
  end
  test "Доступность edit_topic_path для Admin" do
	comeAsAdmin
	user_type = "Admin"
    get :edit, :id => @topic
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end  
  test "Доступность edit_topic_path для Manager" do
	comeAsManager
	user_type = "Manager"
    get :edit, :id => @topic
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end 
  test "Доступность edit_topic_path для ClubPilot" do
	comeAsClubPilot
	user_type = "ClubPilot"
    get :edit, :id => @topic
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность edit_topic_path для ClubFriend" do
	comeAsClubFriend
	user_type = "ClubFriend"
    get :edit, :id => @topic
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end 
  test "Доступность edit_topic_path для NewUser" do
	comeAsNewUser
	user_type = "NewUser"
    get :edit, :id => @topic
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end 
  test "Доступность edit_topic_path для Bunned" do
	comeAsBunned
	user_type = "Bunned"
    get :edit, :id => @topic
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end 
  test "Доступность edit_topic_path для Deleted" do
	comeAsDeleted
	user_type = "Deleted"
    get :edit, :id => @topic
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность edit_topic_path для Guest" do
	comeAsGuest
	user_type = "Guest"
    get :edit, :id => @topic
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
#edit_topic_path end
#update_topic_path
  test "Доступность update_topic_path для SuperAdmin" do
	comeAsSuperAdmin
    put :update, :id => @topic, :topic => { :description => @topic.description, :name => @topic.name }
    assert_redirected_to topic_path(@topic)
  end
  test "Доступность update_topic_path для Admin" do
	comeAsAdmin
	user_type = "Admin"
    put :update, :id => @topic, :topic => { :description => @topic.description, :name => @topic.name }
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность update_topic_path для Manager" do
	comeAsManager
	user_type = "Manager"
    put :update, :id => @topic, :topic => { :description => @topic.description, :name => @topic.name }
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность update_topic_path для ClubPilot" do
	comeAsClubPilot
	user_type = "ClubPilot"
    put :update, :id => @topic, :topic => { :description => @topic.description, :name => @topic.name }
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность update_topic_path для ClubFriend" do
	comeAsClubFriend
	user_type = "ClubFriend"
    put :update, :id => @topic, :topic => { :description => @topic.description, :name => @topic.name }
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность update_topic_path для NewUser" do
	comeAsNewUser
	user_type = "NewUser"
    put :update, :id => @topic, :topic => { :description => @topic.description, :name => @topic.name }
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность update_topic_path для Bunned" do
	comeAsBunned
	user_type = "Bunned"
    put :update, :id => @topic, :topic => { :description => @topic.description, :name => @topic.name }
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность update_topic_path для Deleted" do
	comeAsDeleted
	user_type = "Deleted"
    put :update, :id => @topic, :topic => { :description => @topic.description, :name => @topic.name }
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность update_topic_path для Guest" do
	comeAsGuest
	user_type = "Guest"
    put :update, :id => @topic, :topic => { :description => @topic.description, :name => @topic.name }
    assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
#update_topic_path end
#destroy_path
  test "Доступность destroy_topic_path для SuperAdmin" do
	comeAsSuperAdmin
	user_type = "SuperAdmin"
    assert_difference('Topic.count', -1, "#{user_type} Не смог удалить раздел") do
      delete :destroy, :id => @topic
    end
    assert_redirected_to topics_path, "#{user_type} не был перенаправлен к списку разделов после удаления..."
  end
  test "Доступность destroy_topic_path для Admin" do
	comeAsAdmin
	user_type = "Admin"
    assert_no_difference('Topic.count', "#{user_type} смог удалить раздел") do
      delete :destroy, :id => @topic
    end
     assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность destroy_topic_path для Manager" do
	comeAsManager
	user_type = "Manager"
    assert_no_difference('Topic.count', "#{user_type} смог удалить раздел") do
      delete :destroy, :id => @topic
    end
     assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность destroy_topic_path для ClubPilot" do
	comeAsClubPilot
	user_type = "ClubPilot"
    assert_no_difference('Topic.count', "#{user_type} смог удалить раздел") do
      delete :destroy, :id => @topic
    end
     assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность destroy_topic_path для ClubFriend" do
	comeAsClubFriend
	user_type = "ClubFriend"
    assert_no_difference('Topic.count', "#{user_type} смог удалить раздел") do
      delete :destroy, :id => @topic
    end
     assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность destroy_topic_path для NewUser" do
	comeAsNewUser
	user_type = "NewUser"
    assert_no_difference('Topic.count', "#{user_type} смог удалить раздел") do
      delete :destroy, :id => @topic
    end
     assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность destroy_topic_path для Bunned" do
	comeAsBunned
	user_type = "Bunned"
    assert_no_difference('Topic.count', "#{user_type} смог удалить раздел") do
      delete :destroy, :id => @topic
    end
     assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность destroy_topic_path для Deleted" do
	comeAsBunned
	user_type = "Deleted"
    assert_no_difference('Topic.count', "#{user_type} смог удалить раздел") do
      delete :destroy, :id => @topic
    end
     assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
  test "Доступность destroy_topic_path для Guest" do
	comeAsGuest
	user_type = "Guest"
    assert_no_difference('Topic.count', "#{user_type} смог удалить раздел") do
      delete :destroy, :id => @topic
    end
     assert_redirected_to '/404', "#{user_type} не был перенаправлен на отсуствующую страницу" 
  end
#destroy_path end
#show_path
  test "Доступность show_path для Guest" do
	comeAsGuest
	user_type = "Guest"
	topic = topics(:typicalTopic)
	get :show, :id => topic
    assert_response :success, "#{user_type} не смог зайти на страницу раздела"
	assert_select('a#newTheme', 0, "#{user_type} видит кнопку добавления темы")
  end
  test "Доступность show_path для NewUser" do
	comeAsNewUser
	user_type = "NewUser"
	topic = topics(:typicalTopic)
	get :show, :id => topic
    assert_response :success, "#{user_type} не смог зайти на страницу раздела"
	assert_select('a#newTheme', 0, "#{user_type} видит кнопку добавления темы")
	topic = topics(:faqTopic)
	get :show, :id => topic
    assert_response :success, "#{user_type} не смог зайти на страницу раздела"
	assert_select('a#newTheme', 1, "#{user_type} не видит кнопку добавления темы в разделе FAQ")
  end
  test "Доступность show_path для Bunned" do
	comeAsBunned
	user_type = "Bunned"
	topic = topics(:typicalTopic)
	get :show, :id => topic
    assert_response :success, "#{user_type} не смог зайти на страницу раздела"
	assert_select('a#newTheme', 0, "#{user_type} видит кнопку добавления темы")
  end	
  test "Доступность show_path для Deleted" do
	comeAsDeleted
	user_type = "Deleted"
	topic = topics(:typicalTopic)
	get :show, :id => topic
    assert_response :success, "#{user_type} не смог зайти на страницу раздела"
	assert_select('a#newTheme', 0, "#{user_type} видит кнопку добавления темы")

  end	
  test "Доступность show_path для ClubPilot" do
	comeAsClubPilot
	user_type = "ClubPilot"
	topic = topics(:typicalTopic)
	get :show, :id => topic
    assert_response :success, "#{user_type} не смог зайти на страницу раздела"
	assert_select('a#newTheme', 1, "#{user_type} не видит кнопку добавления темы")
  end
  test "Доступность show_path для ClubFriend" do
	comeAsClubFriend
	user_type = "ClubFriend"
	topic = topics(:typicalTopic)
	get :show, :id => topic
    assert_response :success, "#{user_type} не смог зайти на страницу раздела"
	assert_select('a#newTheme', 1, "#{user_type} не видит кнопку добавления темы")
  end
  test "Доступность show_path для Manager" do
	comeAsManager
	user_type = "Manager"
	topic = topics(:typicalTopic)
	get :show, :id => topic
    assert_response :success, "#{user_type} не смог зайти на страницу раздела"
	assert_select('a#newTheme', 1, "#{user_type} не видит кнопку добавления темы")
  end
  test "Доступность show_path для Admin" do
	comeAsAdmin
	user_type = "Admin"
	topic = topics(:typicalTopic)
	get :show, :id => topic
    assert_response :success, "#{user_type} не смог зайти на страницу раздела"
	assert_select('a#newTheme', 1, "#{user_type} не видит кнопку добавления темы")
  end
  test "Доступность show_path для SuperAdmin" do
	comeAsSuperAdmin
	user_type = "SuperAdmin"
	topic = topics(:typicalTopic)
	get :show, :id => topic
    assert_response :success, "#{user_type} не смог зайти на страницу раздела"
	assert_select('a#newTheme', 1, "#{user_type} не видит кнопку добавления темы")
  end
#show_path end
end
