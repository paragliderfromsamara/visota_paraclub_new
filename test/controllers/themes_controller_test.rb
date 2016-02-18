require 'test_helper'

class ThemesControllerTest < ActionController::TestCase
  setup do
    @theme = themes(:themeVisibleOpen)
    @themeUser = users(:themeOwner)
  end

  test "Просмотр списка тем" do
    get :index
    assert_response :success
    assert_not_nil assigns(:themes), "Должен просматривать любой пользователь"
  end


  test "Проверка доступности edit_path для guest" do 
	comeAsGuest
	theme = themes(:clubFriendThemeOpenVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "Guest смог зайти на страницу редактирования темы OpenVisible"
    theme = themes(:clubFriendThemeCloseVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "Guest смог зайти на страницу редактирования темы CloseVisible"
    theme = themes(:clubPilotThemeOpenHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "Guest смог зайти на страницу редактирования темы OpenHidden"
    theme = themes(:clubPilotThemeCloseHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "Guest смог зайти на страницу редактирования темы CloseHidden"
    theme = themes(:clubPilotThemeToDelete)
	  get :edit, :id => theme
    assert_redirected_to '/404', "Guest смог зайти на страницу редактирования темы ToDelete"
  end
  
  test "Проверка доступности edit_path для new_user" do 
	user_type = "NewUser"
	comeAsNewUser
	#страницы редактирования чужих тем
	theme = themes(:clubFriendThemeOpenVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы OpenVisible"
    theme = themes(:clubFriendThemeCloseVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseVisible"
    theme = themes(:clubPilotThemeOpenHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы OpenHidden"
    theme = themes(:clubPilotThemeCloseHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseHidden"
    theme = themes(:clubPilotThemeToDelete)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы ToDelete"
	#страницы редактирования своих тем
	theme = themes(:newUserThemeOpenVisible)
    get :edit, :id => theme
    assert_response :success, "#{user_type} не смог зайти на страницу редактирования своей темы OpenVisible"
    theme = themes(:newUserThemeCloseVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseVisible"
	  theme = themes(:newUserThemeToDelete)
	  get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы ToDelete"
  end
  
  test "Проверка доступности edit_path для club_pilot" do 
	user_type = "ClubPilot"
	comeAsClubPilot
	#страницы редактирования чужих тем
	theme = themes(:clubFriendThemeOpenVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы OpenVisible"
    theme = themes(:clubFriendThemeCloseVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseVisible"
    theme = themes(:clubFriendThemeOpenHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы OpenHidden"
    theme = themes(:clubFriendThemeCloseHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseHidden"
    theme = themes(:clubFriendThemeToDelete)
	  get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы ToDelete"

	#страницы редактирования своих тем
	theme = themes(:clubPilotThemeOpenVisible)
    get :edit, :id => theme
    assert_response :success, "#{user_type} не смог зайти на страницу редактирования своей темы OpenVisible"
    theme = themes(:clubPilotThemeCloseVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseVisible"
    theme = themes(:clubPilotThemeOpenHidden)
    get :edit, :id => theme
    assert_response :success, "#{user_type} не смог зайти на страницу редактирования темы OpenHidden"
    theme = themes(:clubPilotThemeCloseHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseHidden"
    theme = themes(:clubPilotThemeToDelete)
  	get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы ToDelete"
  end
  
  test "Проверка доступности edit_path для club_friend" do 
	user_type = "ClubFriend"
	comeAsClubFriend
	#страницы редактирования чужих тем
	theme = themes(:clubPilotThemeOpenVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы OpenVisible"
    theme = themes(:clubPilotThemeCloseVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseVisible"
    theme = themes(:clubPilotThemeOpenHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы OpenHidden"
    theme = themes(:clubPilotThemeCloseHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseHidden"
    theme = themes(:clubPilotThemeToDelete)
  	get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы ToDelete"
	#страницы редактирования своих тем
	theme = themes(:clubFriendThemeOpenVisible)
    get :edit, :id => theme
    assert_response :success, "#{user_type} не смог зайти на страницу редактирования своей темы OpenVisible"
    theme = themes(:clubFriendThemeCloseVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseVisible"
    theme = themes(:clubFriendThemeOpenHidden)
    get :edit, :id => theme
    assert_response :success, "#{user_type} не смог зайти на страницу редактирования темы OpenHidden"
    theme = themes(:clubFriendThemeCloseHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseHidden"
    theme = themes(:clubFriendThemeToDelete)
	  get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы ToDelete"
  end
  
  test "Проверка доступности edit_path для bunned" do 
	user_type = "Bunned"
	comeAsBunned
	#страницы редактирования чужих тем
	theme = themes(:clubPilotThemeOpenVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы OpenVisible"
    theme = themes(:clubPilotThemeCloseVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseVisible"
    theme = themes(:clubPilotThemeOpenHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы OpenHidden"
    theme = themes(:clubPilotThemeCloseHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseHidden"
    theme = themes(:clubPilotThemeToDelete)
	  get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы ToDelete"
	#страницы редактирования своих тем
	theme = themes(:bunnedThemeOpenVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования своей темы OpenVisible"
    theme = themes(:bunnedThemeCloseVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseVisible"
    theme = themes(:bunnedThemeOpenHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы OpenHidden"
    theme = themes(:bunnedThemeCloseHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseHidden"
    theme = themes(:bunnedThemeToDelete)
	  get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы ToDelete"
  end
  
  test "Проверка доступности edit_path для deleted" do 
	user_type = "Deleted"
	comeAsDeleted
	#страницы редактирования чужих тем
	theme = themes(:clubPilotThemeOpenVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы OpenVisible"
    theme = themes(:clubPilotThemeCloseVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseVisible"
    theme = themes(:clubPilotThemeOpenHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы OpenHidden"
    theme = themes(:clubPilotThemeCloseHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseHidden"
    theme = themes(:clubPilotThemeToDelete)
	get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы ToDelete"

	#страницы редактирования своих тем
	theme = themes(:deletedThemeOpenVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования своей темы OpenVisible"
    theme = themes(:deletedThemeCloseVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseVisible"
    theme = themes(:deletedThemeOpenHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы OpenHidden"
    theme = themes(:deletedThemeCloseHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseHidden"
    theme = themes(:deletedThemeToDelete)
	  get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы ToDelete"
  end
  
  test "Проверка доступности edit_path для manager" do 
	user_type = "Manager"
	comeAsManager
	#страницы редактирования чужих тем
	theme = themes(:clubPilotThemeOpenVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы OpenVisible"
    theme = themes(:clubPilotThemeCloseVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseVisible"
    theme = themes(:clubPilotThemeOpenHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы OpenHidden"
    theme = themes(:clubPilotThemeCloseHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseHidden"
    theme = themes(:clubPilotThemeToDelete)
	get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы ToDelete"

	#страницы редактирования своих тем
	theme = themes(:managerThemeOpenVisible)
    get :edit, :id => theme
    assert_response :success, "#{user_type} не смог зайти на страницу редактирования своей темы OpenVisible"
    theme = themes(:managerThemeCloseVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseVisible"
    theme = themes(:managerThemeOpenHidden)
    get :edit, :id => theme
    assert_response :success, "#{user_type} не смог зайти на страницу редактирования темы OpenHidden"
    theme = themes(:managerThemeCloseHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseHidden"
    theme = themes(:managerThemeToDelete)
	  get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы ToDelete"
  end
  
  test "Проверка доступности edit_path для Admin" do 
	user_type = "Admin"
	comeAsAdmin
	#страницы редактирования чужих тем
	theme = themes(:clubPilotThemeOpenVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы OpenVisible"
    theme = themes(:clubPilotThemeCloseVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseVisible"
    theme = themes(:clubPilotThemeOpenHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы OpenHidden"
    theme = themes(:clubPilotThemeCloseHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseHidden"
    theme = themes(:clubPilotThemeToDelete)
	get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы ToDelete"

	#страницы редактирования своих тем
	theme = themes(:adminThemeOpenVisible)
    get :edit, :id => theme
    assert_response :success, "#{user_type} не смог зайти на страницу редактирования своей темы OpenVisible"
    theme = themes(:adminThemeCloseVisible)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseVisible"
    theme = themes(:adminThemeOpenHidden)
    get :edit, :id => theme
    assert_response :success, "#{user_type} не смог зайти на страницу редактирования темы OpenHidden"
    theme = themes(:adminThemeCloseHidden)
    get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы CloseHidden"
    theme = themes(:adminThemeToDelete)
	get :edit, :id => theme
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу редактирования темы ToDelete"	
  end
  
  test "Проверка доступности edit_path для SuperAdmin" do 
	user_type = "SuperAdmin"
	comeAsSuperAdmin
	#страницы редактирования чужих тем
	theme = themes(:clubPilotThemeOpenVisible)
    get :edit, :id => theme
    assert_response :success, "#{user_type} не смог зайти на страницу редактирования темы OpenVisible"
    theme = themes(:clubPilotThemeCloseVisible)
    get :edit, :id => theme
    assert_response :success, "#{user_type} не смог зайти на страницу редактирования темы CloseVisible"
    theme = themes(:clubPilotThemeOpenHidden)
    get :edit, :id => theme
     assert_response :success, "#{user_type} не смог зайти на страницу редактирования темы OpenHidden"
    theme = themes(:clubPilotThemeCloseHidden)
    get :edit, :id => theme
     assert_response :success, "#{user_type} не смог зайти на страницу редактирования темы CloseHidden"
    theme = themes(:clubPilotThemeToDelete)
	  get :edit, :id => theme
     assert_response :success, "#{user_type} не смог зайти на страницу редактирования темы ToDelete"

	#страницы редактирования своих тем
	theme = themes(:superAdminThemeOpenVisible)
    get :edit, :id => theme
    assert_response :success, "#{user_type} не смог зайти на страницу редактирования своей темы OpenVisible"
    theme = themes(:superAdminThemeCloseVisible)
    get :edit, :id => theme
    assert_response :success, "#{user_type} не смог зайти на страницу редактирования темы CloseVisible"
    theme = themes(:superAdminThemeOpenHidden)
    get :edit, :id => theme
    assert_response :success, "#{user_type} не смог зайти на страницу редактирования темы OpenHidden"
    theme = themes(:superAdminThemeCloseHidden)
    get :edit, :id => theme
    assert_response :success, "#{user_type} не смог зайти на страницу редактирования темы CloseHidden"
    theme = themes(:superAdminThemeToDelete)
	  get :edit, :id => theme
    assert_response :success, "#{user_type} не смог зайти на страницу редактирования темы ToDelete"
  end
  
#edit_path end


  
  test "Темы которые может видеть NewUser" do
    comeAsNewUser
	theme = themes(:newUserThemeToDelete) #своя удаленная открытая тема
	get :show, :id => theme
  assert_redirected_to '/404', "NewUser смог увидеть свою тему со статусом ToDelete"
  theme = themes(:clubPilotThemeOpenHidden) #чужая открытая приватная тема
	get :show, :id => theme
    assert_redirected_to '/404', "NewUser смог увидеть чужую скрытую тему со статусом themeHiddenOpen"
	theme = themes(:clubPilotThemeCloseHidden) #чужая закрытная приватная тема
	get :show, :id => theme
    assert_redirected_to '/404', "NewUser смог увидеть чужую скрытую тему со статусом themeHiddenClose"
	theme = themes(:newUserThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
    assert_response :success, "NewUser не смог увидеть свою открытую тему не приватную"
	theme = themes(:newUserThemeCloseVisible) #своя закрытая тема
	get :show, :id => theme
    assert_response :success, "NewUser не смог увидеть свою закрытую тему не приватную"
	theme = themes(:clubPilotThemeCloseVisible) #чужаю закрытая тема
	get :show, :id => theme
    assert_response :success, "NewUser не смог увидеть чужую закрытую тему не приватную"
	theme = themes(:clubPilotThemeOpenVisible) #чужаю открытая тема
	get :show, :id => theme
    assert_response :success, "NewUser не смог увидеть чужую открытую тему не приватную"
  end

  test "Темы которые может видеть Bunned" do
    comeAsBunned
	theme = themes(:bunnedThemeToDelete) #своя удаленная открытая тема
	get :show, :id => theme
  assert_redirected_to '/404', "Bunned смог увидеть свою тему со статусом ToDelete"
  theme = themes(:clubPilotThemeOpenHidden) #чужая открытая приватная тема
	get :show, :id => theme
    assert_redirected_to '/404', "Bunned смог увидеть чужую скрытую тему со статусом themeHiddenOpen"
	theme = themes(:clubPilotThemeCloseHidden) #чужая закрытная приватная тема
	get :show, :id => theme
    assert_redirected_to '/404', "Bunned смог увидеть чужую скрытую тему со статусом themeHiddenClose"
	theme = themes(:bunnedThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
    assert_response :success, "Bunned не смог увидеть свою открытую тему не приватную"
	theme = themes(:bunnedThemeCloseVisible) #своя закрытая тема
	get :show, :id => theme
    assert_response :success, "Bunned не смог увидеть свою закрытую тему не приватную"
	theme = themes(:bunnedThemeOpenHidden) #своя открытая приватная тема 
	get :show, :id => theme
    assert_response :success, "Bunned не смог увидеть свою открытую приватную тему "
	theme = themes(:bunnedThemeCloseHidden) #своя закрытая приватная тема
	get :show, :id => theme
    assert_response :success, "Bunned не смог увидеть свою закрытую приватную тему "
	theme = themes(:clubPilotThemeCloseVisible) #чужаю закрытая тема
	get :show, :id => theme
    assert_response :success, "Bunned не смог увидеть чужую закрытую тему не приватную"
	theme = themes(:clubPilotThemeOpenVisible) #чужаю открытая тема
	get :show, :id => theme
    assert_response :success, "Bunned не смог увидеть чужую открытую тему не приватную"
  end
  
  test "Темы которые может видеть Guest" do
    comeAsGuest
	theme = themes(:clubPilotThemeToDelete) #удаленная открытая тема
	get :show, :id => theme
    assert_redirected_to '/404', "Guest смог увидеть тему со статусом ToDelete"
  	theme = themes(:clubPilotThemeOpenHidden) #чужая открытая приватная тема
	get :show, :id => theme
    assert_redirected_to '/404', "Guest смог увидеть скрытую тему со статусом themeHiddenOpen"
	theme = themes(:clubPilotThemeCloseHidden) #чужая закрытная приватная тема
	get :show, :id => theme
    assert_redirected_to '/404', "Guest смог увидеть скрытую тему со статусом themeHiddenClose"
	theme = themes(:clubPilotThemeCloseVisible) #чужаю закрытая тема
	get :show, :id => theme
    assert_response :success, "Guest не смог увидеть закрытую тему не приватную"
	theme = themes(:clubPilotThemeOpenVisible) #чужаю открытая тема
	get :show, :id => theme
    assert_response :success, "Guest не смог увидеть открытую тему не приватную"
  end 
  
  test "Темы которые может видеть Manager" do
    comeAsManager
	theme = themes(:managerThemeToDelete) #удаленная открытая тема
	get :show, :id => theme
    assert_redirected_to '/404', "Manager смог увидеть тему со статусом ToDelete"
  	theme = themes(:clubPilotThemeOpenHidden) #чужая открытая приватная тема
	get :show, :id => theme
    assert_response :success, "Manager не смог увидеть скрытую тему со статусом themeHiddenOpen"
	theme = themes(:clubPilotThemeCloseHidden) #чужая закрытная приватная тема
	get :show, :id => theme
    assert_response :success, "Manager не смог увидеть скрытую тему со статусом themeHiddenClose"
	theme = themes(:clubPilotThemeCloseVisible) #чужаю закрытая тема
	get :show, :id => theme
    assert_response :success, "Manager не смог увидеть закрытую тему не приватную"
	theme = themes(:clubPilotThemeOpenVisible) #чужаю открытая тема
	get :show, :id => theme
    assert_response :success, "Manager не смог увидеть чужую открытую не приватную тему "
	
	theme = themes(:managerThemeOpenHidden) #своя открытая приватная тема
	get :show, :id => theme
    assert_response :success, "Manager не смог увидеть свою скрытую тему со статусом themeHiddenOpen"
	theme = themes(:managerThemeCloseHidden) #своя закрытная приватная тема
	get :show, :id => theme
    assert_response :success, "Manager не смог увидеть свою скрытую тему со статусом themeHiddenClose"
	theme = themes(:managerThemeCloseVisible) #своя закрытая тема
	get :show, :id => theme
    assert_response :success, "Manager не смог увидеть закрытую тему не приватную"
	theme = themes(:managerThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
    assert_response :success, "Manager не смог увидеть открытую тему не приватную"
  end 
  
  test "Темы которые может видеть ClubPilot" do
    comeAsClubPilot
	theme = themes(:clubPilotThemeToDelete) #удаленная открытая тема
	get :show, :id => theme
    assert_redirected_to '/404', "clubPilot смог увидеть тему со статусом ToDelete"
  	theme = themes(:clubFriendThemeOpenHidden) #чужая открытая приватная тема
	get :show, :id => theme
    assert_response :success, "clubPilot не смог увидеть скрытую тему со статусом themeHiddenOpen"
	theme = themes(:clubFriendThemeCloseHidden) #чужая закрытная приватная тема
	get :show, :id => theme
    assert_response :success, "clubPilot не смог увидеть скрытую тему со статусом themeHiddenClose"
	theme = themes(:clubFriendThemeCloseVisible) #чужаю закрытая тема
	get :show, :id => theme
    assert_response :success, "clubPilot не смог увидеть закрытую тему не приватную"
	theme = themes(:clubFriendThemeOpenVisible) #чужаю открытая тема
	get :show, :id => theme
    assert_response :success, "clubPilot не смог увидеть чужую открытую не приватную тему "
	
	theme = themes(:clubPilotThemeOpenHidden) #своя открытая приватная тема
	get :show, :id => theme
    assert_response :success, "clubPilot не смог увидеть свою скрытую тему со статусом themeHiddenOpen"
	theme = themes(:clubPilotThemeCloseHidden) #своя закрытная приватная тема
	get :show, :id => theme
    assert_response :success, "clubPilot не смог увидеть свою скрытую тему со статусом themeHiddenClose"
	theme = themes(:clubPilotThemeCloseVisible) #своя закрытая тема
	get :show, :id => theme
    assert_response :success, "clubPilot не смог увидеть закрытую тему не приватную"
	theme = themes(:clubPilotThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
    assert_response :success, "clubPilot не смог увидеть открытую тему не приватную"
  end 

  test "Темы которые может видеть ClubFriend" do
    comeAsClubFriend
	theme = themes(:clubFriendThemeToDelete) #удаленная открытая тема
	get :show, :id => theme
    assert_redirected_to '/404', "clubFriend смог увидеть тему со статусом ToDelete"
  	theme = themes(:clubPilotThemeOpenHidden) #чужая открытая приватная тема
	get :show, :id => theme
    assert_response :success, "clubFriend не смог увидеть скрытую тему со статусом themeHiddenOpen"
	theme = themes(:clubPilotThemeCloseHidden) #чужая закрытная приватная тема
	get :show, :id => theme
    assert_response :success, "clubFriend не смог увидеть скрытую тему со статусом themeHiddenClose"
	theme = themes(:clubPilotThemeCloseVisible) #чужаю закрытая тема
	get :show, :id => theme
    assert_response :success, "clubFriend не смог увидеть закрытую тему не приватную"
	theme = themes(:clubPilotThemeOpenVisible) #чужаю открытая тема
	get :show, :id => theme
    assert_response :success, "clubFriend не смог увидеть чужую открытую не приватную тему "
	
	theme = themes(:clubFriendThemeOpenHidden) #своя открытая приватная тема
	get :show, :id => theme
    assert_response :success, "clubFriend не смог увидеть свою скрытую тему со статусом themeHiddenOpen"
	theme = themes(:clubFriendThemeCloseHidden) #своя закрытная приватная тема
	get :show, :id => theme
    assert_response :success, "clubFriend не смог увидеть свою скрытую тему со статусом themeHiddenClose"
	theme = themes(:clubFriendThemeCloseVisible) #своя закрытая тема
	get :show, :id => theme
    assert_response :success, "clubFriend не смог увидеть закрытую тему не приватную"
	theme = themes(:clubFriendThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
    assert_response :success, "clubFriend не смог увидеть открытую тему не приватную"
  end   
  
  test "Темы которые может видеть Admin" do
    comeAsAdmin
	theme = themes(:adminThemeToDelete) #удаленная открытая тема
	get :show, :id => theme
    assert_redirected_to '/404', "Admin смог увидеть тему со статусом ToDelete"
  	theme = themes(:clubPilotThemeOpenHidden) #чужая открытая приватная тема
	get :show, :id => theme
    assert_response :success, "Admin не смог увидеть скрытую тему со статусом themeHiddenOpen"
	theme = themes(:clubPilotThemeCloseHidden) #чужая закрытная приватная тема
	get :show, :id => theme
    assert_response :success, "Admin не смог увидеть скрытую тему со статусом themeHiddenClose"
	theme = themes(:clubPilotThemeCloseVisible) #чужаю закрытая тема
	get :show, :id => theme
    assert_response :success, "Admin не смог увидеть закрытую тему не приватную"
	theme = themes(:clubPilotThemeOpenVisible) #чужаю открытая тема
	get :show, :id => theme
    assert_response :success, "Admin не смог увидеть чужую открытую не приватную тему "
	
	theme = themes(:adminThemeOpenHidden) #своя открытая приватная тема
	get :show, :id => theme
    assert_response :success, "Admin не смог увидеть свою скрытую тему со статусом themeHiddenOpen"
	theme = themes(:adminThemeCloseHidden) #своя закрытная приватная тема
	get :show, :id => theme
    assert_response :success, "Admin не смог увидеть свою скрытую тему со статусом themeHiddenClose"
	theme = themes(:adminThemeCloseVisible) #своя закрытая тема
	get :show, :id => theme
    assert_response :success, "Admin не смог увидеть закрытую тему не приватную"
	theme = themes(:adminThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
    assert_response :success, "Admin не смог увидеть открытую тему не приватную"
  end 
  test "Темы которые может видеть SuperAdmin" do
    comeAsSuperAdmin
	theme = themes(:clubPilotThemeToDelete) #удаленная открытая тема
	get :show, :id => theme
    assert_response :success, "SuperAdmin не смог увидеть тему со статусом ToDelete"
  	theme = themes(:clubPilotThemeOpenHidden) #чужая открытая приватная тема
	get :show, :id => theme
    assert_response :success, "SuperAdmin не смог увидеть скрытую тему со статусом themeHiddenOpen"
	theme = themes(:clubPilotThemeCloseHidden) #чужая закрытная приватная тема
	get :show, :id => theme
    assert_response :success, "SuperAdmin не смог увидеть скрытую тему со статусом themeHiddenClose"
	theme = themes(:clubPilotThemeCloseVisible) #чужаю закрытая тема
	get :show, :id => theme
    assert_response :success, "SuperAdmin не смог увидеть закрытую тему не приватную"
	theme = themes(:clubPilotThemeOpenVisible) #чужаю открытая тема
	get :show, :id => theme
    assert_response :success, "SuperAdmin не смог увидеть чужую открытую не приватную тему "
	
	theme = themes(:superAdminThemeOpenHidden) #своя открытая приватная тема
	get :show, :id => theme
    assert_response :success, "SuperAdmin не смог увидеть свою скрытую тему со статусом themeHiddenOpen"
	theme = themes(:superAdminThemeCloseHidden) #своя закрытная приватная тема
	get :show, :id => theme
    assert_response :success, "SuperAdmin не смог увидеть свою скрытую тему со статусом themeHiddenClose"
	theme = themes(:superAdminThemeCloseVisible) #своя закрытая тема
	get :show, :id => theme
    assert_response :success, "SuperAdmin не смог увидеть закрытую тему не приватную"
	theme = themes(:superAdminThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
    assert_response :success, "SuperAdmin не смог увидеть открытую тему не приватную"
  end   
  
  test "Темы которые может видеть Deleted" do
    comeAsDeleted
	theme = themes(:deletedThemeToDelete) #своя удаленная открытая тема
	get :show, :id => theme
    assert_redirected_to '/404', "Deleted смог увидеть свою тему со статусом ToDelete"
  	theme = themes(:clubPilotThemeOpenHidden) #чужая открытая приватная тема
	get :show, :id => theme
    assert_redirected_to '/404', "Deleted смог увидеть чужую скрытую тему со статусом themeHiddenOpen"
	theme = themes(:clubPilotThemeCloseHidden) #чужая закрытная приватная тема
	get :show, :id => theme
    assert_redirected_to '/404', "Deleted смог увидеть чужую скрытую тему со статусом themeHiddenClose"
	theme = themes(:deletedThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
    assert_response :success, "Deleted не смог увидеть свою открытую тему не приватную"
	theme = themes(:deletedThemeCloseVisible) #своя закрытая тема
	get :show, :id => theme
    assert_response :success, "Deleted не смог увидеть свою закрытую тему не приватную"
	theme = themes(:deletedThemeOpenHidden) #своя открытая приватная тема 
	get :show, :id => theme
    assert_response :success, "Deleted не смог увидеть свою открытую приватную тему "
	theme = themes(:deletedThemeCloseHidden) #своя закрытая приватная тема
	get :show, :id => theme
    assert_response :success, "Deleted не смог увидеть свою закрытую приватную тему "
	theme = themes(:clubPilotThemeCloseVisible) #чужаю закрытая тема
	get :show, :id => theme
    assert_response :success, "Deleted не смог увидеть чужую закрытую тему не приватную"
	theme = themes(:clubPilotThemeOpenVisible) #чужаю открытая тема
	get :show, :id => theme
    assert_response :success, "Deleted не смог увидеть чужую открытую тему не приватную"
  end
 #update_path 
test "Проверка доступности update_path для guest" do 
	comeAsGuest
	user_type = "Guest"
	themeFish = {:name => "#{user_type} update_path test", :content => defaultTextContent, :visibility_status_id => 2, :topic_id=> 6, :status_id => 1, :user_id => 666}
	theme = themes(:clubFriendThemeOpenVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить OpenVisible"
	theme = themes(:clubFriendThemeCloseVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить CloseVisible"
	theme = themes(:clubPilotThemeOpenHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить OpenHidden"
	theme = themes(:clubPilotThemeCloseHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить CloseHidden"
	theme = themes(:clubPilotThemeToDelete)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить ToDelete"
end

test "Проверка доступности update_path для new_user" do 
	user = comeAsNewUser
	user_type = "NewUser"
	i = 0
	themeFish = {:name => "#{user_type} update_path test", :content => defaultTextContent, :visibility_status_id => 2, :topic_id=> 6, :status_id => 1, :user_id => user.id}
	#страницы обновления чужих тем
	i += 1
	theme = themes(:clubFriendThemeOpenVisible)
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом OpenVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubFriendThemeCloseVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом CloseVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeOpenHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом OpenHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeCloseHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом CloseHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeToDelete)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом ToDelete"
  	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	#страницы обновления своих тем
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:newUserThemeOpenVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to theme_path(theme), "#{user_type} не смог обновить свою тему со статусом OpenVisible"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:newUserThemeCloseVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом CloseVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:newUserThemeToDelete)
	put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом ToDelete"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
  end
  
test "Проверка доступности update_path для club_pilot" do 
	user = comeAsClubPilot
	user_type = "ClubPilot"
	i = 0
	themeFish = {:name => "#{user_type} update_path test", :content => defaultTextContent}
	#страницы редактирования чужих тем
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubFriendThemeOpenVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом OpenVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubFriendThemeCloseVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом CloseVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubFriendThemeOpenHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом OpenHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubFriendThemeCloseHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом CloseHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubFriendThemeToDelete)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом ToDelete"
  	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"

	#страницы редактирования своих тем
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeOpenHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to theme_path(theme), "#{user_type} не смог обновить свою тему со статусом OpenHidden"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeCloseHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом CloseHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeOpenVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to theme_path(theme), "#{user_type} не смог обновить свою тему со статусом OpenVisible"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeCloseVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом CloseVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeToDelete)
	put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом ToDelete"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"


  end
  
  test "Проверка доступности update_path для club_friend" do 
	user = comeAsClubFriend
	user_type = "ClubFriend"
	i = 0
	themeFish = {:name => "#{user_type} update_path test", :content => defaultTextContent, :visibility_status_id => 1, :topic_id=> 1, :status_id => 1, :user_id => user.id}
	#страницы редактирования чужих тем
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeOpenVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом OpenVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeCloseVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом CloseVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeOpenHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом OpenHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeCloseHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом CloseHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeToDelete)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом ToDelete"
  	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"

	#страницы редактирования своих тем
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubFriendThemeOpenHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to theme_path(theme), "#{user_type} не смог обновить свою тему со статусом OpenHidden"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubFriendThemeCloseHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом CloseHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubFriendThemeOpenVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to theme_path(theme), "#{user_type} не смог обновить свою тему со статусом OpenVisible"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubFriendThemeCloseVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом CloseVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubFriendThemeToDelete)
	put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом ToDelete"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"


  end
  
  test "Проверка доступности update_path для Manager" do 
	user = comeAsManager
	user_type = "ClubManager"
	i = 0
	themeFish = {:name => "#{user_type} update_path test", :content => defaultTextContent, :visibility_status_id => 1, :topic_id=> 1, :status_id => 1, :user_id => user.id}
	#страницы редактирования чужих тем
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeOpenVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом OpenVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeCloseVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом CloseVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeOpenHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом OpenHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeCloseHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом CloseHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeToDelete)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом ToDelete"
  	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"

	#страницы редактирования своих тем
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:managerThemeOpenHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to theme_path(theme), "#{user_type} не смог обновить свою тему со статусом OpenHidden"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:managerThemeCloseHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом CloseHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:managerThemeOpenVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to theme_path(theme), "#{user_type} не смог обновить свою тему со статусом OpenVisible"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:managerThemeCloseVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом CloseVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:managerThemeToDelete)
	put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом ToDelete"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"


  end
  
  test "Проверка доступности update_path для Bunned" do 
	user = comeAsBunned
	user_type = "Bunned"
	i = 0
	themeFish = {:name => "#{user_type} update_path test", :content => defaultTextContent, :visibility_status_id => 1, :topic_id=> 1, :status_id => 1, :user_id => user.id}
	#страницы редактирования чужих тем
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeOpenVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом OpenVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeCloseVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом CloseVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeOpenHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом OpenHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeCloseHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом CloseHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeToDelete)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом ToDelete"
  	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"

	#страницы редактирования своих тем
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:bunnedThemeOpenHidden)
    put :update, :id => theme, :theme => themeFish
     assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом OpenHidden"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:bunnedThemeCloseHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом CloseHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:bunnedThemeOpenVisible)
    put :update, :id => theme, :theme => themeFish
     assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом OpenVisible"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:bunnedThemeCloseVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом CloseVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:bunnedThemeToDelete)
	put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом ToDelete"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"


  end
 
  test "Проверка доступности update_path для Deleted" do 
	user = comeAsDeleted
	user_type = "Deleted"
	i = 0
	themeFish = {:name => "#{user_type} update_path test", :content => defaultTextContent, :visibility_status_id => 1, :topic_id=> 1, :status_id => 1, :user_id => user.id}
	#страницы редактирования чужих тем
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeOpenVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом OpenVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeCloseVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом CloseVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeOpenHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом OpenHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeCloseHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом CloseHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeToDelete)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом ToDelete"
  	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"

	#страницы редактирования своих тем
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:deletedThemeOpenHidden)
    put :update, :id => theme, :theme => themeFish
     assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом OpenHidden"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:deletedThemeCloseHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом CloseHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:deletedThemeOpenVisible)
    put :update, :id => theme, :theme => themeFish
     assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом OpenVisible"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:deletedThemeCloseVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом CloseVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:deletedThemeToDelete)
	put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом ToDelete"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"


  end
  
  test "Проверка доступности update_path для Admin" do 
	user = comeAsAdmin
	user_type = "Admin"
	i = 0
	themeFish = {:name => "#{user_type} update_path test", :content => defaultTextContent, :visibility_status_id => 1, :topic_id=> 1, :status_id => 1, :user_id => user.id}
	#страницы редактирования чужих тем
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeOpenVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом OpenVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeCloseVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом CloseVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeOpenHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом OpenHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeCloseHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом CloseHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeToDelete)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить чужую тему со статусом ToDelete"
  	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"

	#страницы редактирования своих тем
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:adminThemeOpenHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to theme_path(theme), "#{user_type} не смог обновить свою тему со статусом OpenHidden"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:adminThemeCloseHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом CloseHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:adminThemeOpenVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to theme_path(theme), "#{user_type} не смог обновить свою тему со статусом OpenVisible"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:adminThemeCloseVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом CloseVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:adminThemeToDelete)
	put :update, :id => theme, :theme => themeFish
    assert_redirected_to '/404', "#{user_type} смог обновить свою тему со статусом ToDelete"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"


  end
  
test "Проверка доступности update_path для SuperAdmin" do 
	user = comeAsSuperAdmin
	user_type = "SuperAdmin"
	i = 0
	themeFish = {:name => "#{user_type} update_path test", :content => defaultTextContent, :visibility_status_id => 1, :topic_id=> 1, :status_id => 1, :user_id => user.id}
	#страницы редактирования чужих тем
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeOpenVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to theme_path(theme), "#{user_type} не смог обновить чужую тему со статусом OpenVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeCloseVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to theme_path(theme), "#{user_type} не смог обновить чужую тему со статусом CloseVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeOpenHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to theme_path(theme), "#{user_type} не смог обновить чужую тему со статусом OpenHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeCloseHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to theme_path(theme), "#{user_type} не смог обновить чужую тему со статусом CloseHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:clubPilotThemeToDelete)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to theme_path(theme), "#{user_type} не смог обновить чужую тему со статусом ToDelete"
  	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"

	#страницы редактирования своих тем
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:superAdminThemeOpenHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to theme_path(theme), "#{user_type} не смог обновить свою тему со статусом OpenHidden"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:superAdminThemeCloseHidden)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to theme_path(theme), "#{user_type} не смог обновить свою тему со статусом CloseHidden"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:superAdminThemeOpenVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to theme_path(theme), "#{user_type} не смог обновить свою тему со статусом OpenVisible"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:superAdminThemeCloseVisible)
    put :update, :id => theme, :theme => themeFish
    assert_redirected_to theme_path(theme), "#{user_type} не смог обновить свою тему со статусом CloseVisible"
	i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"
	theme = themes(:superAdminThemeToDelete)
	put :update, :id => theme, :theme => themeFish
    assert_redirected_to theme_path(theme), "#{user_type} не смог обновить свою тему со статусом ToDelete"
    i += 1
	themeFish[:name] = "#{user_type} update_path test #{i.to_s}"


  end
#update_path end   
#destroy path 
 test "Проверка доступности destroy_path для guest" do 
	comeAsGuest
	user_type = "Guest"
	theme = themes(:clubFriendThemeOpenVisible)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом OpenVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы OpenVisible"
    theme = themes(:clubFriendThemeCloseVisible)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом CloseVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы CloseVisible"
    theme = themes(:clubPilotThemeOpenHidden)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом OpenHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы OpenHidden"
    theme = themes(:clubPilotThemeCloseHidden)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом CloseHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы CloseHidden"
    theme = themes(:clubPilotThemeToDelete)
	assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом ToDelete") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы ToDelete"

  
  end
  
  
  test "Проверка доступности destroy_path для new_user" do 
	user_type = "NewUser"
	comeAsNewUser
	#страницы редактирования чужих тем
	theme = themes(:clubFriendThemeOpenVisible)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом OpenVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы OpenVisible"
    theme = themes(:clubFriendThemeCloseVisible)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом CloseVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы CloseVisible"
    theme = themes(:clubPilotThemeOpenHidden)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом OpenHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы OpenHidden"
    theme = themes(:clubPilotThemeCloseHidden)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом CloseHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы CloseHidden"
    theme = themes(:clubPilotThemeToDelete)
	assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом ToDelete") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы ToDelete"

  
	#страницы редактирования своих тем
	theme = themes(:newUserThemeOpenVisible)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом OpenVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован после удаления в раздел где находилась тема OpenVisible"
    theme = themes(:newUserThemeCloseVisible)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом CloseVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован после удаления в раздел где находилась тема CloseVisible"
    theme = themes(:newUserThemeToDelete)
	assert_no_difference('Theme.count', "#{user_type} смог удалить свою тему со статусом ToDelete") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы ToDelete"
 
	
  end
  
  test "Проверка доступности destroy_path для ClubFriend" do 
	user_type = "ClubFriend"
	comeAsClubFriend
	#удаление чужих тем
	theme = themes(:clubPilotThemeOpenVisible)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом OpenVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы OpenVisible"
    theme = themes(:clubPilotThemeCloseVisible)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом CloseVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы CloseVisible"
    theme = themes(:clubPilotThemeOpenHidden)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом OpenHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы OpenHidden"
    theme = themes(:clubPilotThemeCloseHidden)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом CloseHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы CloseHidden"
    theme = themes(:clubPilotThemeToDelete)
	assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом ToDelete") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы ToDelete"

	#удаление своих тем
	theme = themes(:clubFriendThemeOpenHidden)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом OpenHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован после удаления в раздел где находилась тема OpenVisible"
    theme = themes(:clubFriendThemeCloseHidden)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом CloseHidden") do
      delete :destroy, :id => theme
    end
	
	theme = themes(:clubFriendThemeOpenVisible)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом OpenVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован после удаления в раздел где находилась тема OpenVisible"
    theme = themes(:clubFriendThemeCloseVisible)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом CloseVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован после удаления в раздел где находилась тема CloseVisible"
    theme = themes(:clubFriendThemeToDelete)
	assert_no_difference('Theme.count', "#{user_type} смог удалить свою тему со статусом ToDelete") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы ToDelete"
  end
  
  test "Проверка доступности destroy_path для ClubPilot" do 
	user_type = "ClubPilot"
	comeAsClubPilot
	#удаление чужих тем
	theme = themes(:clubFriendThemeOpenVisible)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом OpenVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы OpenVisible"
    theme = themes(:clubFriendThemeCloseVisible)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом CloseVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы CloseVisible"
    theme = themes(:clubFriendThemeOpenHidden)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом OpenHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы OpenHidden"
    theme = themes(:clubFriendThemeCloseHidden)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом CloseHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы CloseHidden"
    theme = themes(:clubFriendThemeToDelete)
	assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом ToDelete") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы ToDelete"
  
	#удаление своих тем
	theme = themes(:clubPilotThemeOpenHidden)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом OpenHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован после удаления в раздел где находилась тема OpenVisible"
    theme = themes(:clubPilotThemeCloseHidden)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом CloseHidden") do
      delete :destroy, :id => theme
    end
	
	theme = themes(:clubPilotThemeOpenVisible)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом OpenVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован после удаления в раздел где находилась тема OpenVisible"
    theme = themes(:clubPilotThemeCloseVisible)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом CloseVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован после удаления в раздел где находилась тема CloseVisible"
    theme = themes(:clubPilotThemeToDelete)
	assert_no_difference('Theme.count', "#{user_type} смог удалить свою тему со статусом ToDelete") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы ToDelete"
	
  end
  
  test "Проверка доступности destroy_path для Manager" do 
	user_type = "Manager"
	comeAsManager
	#удаление чужих тем
	theme = themes(:clubFriendThemeOpenVisible)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом OpenVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы OpenVisible"
    theme = themes(:clubFriendThemeCloseVisible)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом CloseVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы CloseVisible"
    theme = themes(:clubFriendThemeOpenHidden)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом OpenHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы OpenHidden"
    theme = themes(:clubFriendThemeCloseHidden)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом CloseHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы CloseHidden"
    theme = themes(:clubFriendThemeToDelete)
	assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом ToDelete") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы ToDelete"
  
	#удаление своих тем
	theme = themes(:managerThemeOpenHidden)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом OpenHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован после удаления в раздел где находилась тема OpenVisible"
    theme = themes(:managerThemeCloseHidden)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом CloseHidden") do
      delete :destroy, :id => theme
    end
	
	theme = themes(:managerThemeOpenVisible)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом OpenVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован после удаления в раздел где находилась тема OpenVisible"
    theme = themes(:managerThemeCloseVisible)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом CloseVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован после удаления в раздел где находилась тема CloseVisible"
    theme = themes(:managerThemeToDelete)
	assert_no_difference('Theme.count', "#{user_type} смог удалить свою тему со статусом ToDelete") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы ToDelete"
  end
  
  test "Проверка доступности destroy_path для Bunned" do 
	user_type = "Bunned"
	comeAsBunned
	#удаление чужих тем
	theme = themes(:clubFriendThemeOpenVisible)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом OpenVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы OpenVisible"
    theme = themes(:clubFriendThemeCloseVisible)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом CloseVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы CloseVisible"
    theme = themes(:clubFriendThemeOpenHidden)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом OpenHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы OpenHidden"
    theme = themes(:clubFriendThemeCloseHidden)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом CloseHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы CloseHidden"
    theme = themes(:clubFriendThemeToDelete)
	assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом ToDelete") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы ToDelete"
  
	#удаление своих тем
	theme = themes(:bunnedThemeOpenHidden)
    assert_no_difference('Theme.count', "#{user_type} смог удалить свою тему со статусом OpenHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} не был переадресован после удаления в раздел где находилась тема OpenVisible"
    theme = themes(:bunnedThemeCloseHidden)
    assert_no_difference('Theme.count', "#{user_type} не смог удалить свою тему со статусом CloseHidden") do
      delete :destroy, :id => theme
    end
	assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы CloseHidden"
	theme = themes(:bunnedThemeOpenVisible)
    assert_no_difference('Theme.count', "#{user_type} не смог удалить свою тему со статусом OpenVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы OpenVisible"
    theme = themes(:bunnedThemeCloseVisible)
    assert_no_difference('Theme.count', "#{user_type} не смог удалить свою тему со статусом CloseVisible") do
      delete :destroy, :id => theme
    end
     assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы CloseVisible"
    theme = themes(:bunnedThemeToDelete)
	assert_no_difference('Theme.count', "#{user_type} смог удалить свою тему со статусом ToDelete") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы ToDelete"
  end
  
  test "Проверка доступности destroy_path для Deleted" do 
	user_type = "Deleted"
	comeAsDeleted
	#удаление чужих тем
	theme = themes(:clubFriendThemeOpenVisible)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом OpenVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы OpenVisible"
    theme = themes(:clubFriendThemeCloseVisible)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом CloseVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы CloseVisible"
    theme = themes(:clubFriendThemeOpenHidden)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом OpenHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы OpenHidden"
    theme = themes(:clubFriendThemeCloseHidden)
    assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом CloseHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы CloseHidden"
    theme = themes(:clubFriendThemeToDelete)
	assert_no_difference('Theme.count', "#{user_type} смог удалить тему со статусом ToDelete") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы ToDelete"
	#удаление своих тем
	theme = themes(:deletedThemeOpenHidden)
    assert_no_difference('Theme.count', "#{user_type} смог удалить свою тему со статусом OpenHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} не был переадресован после удаления в раздел где находилась тема OpenVisible"
    theme = themes(:deletedThemeCloseHidden)
    assert_no_difference('Theme.count', "#{user_type} не смог удалить свою тему со статусом CloseHidden") do
      delete :destroy, :id => theme
    end
	assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы CloseHidden"
	theme = themes(:deletedThemeOpenVisible)
    assert_no_difference('Theme.count', "#{user_type} не смог удалить свою тему со статусом OpenVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы OpenVisible"
    theme = themes(:deletedThemeCloseVisible)
    assert_no_difference('Theme.count', "#{user_type} не смог удалить свою тему со статусом CloseVisible") do
      delete :destroy, :id => theme
    end
     assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы CloseVisible"
    theme = themes(:deletedThemeToDelete)
	assert_no_difference('Theme.count', "#{user_type} смог удалить свою тему со статусом ToDelete") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы ToDelete"
   end
  
  test "Проверка доступности destroy_path для Admin" do 
	user_type = "Admin"
	comeAsAdmin
	#удаление чужих тем
	theme = themes(:clubFriendThemeOpenVisible)
  assert_no_difference('Theme.count', "#{user_type} удалил тему OpenVisible") do
     delete :destroy, :id => theme
  end
  assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован в раздел темы OpenVisible"
  theme = Theme.find(theme.id)
  assert theme.status_id == 2, "#{user_type} не удалось поменять статус Open на to_delete"
  
  theme = themes(:clubFriendThemeCloseVisible)
  assert_no_difference('Theme.count', "#{user_type} удалил тему CloseVisible") do
     delete :destroy, :id => theme
  end
  assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован в раздел темы CloseVisible"
  theme = Theme.find(theme.id)
  assert theme.status_id == 2, "#{user_type} не удалось поменять статус Close на to_delete"
  
  theme = themes(:clubFriendThemeToDelete)
  assert_no_difference('Theme.count', "#{user_type} смог удалить чужую тему со статусом ToDelete") do
    delete :destroy, :id => theme
  end
  assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы ToDelete"
  
	#удаление своих тем
	theme = themes(:adminThemeOpenHidden)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом OpenHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован после удаления в раздел где находилась тема OpenVisible"
    theme = themes(:adminThemeCloseHidden)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом CloseHidden") do
      delete :destroy, :id => theme
    end
	
	theme = themes(:adminThemeOpenVisible)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом OpenVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован после удаления в раздел где находилась тема OpenVisible"
    theme = themes(:adminThemeCloseVisible)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом CloseVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован после удаления в раздел где находилась тема CloseVisible"
    theme = themes(:adminThemeToDelete)
    assert_no_difference('Theme.count', "#{user_type} смог удалить свою тему со статусом ToDelete") do
      delete :destroy, :id => theme
    end
    assert_redirected_to '/404', "#{user_type} смог зайти на страницу удаления темы ToDelete"
  end
  
  test "Проверка доступности destroy_path для SuperAdmin" do 
	user_type = "SuperAdmin"
	comeAsSuperAdmin
	#удаление чужих тем
	theme = themes(:clubPilotThemeOpenVisible)
  assert_no_difference('Theme.count', "#{user_type} удалил тему OpenVisible") do
     delete :destroy, :id => theme
  end
  assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован в раздел темы OpenVisible"
  theme = Theme.find(theme.id)
  assert theme.status_id == 2, "#{user_type} не удалось поменять статус Open на to_delete"
  
  theme = themes(:clubPilotThemeCloseVisible)
  assert_no_difference('Theme.count', "#{user_type} удалил тему CloseVisible") do
     delete :destroy, :id => theme
  end
  assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован в раздел темы CloseVisible"
  theme = Theme.find(theme.id)
  assert theme.status_id == 2, "#{user_type} не удалось поменять статус Close на to_delete"
  
  theme = themes(:clubPilotThemeToDelete)
  assert_difference('Theme.count', -1, "#{user_type} не смог удалить чужую тему со статусом ToDelete") do
    delete :destroy, :id => theme
  end
  assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован в раздел темы ToDelete"
  
	#удаление своих тем
	theme = themes(:superAdminThemeOpenHidden)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом OpenHidden") do
      delete :destroy, :id => theme
    end
    assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован после удаления в раздел где находилась тема OpenVisible"
    theme = themes(:superAdminThemeCloseHidden)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом CloseHidden") do
      delete :destroy, :id => theme
    end
	assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован после удаления в раздел где находилась тема CloseHidden"
	theme = themes(:superAdminThemeOpenVisible)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом OpenVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован после удаления в раздел где находилась тема OpenVisible"
    theme = themes(:superAdminThemeCloseVisible)
    assert_difference('Theme.count', -1,"#{user_type} не смог удалить свою тему со статусом CloseVisible") do
      delete :destroy, :id => theme
    end
    assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован после удаления в раздел где находилась тема CloseVisible"
    theme = themes(:superAdminThemeToDelete)
	assert_difference('Theme.count', -1, "#{user_type} не смог удалить свою тему со статусом ToDelete") do
      delete :destroy, :id => theme
    end
    assert_redirected_to topic_path(theme.topic), "#{user_type} не был переадресован после удаления в раздел где находилась тема ToDelete"
 
  end
  
  test 'Видимые кнопки в разделе show path темы для Manager' do
	comeAsManager
	user_type = 'Manager'
	theme = themes(:managerThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeClose', 1, "#{user_type} не видит кнопку закрыть тему")
	assert_select('a#deleteTheme', 1, "#{user_type} не видит кнопку удалить тему OpenVisible")
	assert_select('a#editTheme', 1, "#{user_type} не видит кнопку редактировать тему OpenVisible")
	assert_select('a#newMsgBut', 1, "#{user_type} не видит кнопку добавления сообщения в тему OpenVisible")
	assert_select('form.message_form', 1, "#{user_type} не видит форму добавления сообщения в тему OpenVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в openVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:managerThemeCloseVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeOpen', 1, "#{user_type} не видит кнопку открыть тему")
	assert_select('a#deleteTheme', 1, "#{user_type} не видит кнопку удалить тему CloseVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему closeVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в тему closeVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему closeVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в closeVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:clubFriendThemeCloseVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeOpen', 0, "#{user_type} видит кнопку открыть тему в чужой теме")
	assert_select('a#deleteTheme', 0, "#{user_type} видит кнопку удаления чужой темы CloseVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему closeVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в тему closeVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в чужую тему closeVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в чужой теме closeVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:clubPilotThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeClose', 0, "#{user_type} видит кнопку закрыть тему в чужой теме")
	assert_select('a#deleteTheme', 0, "#{user_type} видит кнопку удалить тему в чужой теме OpenVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему в чужой теме OpenVisible")
	assert_select('a#newMsgBut', 1, "#{user_type} не видит кнопку добавления сообщения в чужую тему OpenVisible")
	assert_select('form.message_form', 1, "#{user_type} не видит форму добавления сообщения в чужую тему OpenVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в чужой теме OpenVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
  end
  
  test 'Видимые кнопки в разделе show path темы для Guest' do
	comeAsGuest
	user_type = 'Guest'
	theme = themes(:clubFriendThemeCloseVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeOpen', 0, "#{user_type} видит кнопку открыть тему в чужой теме")
	assert_select('a#deleteTheme', 0, "#{user_type} видит кнопку удаления чужой темы CloseVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему closeVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в тему closeVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему closeVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в чужой теме closeVisible")
  assert_select('a#watchTheme', 0, "#{user_type} видит кнопку 'Отслеживаться тему'")
	theme = themes(:clubPilotThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeClose', 0, "#{user_type} видит кнопку закрыть тему в чужой теме")
	assert_select('a#deleteTheme', 0, "#{user_type} видит кнопку удалить тему в чужой теме OpenVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему в чужой теме OpenVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в чужую тему OpenVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему OpenVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в чужой теме OpenVisible")
  assert_select('a#watchTheme', 0, "#{user_type} видит кнопку 'Отслеживаться тему'")
  end
  
    test 'Видимые кнопки в разделе show path темы для NewUser' do
	comeAsNewUser
	user_type = 'NewUser'
	theme = themes(:newUserThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeClose', 1, "#{user_type} не видит кнопку закрыть тему")
	assert_select('a#deleteTheme', 1, "#{user_type} не видит кнопку удалить тему OpenVisible")
	assert_select('a#editTheme', 1, "#{user_type} не видит кнопку редактировать тему OpenVisible")
	assert_select('a#newMsgBut', 1, "#{user_type} не видит кнопку добавления сообщения в тему OpenVisible")
	assert_select('form.message_form', 1, "#{user_type} не видит форму добавления сообщения в тему OpenVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в openVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:newUserThemeCloseVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeOpen', 1, "#{user_type} не видит кнопку открыть тему")
	assert_select('a#deleteTheme', 1, "#{user_type} не видит кнопку удалить тему CloseVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему closeVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в тему closeVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему closeVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в closeVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:clubFriendThemeCloseVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeOpen', 0, "#{user_type} видит кнопку открыть тему в чужой теме")
	assert_select('a#deleteTheme', 0, "#{user_type} видит кнопку удаления чужой темы CloseVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему closeVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в тему closeVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему closeVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в чужой теме closeVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:clubPilotThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeClose', 0, "#{user_type} видит кнопку закрыть тему в чужой теме")
	assert_select('a#deleteTheme', 0, "#{user_type} видит кнопку удалить тему в чужой теме OpenVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему в чужой теме OpenVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в чужую тему OpenVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в чужую тему OpenVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в чужой теме OpenVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme.update_attribute(:topic_id, 6)
	get :show, :id => theme
	assert_select('a#themeClose', 0, "#{user_type} видит кнопку закрыть тему в чужой теме")
	assert_select('a#deleteTheme', 0, "#{user_type} видит кнопку удалить тему в чужой теме OpenVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему в чужой теме OpenVisible")
	assert_select('a#newMsgBut', 1, "#{user_type} не видит кнопку добавления сообщения в чужую тему OpenVisible раздела FAQ")
	assert_select('form.message_form', 1, "#{user_type} не видит форму добавления сообщения в чужую тему OpenVisible раздела FAQ")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в чужой теме OpenVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:newUserThemeOpenVisible) #своя открытая тема
	theme.update_attribute(:topic_id, 1)
	get :show, :id => theme
	assert_select('a#themeClose', 1, "#{user_type} не видит кнопку закрыть тему в разделе не FAQ")
	assert_select('a#deleteTheme', 1, "#{user_type} не видит кнопку удалить тему OpenVisible в разделе не FAQ")
	assert_select('a#editTheme', 1, "#{user_type} не видит кнопку редактировать тему OpenVisible в разделе не FAQ")
	assert_select('a#newMsgBut', 1, "#{user_type} не видит кнопку добавления сообщения в свою тему OpenVisible в разделе не FAQ")
	assert_select('form.message_form', 1, "#{user_type} не видит форму добавления сообщения в свою тему OpenVisible раздела не FAQ")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в openVisible в разделе не FAQ")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
  end
  
  test 'Видимые кнопки в разделе show path темы для ClubFriend' do
	comeAsClubFriend
	user_type = 'ClubFriend'
	theme = themes(:clubFriendThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeClose', 1, "#{user_type} не видит кнопку закрыть тему")
	assert_select('a#deleteTheme', 1, "#{user_type} не видит кнопку удалить тему OpenVisible")
	assert_select('a#editTheme', 1, "#{user_type} не видит кнопку редактировать тему OpenVisible")
	assert_select('a#newMsgBut', 1, "#{user_type} не видит кнопку добавления сообщения в тему OpenVisible")
	assert_select('form.message_form', 1, "#{user_type} не видит форму добавления сообщения в тему OpenVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в openVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:clubFriendThemeCloseVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeOpen', 1, "#{user_type} не видит кнопку открыть тему")
	assert_select('a#deleteTheme', 1, "#{user_type} не видит кнопку удалить тему CloseVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему closeVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в тему closeVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему closeVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в closeVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:clubPilotThemeCloseVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeOpen', 0, "#{user_type} видит кнопку открыть тему в чужой теме")
	assert_select('a#deleteTheme', 0, "#{user_type} видит кнопку удаления чужой темы CloseVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему closeVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в тему closeVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему closeVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в чужой теме closeVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:managerThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeClose', 0, "#{user_type} видит кнопку закрыть тему в чужой теме")
	assert_select('a#deleteTheme', 0, "#{user_type} видит кнопку удалить тему в чужой теме OpenVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему в чужой теме OpenVisible")
	assert_select('a#newMsgBut', 1, "#{user_type} не видит кнопку добавления сообщения в чужую тему OpenVisible")
	assert_select('form.message_form', 1, "#{user_type} не видит форму добавления сообщения в тему OpenVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в чужой теме OpenVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
  end
  test 'Видимые кнопки в разделе show path темы для ClubPilot' do
	comeAsClubPilot
	user_type = 'ClubPilot'
	theme = themes(:clubPilotThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeClose', 1, "#{user_type} не видит кнопку закрыть тему")
	assert_select('a#deleteTheme', 1, "#{user_type} не видит кнопку удалить тему OpenVisible")
	assert_select('a#editTheme', 1, "#{user_type} не видит кнопку редактировать тему OpenVisible")
	assert_select('a#newMsgBut', 1, "#{user_type} не видит кнопку добавления сообщения в тему OpenVisible")
	assert_select('form.message_form', 1, "#{user_type} не видит форму добавления сообщения в тему OpenVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в openVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:clubPilotThemeCloseVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeOpen', 1, "#{user_type} не видит кнопку открыть тему")
	assert_select('a#deleteTheme', 1, "#{user_type} не видит кнопку удалить тему CloseVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему closeVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в тему closeVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему closeVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в closeVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:clubFriendThemeCloseVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeOpen', 0, "#{user_type} видит кнопку открыть тему в чужой теме")
	assert_select('a#deleteTheme', 0, "#{user_type} видит кнопку удаления чужой темы CloseVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему closeVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в тему closeVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему closeVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в чужой теме closeVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:managerThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeClose', 0, "#{user_type} видит кнопку закрыть тему в чужой теме")
	assert_select('a#deleteTheme', 0, "#{user_type} видит кнопку удалить тему в чужой теме OpenVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему в чужой теме OpenVisible")
	assert_select('a#newMsgBut', 1, "#{user_type} не видит кнопку добавления сообщения в чужую тему OpenVisible")
	assert_select('form.message_form', 1, "#{user_type} не видит форму добавления сообщения в тему openVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в чужой теме OpenVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
  end
  test 'Видимые кнопки в разделе show path темы для Bunned' do
	comeAsBunned
	user_type = 'Bunned'
	theme = themes(:bunnedThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeClose', 0, "#{user_type} видит кнопку закрыть тему")
	assert_select('a#deleteTheme', 0, "#{user_type} видит кнопку удалить тему OpenVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему OpenVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в тему OpenVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему openVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в openVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:bunnedThemeCloseVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeOpen', 0, "#{user_type} видит кнопку открыть тему")
	assert_select('a#deleteTheme', 0, "#{user_type} видит кнопку удалить тему CloseVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему closeVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в тему closeVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему closeVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в closeVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:clubFriendThemeCloseVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeOpen', 0, "#{user_type} видит кнопку открыть тему в чужой теме")
	assert_select('a#deleteTheme', 0, "#{user_type} видит кнопку удаления чужой темы CloseVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему closeVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в тему closeVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему closeVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в чужой теме closeVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:managerThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeClose', 0, "#{user_type} видит кнопку закрыть тему в чужой теме")
	assert_select('a#deleteTheme', 0, "#{user_type} видит кнопку удалить тему в чужой теме OpenVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему в чужой теме OpenVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в чужую тему OpenVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему OpenVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в чужой теме OpenVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
  end
  test 'Видимые кнопки в разделе show path темы для Deleted' do
	comeAsDeleted
	user_type = 'Deleted'
	theme = themes(:deletedThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeClose', 0, "#{user_type} видит кнопку закрыть тему")
	assert_select('a#deleteTheme', 0, "#{user_type} видит кнопку удалить тему OpenVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему OpenVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в тему OpenVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему OpenVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в openVisible")
  assert_select('a#watchTheme', 0, "#{user_type} видит кнопку 'Отслеживаться тему'")
	theme = themes(:deletedThemeCloseVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeOpen', 0, "#{user_type} видит кнопку открыть тему")
	assert_select('a#deleteTheme', 0, "#{user_type} видит кнопку удалить тему CloseVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему closeVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в тему closeVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему closeVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в closeVisible")
  assert_select('a#watchTheme', 0, "#{user_type} видит кнопку 'Отслеживаться тему'")
	theme = themes(:clubFriendThemeCloseVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeOpen', 0, "#{user_type} видит кнопку открыть тему в чужой теме")
	assert_select('a#deleteTheme', 0, "#{user_type} видит кнопку удаления чужой темы CloseVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему closeVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в тему closeVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему closeVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в чужой теме closeVisible")
  assert_select('a#watchTheme', 0, "#{user_type} видит кнопку 'Отслеживаться тему'")
	theme = themes(:managerThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeClose', 0, "#{user_type} видит кнопку закрыть тему в чужой теме")
	assert_select('a#deleteTheme', 0, "#{user_type} видит кнопку удалить тему в чужой теме OpenVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему в чужой теме OpenVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в чужую тему OpenVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему OpenVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в чужой теме OpenVisible")
  assert_select('a#watchTheme', 0, "#{user_type} видит кнопку 'Отслеживаться тему'")
  end
  test 'Видимые кнопки в разделе show path темы для Admin' do
	comeAsAdmin
	user_type = 'Admin'
	theme = themes(:adminThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeClose', 1, "#{user_type} не видит кнопку закрыть тему")
	assert_select('a#deleteTheme', 1, "#{user_type} не видит кнопку удалить тему OpenVisible")
	assert_select('a#editTheme', 1, "#{user_type} не видит кнопку редактировать тему OpenVisible")
	assert_select('a#newMsgBut', 1, "#{user_type} не видит кнопку добавления сообщения в тему OpenVisible")
	assert_select('form.message_form', 1, "#{user_type} не видит форму добавления сообщения в тему OpenVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в openVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:adminThemeCloseVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeOpen', 1, "#{user_type} не видит кнопку открыть тему")
	assert_select('a#deleteTheme', 1, "#{user_type} не видит кнопку удалить тему CloseVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему closeVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в тему closeVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему closeVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в closeVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:clubFriendThemeCloseVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeOpen', 1, "#{user_type} видит кнопку открыть тему в чужой теме")
	assert_select('a#deleteTheme', 1, "#{user_type} видит кнопку удаления чужой темы CloseVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему closeVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в тему closeVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему closeVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в чужой теме closeVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:managerThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeClose', 1, "#{user_type} видит кнопку закрыть тему в чужой теме")
	assert_select('a#deleteTheme', 1, "#{user_type} видит кнопку удалить тему в чужой теме OpenVisible")
	assert_select('a#editTheme', 0, "#{user_type} видит кнопку редактировать тему в чужой теме OpenVisible")
	assert_select('a#newMsgBut', 1, "#{user_type} не видит кнопку добавления сообщения в чужую тему OpenVisible")
	assert_select('form.message_form', 1, "#{user_type} не видит форму добавления сообщения в тему openVisible")
	assert_select('a#mergeTheme', 0, "#{user_type} видит кнопку слияния тем в чужой теме OpenVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
  end
  test 'Видимые кнопки в разделе show path темы для SuperAdmin' do
	comeAsSuperAdmin
	user_type = 'SuperAdmin'
	theme = themes(:superAdminThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeClose', 1, "#{user_type} не видит кнопку закрыть тему")
	assert_select('a#deleteTheme', 1, "#{user_type} не видит кнопку удалить тему OpenVisible")
	assert_select('a#editTheme', 1, "#{user_type} не видит кнопку редактировать тему OpenVisible")
	assert_select('a#newMsgBut', 1, "#{user_type} не видит кнопку добавления сообщения в тему OpenVisible")
	assert_select('form.message_form', 1, "#{user_type} не видит форму добавления сообщения в тему openVisible")
	assert_select('a#mergeTheme', 1, "#{user_type} видит кнопку слияния тем в openVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:superAdminThemeCloseVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeOpen', 1, "#{user_type} не видит кнопку открыть тему")
	assert_select('a#deleteTheme', 1, "#{user_type} не видит кнопку удалить тему CloseVisible")
	assert_select('a#editTheme', 1, "#{user_type} не видит кнопку редактировать тему closeVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в тему closeVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему closeVisible")
	assert_select('a#mergeTheme', 1, "#{user_type} не видит кнопку слияния тем в closeVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:clubFriendThemeCloseVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeOpen', 1, "#{user_type} не видит кнопку открыть тему в чужой теме")
	assert_select('a#deleteTheme', 1, "#{user_type} не видит кнопку удаления чужой темы CloseVisible")
	assert_select('a#editTheme', 1, "#{user_type} не видит кнопку редактировать тему closeVisible")
	assert_select('a#newMsgBut', 0, "#{user_type} видит кнопку добавления сообщения в тему closeVisible")
	assert_select('form.message_form', 0, "#{user_type} видит форму добавления сообщения в тему closeVisible")
	assert_select('a#mergeTheme', 1, "#{user_type} не видит кнопку слияния тем в чужой теме closeVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
	theme = themes(:managerThemeOpenVisible) #своя открытая тема
	get :show, :id => theme
	assert_select('a#themeClose', 1, "#{user_type} не видит кнопку закрыть тему в чужой теме")
	assert_select('a#deleteTheme', 1, "#{user_type} не видит кнопку удалить тему в чужой теме OpenVisible")
	assert_select('a#editTheme', 1, "#{user_type} не видит кнопку редактировать тему в чужой теме OpenVisible")
	assert_select('a#newMsgBut', 1, "#{user_type} не видит кнопку добавления сообщения в чужую тему OpenVisible")
	assert_select('form.message_form', 1, "#{user_type} не видит форму добавления сообщения в тему OpenVisible")
	assert_select('a#mergeTheme', 1, "#{user_type} не видит кнопку слияния тем в чужой теме OpenVisible")
  assert_select('a#watchTheme', 1, "#{user_type} не видит кнопку 'Отслеживаться тему'")
  end
#destroy path end

test "theme_steps test for owner" do
  stepsCount = Step.count
  themeViewsCount = EntityView.count
  themeNotifications = ThemeNotification.count
  u = comeAsClubPilot
  draft = u.theme_draft(topics(:typicalTopic_3))
  assert !draft.nil?, "Не удалось получить черновик темы для раздела #{topics(:typicalTopic_3).name}"
  theme = {:name => "Theme_steps test", :content => defaultTextContent, :visibility_status_id => 1, :topic_id=> 1, :status_id => 1, :user_id => draft.user_id}
  put :update, :id => draft, :theme => theme
  assert_redirected_to theme_path(draft)
  assert ThemeNotification.count == themeNotifications + 1
  get :show, :id => draft
  assert EntityView.count == themeViewsCount + 1, "Не добавился счетчик просмотров после добавления темы"
  assert Step.count == stepsCount + 1, "Не добавился step после добавления темы"
end

test "clubFriend step test" do 
  u = comeAsClubFriend
  theme = themes(:themeForStepsTest)
  stepsCount = Step.count
  c = theme.views  
  get :show, :id => theme
  theme = Theme.find(theme.id)
  assert theme.views == c + 1, "Просмотр не засчитался"
  assert Step.count == stepsCount + 1, "Не добавился step после добавления темы"
  
  c = theme.views 
  step = Step.find_by(user_id: u.id, part_id: 9, page_id: 1, entity_id: theme.id)
  step.update_attribute(:visit_time, Time.now - 1.hour)
  stepsCount = Step.count
  get :show, :id => theme
  theme = Theme.find(theme.id)
  assert theme.views == c + 1, "Просмотр не засчитался"
  assert Step.count == stepsCount, "Step добавился вместо того чтобы обновиться"
end

  # test "should destroy theme" do
    # assert_difference('Theme.count', -1) do
      # delete :destroy, :id => @theme
    # end

    # assert_redirected_to themes_path
  # end
end
