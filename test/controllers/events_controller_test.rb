require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    @event = events(:notDraft)
    @event_2 = events(:notDraft2)
    @event_3 = events(:notDraft3)
    @event_4 = events(:notDraft4)
    @eventDraft = events(:draft)
  end

  test "check user_type = guest access for events paths" do
    comeAsGuest
    type = "Гостю"
    
    get :index
    assert_response :success, "#{type} не удалось посмотреть список новостей"
    assert_select('a#newEvent', 0, "#{type} видно кнопку 'Добавить новость'")
    assert_not_nil assigns(:events), "#{type} не увидел новостей"
    
    get :new
    assert_redirected_to '/404', "#{type} удалось пройти на страницу добавления новости"
    
    get :show, id: @eventDraft
    assert_redirected_to '/404', "#{type} удалось посмотреть черновик"
    
    get :show, id: @event
    assert_response :success, "#{type} не удалось посмотреть новость"
    
    get :edit, id: @event
    assert_redirected_to '/404', "#{type} удалось пройти на страницу изменения новости"
    
    assert_no_difference('Event.count', "#{type} удалось добавить новость") do
      post :create, :event => { :article_id => @event.article_id, :content => @event.content, :display_area_id => @event.display_area_id, :photo_album_id => @event.photo_album_id, :post_date => @event.post_date, :short_content => @event.short_content, :status_id => @event.status_id, :title => @event.title, :video_id => @event.video_id }
    end
    
    put :update, :id => @event, :event => { :article_id => @event.article_id, :content => @event.content, :display_area_id => @event.display_area_id, :photo_album_id => @event.photo_album_id, :post_date => @event.post_date, :short_content => @event.short_content, :status_id => @event.status_id, :title => @event.title, :video_id => @event.video_id }
    assert_redirected_to '/404', "#{type} удалось обновить новость"
    
    assert_no_difference('Event.count', "#{type} удалось удалить новость") do
      delete :destroy, :id => @event
    end
       
  end
  
  test "check user_type = new_user access for events paths" do
    comeAsNewUser
    type = "Неавторизованному пользователю"
    
    get :index
    assert_response :success, "#{type} не удалось посмотреть список новостей"
    assert_select('a#newEvent', 0, "#{type} видно кнопку 'Добавить новость'")
    assert_not_nil assigns(:events), "#{type} не увидел новостей"
    
    get :show, id: @eventDraft
    assert_redirected_to '/404', "#{type} удалось посмотреть черновик"
    
    get :show, id: @event
    assert_response :success, "#{type} не удалось посмотреть новость"
    
    get :new
    assert_redirected_to '/404', "#{type} удалось пройти на страницу добавления новости"
    
    get :edit, id: @event
    assert_redirected_to '/404', "#{type} удалось пройти на страницу изменения новости"
    
    assert_no_difference('Event.count', "#{type} удалось добавить новость") do
      post :create, :event => { :article_id => @event.article_id, :content => @event.content, :display_area_id => @event.display_area_id, :photo_album_id => @event.photo_album_id, :post_date => @event.post_date, :short_content => @event.short_content, :status_id => @event.status_id, :title => @event.title, :video_id => @event.video_id }
    end
    
    put :update, :id => @event, :event => { :article_id => @event.article_id, :content => @event.content, :display_area_id => @event.display_area_id, :photo_album_id => @event.photo_album_id, :post_date => @event.post_date, :short_content => @event.short_content, :status_id => @event.status_id, :title => @event.title, :video_id => @event.video_id }
    assert_redirected_to '/404', "#{type} удалось обновить новость"
    
    assert_no_difference('Event.count', "#{type} удалось удалить новость") do
      delete :destroy, :id => @event
    end
       
  end
  test "check user_type = bunned access for events paths" do
    comeAsNewUser
    type = "Заблокированному пользователю"
    
    get :index
    assert_response :success, "#{type} не удалось посмотреть список новостей"
    assert_select('a#newEvent', 0, "#{type} видно кнопку 'Добавить новость'")
    assert_not_nil assigns(:events), "#{type} не увидел новостей"
    
    get :show, id: @eventDraft
    assert_redirected_to '/404', "#{type} удалось посмотреть черновик"
    
    get :show, id: @event
    assert_response :success, "#{type} не удалось посмотреть новость"
    
    get :new
    assert_redirected_to '/404', '#{type} удалось пройти на страницу добавления новости'
    
    get :edit, id: @event
    assert_redirected_to '/404', '#{type} удалось пройти на страницу изменения новости'
    
    assert_no_difference('Event.count', "#{type} удалось добавить новость") do
      post :create, :event => { :article_id => @event.article_id, :content => @event.content, :display_area_id => @event.display_area_id, :photo_album_id => @event.photo_album_id, :post_date => @event.post_date, :short_content => @event.short_content, :status_id => @event.status_id, :title => @event.title, :video_id => @event.video_id }
    end
    
    put :update, :id => @event, :event => { :article_id => @event.article_id, :content => @event.content, :display_area_id => @event.display_area_id, :photo_album_id => @event.photo_album_id, :post_date => @event.post_date, :short_content => @event.short_content, :status_id => @event.status_id, :title => @event.title, :video_id => @event.video_id }
    assert_redirected_to '/404', "#{type} удалось обновить новость"
    
    assert_no_difference('Event.count', "#{type} удалось удалить новость") do
      delete :destroy, :id => @event
    end
       
  end
  
  test "check user_type = club_friend access for events paths" do
    comeAsClubFriend
    type = "Другу клуба"
    
    get :index
    assert_response :success, "#{type} не удалось посмотреть список новостей"
    assert_select('a#newEvent', 0, "#{type} видно кнопку 'Добавить новость'")
    assert_not_nil assigns(:events), "#{type} не увидел новостей"
    
    get :show, id: @eventDraft
    assert_redirected_to '/404', "#{type} удалось посмотреть черновик"
    
    get :show, id: @event
    assert_response :success, "#{type} не удалось посмотреть новость"
    
    get :new
    assert_redirected_to '/404', '#{type} удалось пройти на страницу добавления новости'
    
    get :edit, id: @event
    assert_redirected_to '/404', '#{type} удалось пройти на страницу изменения новости'
    
    assert_no_difference('Event.count', "#{type} удалось добавить новость") do
      post :create, :event => { :article_id => @event.article_id, :content => @event.content, :display_area_id => @event.display_area_id, :photo_album_id => @event.photo_album_id, :post_date => @event.post_date, :short_content => @event.short_content, :status_id => @event.status_id, :title => @event.title, :video_id => @event.video_id }
    end
    
    put :update, :id => @event, :event => { :article_id => @event.article_id, :content => @event.content, :display_area_id => @event.display_area_id, :photo_album_id => @event.photo_album_id, :post_date => @event.post_date, :short_content => @event.short_content, :status_id => @event.status_id, :title => @event.title, :video_id => @event.video_id }
    assert_redirected_to '/404', "#{type} удалось обновить новость"
    
    assert_no_difference('Event.count', "#{type} удалось удалить новость") do
      delete :destroy, :id => @event
    end
       
  end
  
  test "check user_type = club_pilot access for events paths" do
    comeAsClubPilot
    type = "Клубному пилоту"
    
    get :index
    assert_response :success, "#{type} не удалось посмотреть список новостей"
    assert_select('a#newEvent', 0, "#{type} видно кнопку 'Добавить новость'")
    assert_not_nil assigns(:events), "#{type} не увидел новостей"
    
    get :show, id: @eventDraft
    assert_redirected_to '/404', "#{type} удалось посмотреть черновик"
    
    get :show, id: @event
    assert_response :success, "#{type} не удалось посмотреть новость"
    
    get :new
    assert_redirected_to '/404', '#{type} удалось пройти на страницу добавления новости'
    
    get :edit, id: @event
    assert_redirected_to '/404', '#{type} удалось пройти на страницу изменения новости'
    
    assert_no_difference('Event.count', "#{type} удалось добавить новость") do
      post :create, :event => { :article_id => @event.article_id, :content => @event.content, :display_area_id => @event.display_area_id, :photo_album_id => @event.photo_album_id, :post_date => @event.post_date, :short_content => @event.short_content, :status_id => @event.status_id, :title => @event.title, :video_id => @event.video_id }
    end
    
    put :update, :id => @event, :event => { :article_id => @event.article_id, :content => @event.content, :display_area_id => @event.display_area_id, :photo_album_id => @event.photo_album_id, :post_date => @event.post_date, :short_content => @event.short_content, :status_id => @event.status_id, :title => @event.title, :video_id => @event.video_id }
    assert_redirected_to '/404', "#{type} удалось обновить новость"
    
    assert_no_difference('Event.count', "#{type} удалось удалить новость") do
      delete :destroy, :id => @event
    end
       
  end
  
  test "check user_type = manager access for events paths" do
    comeAsManager
    type = "Руководителю клуба"
    
    get :index
    assert_response :success, "#{type} не удалось посмотреть список новостей"
    assert_select('a#newEvent', 1, "#{type} не видно кнопку 'Добавить новость'")
    assert_not_nil assigns(:events), "#{type} не увидел новостей"
    
    get :show, id: @eventDraft
    assert_response :success, "#{type} не удалось посмотреть черновик"
    
    get :show, id: @event
    assert_response :success, "#{type} не удалось посмотреть новость"
    
    get :new
    assert_response :success, "#{type} не удалось пройти на страницу добавления новости"
    
    get :edit, id: @event
    assert_response :success, "#{type} не удалось пройти на страницу изменения новости"
    
    assert_difference('Event.count', 1,"#{type} не удалось добавить новость") do
      post :create, :event => { :article_id => @event.article_id, :content => @event.content, :display_area_id => @event.display_area_id, :photo_album_id => @event.photo_album_id, :post_date => @event.post_date, :short_content => @event.short_content, :status_id => @event.status_id, :title => @event.title, :video_id => @event.video_id }
    end
    
    put :update, :id => @event, :event => { :article_id => @event.article_id, :content => @event.content, :display_area_id => @event.display_area_id, :photo_album_id => @event.photo_album_id, :post_date => @event.post_date, :short_content => @event.short_content, :status_id => @event.status_id, :title => @event.title, :video_id => @event.video_id }
    assert_redirected_to event_path(@event), "#{type} удалось обновить новость"
    
    assert_difference('Event.count',-1, "#{type} не удалось удалить новость") do
      delete :destroy, :id => @event_2
    end
       
  end
  
  test "check user_type = admin access for events paths" do
    comeAsAdmin
    type = "Администратору"
    
    get :index
    assert_response :success, "#{type} не удалось посмотреть список новостей"
    assert_select('a#newEvent', 1, "#{type} не видно кнопку 'Добавить новость'")
    assert_not_nil assigns(:events), "#{type} не увидел новостей"
    
    get :show, id: @eventDraft
    assert_response :success, "#{type} не удалось посмотреть черновик"
    
    get :show, id: @event
    assert_response :success, "#{type} не удалось посмотреть новость"
    
    get :new
    assert_response :success, "#{type} не удалось пройти на страницу добавления новости"
    
    get :edit, id: @event
    assert_response :success, "#{type} не удалось пройти на страницу изменения новости"
    
    assert_difference('Event.count', 1,"#{type} не удалось добавить новость") do
      post :create, :event => { :article_id => @event.article_id, :content => @event.content, :display_area_id => @event.display_area_id, :photo_album_id => @event.photo_album_id, :post_date => @event.post_date, :short_content => @event.short_content, :status_id => @event.status_id, :title => @event.title, :video_id => @event.video_id }
    end
    
    put :update, :id => @event, :event => { :article_id => @event.article_id, :content => @event.content, :display_area_id => @event.display_area_id, :photo_album_id => @event.photo_album_id, :post_date => @event.post_date, :short_content => @event.short_content, :status_id => @event.status_id, :title => @event.title, :video_id => @event.video_id }
    assert_redirected_to event_path(@event), "#{type} удалось обновить новость"
    
    assert_difference('Event.count',-1, "#{type} не удалось удалить новость") do
      delete :destroy, :id => @event_3
    end
       
  end
  
  test "check user_type = super_admin access for events paths" do
    comeAsSuperAdmin
    type = "Главному администратору"
    
    get :index
    assert_response :success, "#{type} не удалось посмотреть список новостей"
    assert_select('a#newEvent', 1, "#{type} не видно кнопку 'Добавить новость'")
    assert_not_nil assigns(:events), "#{type} не увидел новостей"
    
    
    
    get :show, id: @eventDraft
    assert_response :success, "#{type} не удалось посмотреть черновик"
    
    get :show, id: @event
    assert_response :success, "#{type} не удалось посмотреть новость"
    
    get :new
    assert_response :success, "#{type} не удалось пройти на страницу добавления новости"
    
    get :edit, id: @event
    assert_response :success, "#{type} не удалось пройти на страницу изменения новости"
    
    assert_difference('Event.count', 1,"#{type} не удалось добавить новость") do
      post :create, :event => { :article_id => @event.article_id, :content => @event.content, :display_area_id => @event.display_area_id, :photo_album_id => @event.photo_album_id, :post_date => @event.post_date, :short_content => @event.short_content, :status_id => @event.status_id, :title => @event.title, :video_id => @event.video_id }
    end
    
    put :update, :id => @event, :event => { :article_id => @event.article_id, :content => @event.content, :display_area_id => @event.display_area_id, :photo_album_id => @event.photo_album_id, :post_date => @event.post_date, :short_content => @event.short_content, :status_id => @event.status_id, :title => @event.title, :video_id => @event.video_id }
    assert_redirected_to event_path(@event), "#{type} удалось обновить новость"
    
    assert_difference('Event.count',-1, "#{type} не удалось удалить новость") do
      delete :destroy, :id => @event_3
    end
       
  end
  

end
