require 'test_helper'

class VotesControllerTest < ActionController::TestCase
  setup do
    @completedNotPrivateVote = votes(:completedNotPrivateVote)
    @completedPrivateVote = votes(:completedPrivateVote)
    @notPrivateVote = votes(:notPrivateVote)
    @privateVote = votes(:privateVote)
    @clubFriendVote = votes(:clubFriendVote)
    @clubPilotVote = votes(:clubPilotVote)
    @managerVote = votes(:clubManagerVote)
    @clubAdminVote = votes(:clubAdminVote)
    @clubSuperAdminVote = votes(:clubSuperAdminVote)
    @voteForSuperAdminDestroy = votes(:voteForSuperAdminDestroy)
    @voteForAdminDestroy = votes(:voteForAdminDestroy)
  end
  
  test "Test user_group = guest for votes controller" do
    comeAsGuest
    type = 'Гостю'
    
    get :index
    assert_response :success, "#{type} не удалось посмотреть список опросов"
    assert_select('a#newVote', 0, "#{type} видно кнопку 'Добавить опрос'")
    
    get :show, id: @notPrivateVote
    assert_response :success, "#{type} не удалось посмотреть открытый опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать'")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос'")
    assert_select('div#voiceGivers', 0, "#{type} видно список проголосовавших в закрытом опросе")    
    
    get :show, id: @privateVote
    assert_response :success, "#{type} не удалось посмотреть закрытый опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать'")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос'")
    assert_select('div#voiceGivers', 0, "#{type} видно список проголосовавших в закрытом опросе")   
    
    get :show, id: @completedNotPrivateVote
    assert_response :success, "#{type} не удалось посмотреть открытый завершенный опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в открытом завершенном опросе")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос' в открытом завершенном опросе") 
    assert_select('div#voiceGivers', 1, "#{type} не видно список проголосовавших в открытом завершенном опросе")
    
    get :show, id: @completedPrivateVote
    assert_response :success, "#{type} не удалось посмотреть закрытый завершенный опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в закрытом завершенном опросе")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос' в зыкрытом завершенном опросе") 
    assert_select('div#voiceGivers', 0, "#{type} видно список проголосовавших в зыкрытом завершенном опросе")
    
    
    assert_no_difference('Vote.count', "#{type} удалось удалить опрос") do
      delete :destroy, :id => @privateVote
    end
    
  end

  test "Test user_group = new_user for votes controller" do
    comeAsNewUser
    type = 'Не авторизованному пользователю'
    
    get :index
    assert_response :success, "#{type} не удалось посмотреть список опросов"
    assert_select('a#newVote', 0, "#{type} видно кнопку 'Добавить опрос'")
    
    get :show, id: @notPrivateVote
    assert_response :success, "#{type} не удалось посмотреть открытый опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать'")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос'") 
    assert_select('div#voiceGivers', 0, "#{type} видно список проголосовавших в закрытом опросе")  
    
    get :show, id: @privateVote
    assert_response :success, "#{type} не удалось посмотреть закрытый опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать'")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос'") 
    assert_select('div#voiceGivers', 0, "#{type} видно список проголосовавших в закрытом опросе")
    
    get :show, id: @completedNotPrivateVote
    assert_response :success, "#{type} не удалось посмотреть открытый завершенный опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в открытом завершенном опросе")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос' в открытом завершенном опросе") 
    assert_select('div#voiceGivers', 1, "#{type} не видно список проголосовавших в открытом завершенном опросе")
    
    get :show, id: @completedPrivateVote
    assert_response :success, "#{type} не удалось посмотреть закрытый завершенный опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в закрытом завершенном опросе")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос' в зыкрытом завершенном опросе") 
    assert_select('div#voiceGivers', 0, "#{type} видно список проголосовавших в зыкрытом завершенном опросе")
    
    assert_no_difference('Vote.count', "#{type} удалось удалить опрос") do
      delete :destroy, :id => @privateVote
    end
    
  end
  
  test "Test user_group = club_friend for votes controller" do
    comeAsClubFriend
    type = 'Другу клуба'
    @myVote = @clubFriendVote
    get :index
    assert_response :success, "#{type} не удалось посмотреть список опросов"
    assert_select('a#newVote', 1, "#{type} не видно кнопку 'Добавить опрос'")
    
    get :show, id: @notPrivateVote
    assert_response :success, "#{type} не удалось посмотреть открытый опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в закрытом опросе в котором он уже принимал участие")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос' в чужом опросе") 
    assert_select('div#voiceGivers', @notPrivateVote.vote_values.size, "#{type} не видно список проголосовавших в открытом опросе") 
    
    get :show, id: @privateVote
    assert_response :success, "#{type} не удалось посмотреть закрытый опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в открытом опросе в котором он уже принимал участие")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос в чужом опросе'") 
    assert_select('div#voiceGivers', 0, "#{type} видно список проголосовавших в закрытом опросе") 
    
    get :show, id: @completedNotPrivateVote
    assert_response :success, "#{type} не удалось посмотреть открытый завершенный опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в открытом завершенном опросе")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос' в открытом завершенном опросе") 
    assert_select('div#voiceGivers', 1, "#{type} не видно список проголосовавших в открытом завершенном опросе")
    
    get :show, id: @completedPrivateVote
    assert_response :success, "#{type} не удалось посмотреть закрытый завершенный опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в закрытом завершенном опросе")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос' в зыкрытом завершенном опросе") 
    assert_select('div#voiceGivers', 0, "#{type} видно список проголосовавших в зыкрытом завершенном опросе")
    
    assert_no_difference('Vote.count', "#{type} удалось удалить чужой опрос") do
      delete :destroy, :id => @privateVote
    end
    
    assert_difference('Vote.count', -1, "#{type} не удалось удалить свой опрос") do
      delete :destroy, :id => @myVote
    end
    
  end
  
  test "Test user_group = club_pilot for votes controller" do
    comeAsClubPilot
    type = 'Клубному пилоту'
    @myVote = @clubPilotVote
    
    get :index
    assert_response :success, "#{type} не удалось посмотреть список опросов"
    assert_select('a#newVote', 1, "#{type} не видно кнопку 'Добавить опрос'")
    
    get :show, id: @notPrivateVote
    assert_response :success, "#{type} не удалось посмотреть открытый опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в закрытом опросе в котором он уже принимал участие")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос' в чужом опросе") 
    assert_select('div#voiceGivers', @notPrivateVote.vote_values.size, "#{type} не видно список проголосовавших в открытом опросе") 
    
    get :show, id: @privateVote
    assert_response :success, "#{type} не удалось посмотреть закрытый опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в открытом опросе в котором он уже принимал участие")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос в чужом опросе'") 
    assert_select('div#voiceGivers', 0, "#{type} видно список проголосовавших в закрытом опросе") 
    
    get :show, id: @completedNotPrivateVote
    assert_response :success, "#{type} не удалось посмотреть открытый завершенный опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в открытом завершенном опросе")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос' в открытом завершенном опросе") 
    assert_select('div#voiceGivers', 1, "#{type} не видно список проголосовавших в открытом завершенном опросе")
    
    get :show, id: @completedPrivateVote
    assert_response :success, "#{type} не удалось посмотреть закрытый завершенный опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в закрытом завершенном опросе")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос' в зыкрытом завершенном опросе") 
    assert_select('div#voiceGivers', 0, "#{type} видно список проголосовавших в зыкрытом завершенном опросе")
    
    
    
    assert_no_difference('Vote.count', "#{type} удалось удалить чужой опрос") do
      delete :destroy, :id => @privateVote
    end
    
    assert_difference('Vote.count', -1, "#{type} не удалось удалить свой опрос") do
      delete :destroy, :id => @myVote
    end
    
  end
  
  test "Test user_group = manager for votes controller" do
    comeAsManager
    type = 'Руководителю клуба'
    @myVote = @managerVote
    
    get :index
    assert_response :success, "#{type} не удалось посмотреть список опросов"
    assert_select('a#newVote', 1, "#{type} не видно кнопку 'Добавить опрос'")
    
    get :show, id: @notPrivateVote
    assert_response :success, "#{type} не удалось посмотреть открытый опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в закрытом опросе в котором он уже принимал участие")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос' в чужом опросе") 
    assert_select('div#voiceGivers', @notPrivateVote.vote_values.size, "#{type} не видно список проголосовавших в открытом опросе") 
    
    get :show, id: @privateVote
    assert_response :success, "#{type} не удалось посмотреть закрытый опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в открытом опросе в котором он уже принимал участие")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос в чужом опросе'") 
    assert_select('div#voiceGivers', 0, "#{type} видно список проголосовавших в закрытом опросе") 
    
    get :show, id: @completedNotPrivateVote
    assert_response :success, "#{type} не удалось посмотреть открытый завершенный опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в открытом завершенном опросе")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос' в открытом завершенном опросе") 
    assert_select('div#voiceGivers', 1, "#{type} не видно список проголосовавших в открытом завершенном опросе")
    
    get :show, id: @completedPrivateVote
    assert_response :success, "#{type} не удалось посмотреть закрытый завершенный опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в закрытом завершенном опросе")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос' в зыкрытом завершенном опросе") 
    assert_select('div#voiceGivers', 0, "#{type} видно список проголосовавших в зыкрытом завершенном опросе")
    
    assert_no_difference('Vote.count', "#{type} удалось удалить чужой опрос") do
      delete :destroy, :id => @privateVote
    end
    
    assert_difference('Vote.count', -1, "#{type} не удалось удалить свой опрос") do
      delete :destroy, :id => @myVote
    end
    
  end
  
  test "Test user_group = admin for votes controller" do
    comeAsAdmin
    type = 'Администратору'
    @myVote = @clubAdminVote
    
    get :index
    assert_response :success, "#{type} не удалось посмотреть список опросов"
    assert_select('a#newVote', 1, "#{type} не видно кнопку 'Добавить опрос'")
    
    get :show, id: @notPrivateVote
    assert_response :success, "#{type} не удалось посмотреть открытый опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в закрытом опросе в котором он уже принимал участие")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос' в чужом опросе") 
    assert_select('div#voiceGivers', @notPrivateVote.vote_values.size, "#{type} не видно список проголосовавших в открытом опросе") 
    
    get :show, id: @privateVote
    assert_response :success, "#{type} не удалось посмотреть закрытый опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в открытом опросе в котором он уже принимал участие")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос в чужом опросе'") 
    assert_select('div#voiceGivers', 0, "#{type} видно список проголосовавших в закрытом опросе") 
    
    get :show, id: @completedNotPrivateVote
    assert_response :success, "#{type} не удалось посмотреть открытый завершенный опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в открытом завершенном опросе")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос' в открытом завершенном опросе") 
    assert_select('div#voiceGivers', 1, "#{type} не видно список проголосовавших в открытом завершенном опросе")
    
    get :show, id: @completedPrivateVote
    assert_response :success, "#{type} не удалось посмотреть закрытый завершенный опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в закрытом завершенном опросе")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос' в зыкрытом завершенном опросе") 
    assert_select('div#voiceGivers', 0, "#{type} видно список проголосовавших в зыкрытом завершенном опросе")
    
    assert_difference('Vote.count', -1, "#{type} не удалось удалить чужой опрос") do
      delete :destroy, :id => @voteForAdminDestroy
    end
    
    assert_difference('Vote.count', -1, "#{type} не удалось удалить свой опрос") do
      delete :destroy, :id => @myVote
    end
    
  end
  
  test "Test user_group = super_admin for votes controller" do
    comeAsSuperAdmin
    type = 'Главному администратору'
    @myVote = @clubSuperAdminVote
    
    get :index
    assert_response :success, "#{type} не удалось посмотреть список опросов"
    assert_select('a#newVote', 1, "#{type} не видно кнопку 'Добавить опрос'")
    
    get :show, id: @notPrivateVote
    assert_response :success, "#{type} не удалось посмотреть открытый опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в закрытом опросе в котором он уже принимал участие")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос' в чужом опросе") 
    assert_select('div#voiceGivers', @notPrivateVote.vote_values.size, "#{type} не видно список проголосовавших в открытом опросе") 
    
    get :show, id: @privateVote
    assert_response :success, "#{type} не удалось посмотреть закрытый опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в открытом опросе в котором он уже принимал участие")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос в чужом опросе'") 
    assert_select('div#voiceGivers', 0, "#{type} видно список проголосовавших в закрытом опросе") 
    
    get :show, id: @completedNotPrivateVote
    assert_response :success, "#{type} не удалось посмотреть открытый завершенный опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в открытом завершенном опросе")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос' в открытом завершенном опросе") 
    assert_select('div#voiceGivers', 1, "#{type} не видно список проголосовавших в открытом завершенном опросе")
    
    get :show, id: @completedPrivateVote
    assert_response :success, "#{type} не удалось посмотреть закрытый завершенный опрос"
    assert_select('a#giveVoice', 0, "#{type} видно кнопку 'Голосовать' в закрытом завершенном опросе")
    assert_select('a#deleteVoice', 0, "#{type} видно кнопку 'Удалить опрос' в зыкрытом завершенном опросе") 
    assert_select('div#voiceGivers', 0, "#{type} видно список проголосовавших в зыкрытом завершенном опросе")
    
    assert_difference('Vote.count', -1, "#{type} не удалось удалить чужой опрос") do
      delete :destroy, :id => @voteForSuperAdminDestroy
    end
    
    assert_difference('Vote.count', -1, "#{type} не удалось удалить свой опрос") do
      delete :destroy, :id => @myVote
    end
    
  end

end
