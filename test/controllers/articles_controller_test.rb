require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  setup do
    @report = articles(:report)
    @review = articles(:review)
    @flight_accident = articles(:flight_accident)
    @club_article = articles(:club_article)
  end

  test "should redirected_to media from articles_path" do
    get 'index'
    assert_redirected_to "/media?t=reports", "Со страницы Articles переадресация прошла не туда"
  end
  
  test "article access for user_group = guest" do 
    u = comeAsGuest
    type = "Гостю"
    
    get :show, id: @report
    assert_response :success#, "#{type} не удалось посмотреть Отчет"
    
    get :show, id: @review
    assert_response :success, "#{type} не удалось посмотреть Обзор"
    
    get :show, id: @flight_accident.id
    assert_response :success, "#{type} не удалось посмотреть Отчет о ЛП"
    
    get :show, id: @club_article.id
    assert_response :success, "#{type} не удалось посмотреть Статью"
    
    get :new, c: 2
    assert_redirected_to '/404'
    
    assert_no_difference('Article.count', "#{type} удалось добавить материал") do
      post :create, :article => { :article_type_id => 3, :content => defaultTextContent, :name => "Default name", :user_id => nil, status_id: 1, visibility_status_id:1}
    end
    assert_redirected_to '/404'
    
    get :edit, :id => @report
    assert_redirected_to '/404', "#{type} удалось зайти на страницу изменения материала" 
    
    put :update, :id => @report, :article => { :article_type_id => @report.article_type_id, :content => @report.content, :name => @report.name, :user_id => @report.user_id }
    assert_redirected_to '/404', "#{type} удалось зайти на страницу измененить материал"

    assert_no_difference('Article.count', "#{type} удалось удалить материал") do
        delete :destroy, :id => @report
    end
  end
  
  test "article access for user_group = new_user" do 
    u = comeAsNewUser
    type = "Вновь прибывшему"
    
    get :show, id: @report
    assert_response :success#, "#{type} не удалось посмотреть Отчет"
    
    get :show, id: @review
    assert_response :success, "#{type} не удалось посмотреть Обзор"
    
    get :show, id: @flight_accident.id
    assert_response :success, "#{type} не удалось посмотреть Отчет о ЛП"
    
    get :show, id: @club_article.id
    assert_response :success, "#{type} не удалось посмотреть Статью"
    
    get :new, c: 2
    assert_redirected_to '/404'
    
    assert_no_difference('Article.count', "#{type} удалось добавить материал") do
      post :create, :article => { :article_type_id => 3, :content => defaultTextContent, :name => "Default name", :user_id => u.id, status_id: 1, visibility_status_id:1}
    end
    assert_redirected_to '/404'
    
    get :edit, :id => @report
    assert_redirected_to '/404', "#{type} удалось зайти на страницу изменения материала" 
    
    put :update, :id => @report, :article => { :article_type_id => @report.article_type_id, :content => @report.content, :name => @report.name, :user_id => @report.user_id }
    assert_redirected_to '/404', "#{type} удалось зайти на страницу измененить материал"

    assert_no_difference('Article.count', "#{type} удалось удалить материал") do
        delete :destroy, :id => @report
    end
  end
  
  test "article access for user_group = club_friend" do 
    u = comeAsClubFriend
    type = "Другу клуба"
    
    get :show, id: @report
    assert_response :success#, "#{type} не удалось посмотреть Отчет"
    
    get :show, id: @review
    assert_response :success, "#{type} не удалось посмотреть Обзор"
    
    get :show, id: @flight_accident.id
    assert_response :success, "#{type} не удалось посмотреть Отчет о ЛП"
    
    get :show, id: @club_article.id
    assert_response :success, "#{type} не удалось посмотреть Статью"
    
    get :new, c: 2
    assert_redirected_to '/404'
    
    assert_no_difference('Article.count', "#{type} удалось добавить материал") do
      post :create, :article => { :article_type_id => 3, :content => defaultTextContent, :name => "Default name", :user_id => u.id, status_id: 1, visibility_status_id:1}
    end
    assert_redirected_to '/404'
    
    get :edit, :id => @report
    assert_redirected_to '/404', "#{type} удалось зайти на страницу изменения материала" 
    
    put :update, :id => @report, :article => { :article_type_id => @report.article_type_id, :content => @report.content, :name => @report.name, :user_id => @report.user_id }
    assert_redirected_to '/404', "#{type} удалось зайти на страницу измененить материал"

    assert_no_difference('Article.count', "#{type} удалось удалить материал") do
        delete :destroy, :id => @report
    end
  end
  
  test "article access for user_group = club_pilot" do 
    u = comeAsClubPilot
    type = "Клубному пилоту"
    my_article = articles(:clubPilotArticle)
    get :show, id: @report
    assert_response :success#, "#{type} не удалось посмотреть Отчет"
    
    get :show, id: @review
    assert_response :success, "#{type} не удалось посмотреть Обзор"
    
    get :show, id: @flight_accident.id
    assert_response :success, "#{type} не удалось посмотреть Отчет о ЛП"
    
    get :show, id: @club_article.id
    assert_response :success, "#{type} не удалось посмотреть Статью"
    
    get :new, c: 1
    assert_response :success, "#{type} не удалось Посмотреть страницу добавления отчета по ЛП"
    
    get :new, c: 3
    assert_response :success, "#{type} не удалось Посмотреть страницу добавления Отчета"
    
    get :new, c: 4
    assert_response :success, "#{type} не удалось Посмотреть страницу добавления Статьи"
    
    get :new, c: 5
    assert_response :success, "#{type} не удалось Посмотреть страницу добавления Отзыва"
    
    assert_difference('Article.count',1, "#{type} не удалось добавить отчет по ЛП") do
      post :create, :article => { :article_type_id => 1, :content => defaultTextContent, :name => "Accident name", :user_id => u.id, status_id: 1, visibility_status_id:1, accident_date: Time.now}
    end
    assert_redirected_to article_path(assigns(:article))
        
    assert_difference('Article.count',1, "#{type} не удалось добавить отчет") do
      post :create, :article => { :article_type_id => 3, :content => defaultTextContent, :name => "Report name", :user_id => u.id, status_id: 1, visibility_status_id:1, accident_date: Time.now}
    end
    assert_redirected_to article_path(assigns(:article))
    
    assert_difference('Article.count',1, "#{type} не удалось добавить статью") do
      post :create, :article => { :article_type_id => 4, :content => defaultTextContent, :name => "Article name", :user_id => u.id, status_id: 1, visibility_status_id:1, accident_date: Time.now}
    end
    assert_redirected_to article_path(assigns(:article))
    
    assert_difference('Article.count',1, "#{type} не удалось добавить отзыв") do
      post :create, :article => { :article_type_id => 5, :content => defaultTextContent, :name => "Review name", :user_id => u.id, status_id: 1, visibility_status_id:1, accident_date: Time.now}
    end
    assert_redirected_to article_path(assigns(:article))
    
    get :edit, :id => my_article
    assert_response :success, "#{type} не удалось зайти на страницу своего материала"
    
    put :update, :id => my_article, :article => { :article_type_id => my_article.article_type_id, :content => my_article.content, :name => my_article.name, :user_id => my_article.user_id }
    assert_redirected_to article_path(my_article), "#{type} не удалось обновить свой материал"
     
    assert_difference('Article.count',-1, "#{type} удалось не удалить свой материал") do
        delete :destroy, :id => my_article
    end 
            
    get :edit, :id => @report
    assert_redirected_to '/404', "#{type} удалось зайти на страницу изменения чужого материала" 
    
    put :update, :id => @report, :article => { :article_type_id => @report.article_type_id, :content => @report.content, :name => @report.name, :user_id => @report.user_id }
    assert_redirected_to '/404', "#{type} удалось зайти на страницу измененить чужой материал"

    assert_no_difference('Article.count', "#{type} удалось удалить чужой материал") do
        delete :destroy, :id => @report
    end
  end
  
  test "article access for user_group = manager" do 
    u = comeAsManager
    type = "Руководителю клуба"
    my_article = articles(:managerArticle)
    get :show, id: @report
    assert_response :success#, "#{type} не удалось посмотреть Отчет"
    
    get :show, id: @review
    assert_response :success, "#{type} не удалось посмотреть Обзор"
    
    get :show, id: @flight_accident.id
    assert_response :success, "#{type} не удалось посмотреть Отчет о ЛП"
    
    get :show, id: @club_article.id
    assert_response :success, "#{type} не удалось посмотреть Статью"
    
    get :new, c: 1
    assert_response :success, "#{type} не удалось Посмотреть страницу добавления отчета по ЛП"
    
    get :new, c: 3
    assert_response :success, "#{type} не удалось Посмотреть страницу добавления Отчета"
    
    get :new, c: 4
    assert_response :success, "#{type} не удалось Посмотреть страницу добавления Статьи"
    
    get :new, c: 5
    assert_response :success, "#{type} не удалось Посмотреть страницу добавления Отзыва"
    
    assert_difference('Article.count',1, "#{type} не удалось добавить отчет по ЛП") do
      post :create, :article => { :article_type_id => 1, :content => defaultTextContent, :name => "Accident name", :user_id => u.id, status_id: 1, visibility_status_id:1, accident_date: Time.now}
    end
    assert_redirected_to article_path(assigns(:article))
        
    assert_difference('Article.count',1, "#{type} не удалось добавить отчет") do
      post :create, :article => { :article_type_id => 3, :content => defaultTextContent, :name => "Report name", :user_id => u.id, status_id: 1, visibility_status_id:1, accident_date: Time.now}
    end
    assert_redirected_to article_path(assigns(:article))
    
    assert_difference('Article.count',1, "#{type} не удалось добавить статью") do
      post :create, :article => { :article_type_id => 4, :content => defaultTextContent, :name => "Article name", :user_id => u.id, status_id: 1, visibility_status_id:1, accident_date: Time.now}
    end
    assert_redirected_to article_path(assigns(:article))
    
    assert_difference('Article.count',1, "#{type} не удалось добавить отзыв") do
      post :create, :article => { :article_type_id => 5, :content => defaultTextContent, :name => "Review name", :user_id => u.id, status_id: 1, visibility_status_id:1, accident_date: Time.now}
    end
    assert_redirected_to article_path(assigns(:article))
    
    get :edit, :id => my_article
    assert_response :success, "#{type} не удалось зайти на страницу своего материала"
    
    put :update, :id => my_article, :article => { :article_type_id => my_article.article_type_id, :content => my_article.content, :name => my_article.name, :user_id => my_article.user_id }
    assert_redirected_to article_path(my_article), "#{type} не удалось обновить свой материал"
     
    assert_difference('Article.count',-1, "#{type} удалось не удалить свой материал") do
        delete :destroy, :id => my_article
    end 
            
    get :edit, :id => @report
    assert_redirected_to '/404', "#{type} удалось зайти на страницу изменения чужого материала" 
    
    put :update, :id => @report, :article => { :article_type_id => @report.article_type_id, :content => @report.content, :name => @report.name, :user_id => @report.user_id }
    assert_redirected_to '/404', "#{type} удалось зайти на страницу измененить чужой материал"

    assert_no_difference('Article.count', "#{type} удалось удалить чужой материал") do
        delete :destroy, :id => @report
    end
  end
  
  
  test "article access for user_group = admin" do 
    u = comeAsAdmin
    type = "Администратору"
    my_article = articles(:adminArticle)
    get :show, id: @report
    assert_response :success#, "#{type} не удалось посмотреть Отчет"
    
    get :show, id: @review
    assert_response :success, "#{type} не удалось посмотреть Обзор"
    
    get :show, id: @flight_accident.id
    assert_response :success, "#{type} не удалось посмотреть Отчет о ЛП"
    
    get :show, id: @club_article.id
    assert_response :success, "#{type} не удалось посмотреть Статью"
    
    get :new, c: 1
    assert_response :success, "#{type} не удалось Посмотреть страницу добавления отчета по ЛП"
    
    get :new, c: 3
    assert_response :success, "#{type} не удалось Посмотреть страницу добавления Отчета"
    
    get :new, c: 4
    assert_response :success, "#{type} не удалось Посмотреть страницу добавления Статьи"
    
    get :new, c: 5
    assert_response :success, "#{type} не удалось Посмотреть страницу добавления Отзыва"
    
    assert_difference('Article.count',1, "#{type} не удалось добавить отчет по ЛП") do
      post :create, :article => { :article_type_id => 1, :content => defaultTextContent, :name => "Accident name", :user_id => u.id, status_id: 1, visibility_status_id:1, accident_date: Time.now}
    end
    assert_redirected_to article_path(assigns(:article))
        
    assert_difference('Article.count',1, "#{type} не удалось добавить отчет") do
      post :create, :article => { :article_type_id => 3, :content => defaultTextContent, :name => "Report name", :user_id => u.id, status_id: 1, visibility_status_id:1, accident_date: Time.now}
    end
    assert_redirected_to article_path(assigns(:article))
    
    assert_difference('Article.count',1, "#{type} не удалось добавить статью") do
      post :create, :article => { :article_type_id => 4, :content => defaultTextContent, :name => "Article name", :user_id => u.id, status_id: 1, visibility_status_id:1, accident_date: Time.now}
    end
    assert_redirected_to article_path(assigns(:article))
    
    assert_difference('Article.count',1, "#{type} не удалось добавить отзыв") do
      post :create, :article => { :article_type_id => 5, :content => defaultTextContent, :name => "Review name", :user_id => u.id, status_id: 1, visibility_status_id:1, accident_date: Time.now}
    end
    assert_redirected_to article_path(assigns(:article))
    
    get :edit, :id => my_article
    assert_response :success, "#{type} не удалось зайти на страницу своего материала"
    
    put :update, :id => my_article, :article => { :article_type_id => my_article.article_type_id, :content => my_article.content, :name => my_article.name, :user_id => my_article.user_id }
    assert_redirected_to article_path(my_article), "#{type} не удалось обновить свой материал"
     
    assert_difference('Article.count',-1, "#{type} удалось не удалить свой материал") do
        delete :destroy, :id => my_article
    end 
            
    get :edit, :id => @report
    assert_redirected_to '/404', "#{type} удалось зайти на страницу изменения чужого материала" 
    
    put :update, :id => @report, :article => { :article_type_id => @report.article_type_id, :content => @report.content, :name => @report.name, :user_id => @report.user_id }
    assert_redirected_to '/404', "#{type} удалось измененить чужой материал"

    assert_no_difference('Article.count', "#{type} удалось удалить чужой материал") do
        delete :destroy, :id => @report
    end
  end
  
  test "article access for user_group = super_admin" do 
    u = comeAsSuperAdmin
    type = "Главному администратору"
    my_article = articles(:superAdminArticle)
    get :show, id: @report
    assert_response :success#, "#{type} не удалось посмотреть Отчет"
    
    get :show, id: @review
    assert_response :success, "#{type} не удалось посмотреть Обзор"
    
    get :show, id: @flight_accident.id
    assert_response :success, "#{type} не удалось посмотреть Отчет о ЛП"
    
    get :show, id: @club_article.id
    assert_response :success, "#{type} не удалось посмотреть Статью"
    
    get :new, c: 1
    assert_response :success, "#{type} не удалось Посмотреть страницу добавления отчета по ЛП"
    
    get :new, c: 3
    assert_response :success, "#{type} не удалось Посмотреть страницу добавления Отчета"
    
    get :new, c: 4
    assert_response :success, "#{type} не удалось Посмотреть страницу добавления Статьи"
    
    get :new, c: 5
    assert_response :success, "#{type} не удалось Посмотреть страницу добавления Отзыва"
    
    assert_difference('Article.count',1, "#{type} не удалось добавить отчет по ЛП") do
      post :create, :article => { :article_type_id => 1, :content => defaultTextContent, :name => "Accident name", :user_id => u.id, status_id: 1, visibility_status_id:1, accident_date: Time.now}
    end
    assert_redirected_to article_path(assigns(:article))
        
    assert_difference('Article.count',1, "#{type} не удалось добавить отчет") do
      post :create, :article => { :article_type_id => 3, :content => defaultTextContent, :name => "Report name", :user_id => u.id, status_id: 1, visibility_status_id:1, accident_date: Time.now}
    end
    assert_redirected_to article_path(assigns(:article))
    
    assert_difference('Article.count',1, "#{type} не удалось добавить статью") do
      post :create, :article => { :article_type_id => 4, :content => defaultTextContent, :name => "Article name", :user_id => u.id, status_id: 1, visibility_status_id:1, accident_date: Time.now}
    end
    assert_redirected_to article_path(assigns(:article))
    
    assert_difference('Article.count',1, "#{type} не удалось добавить отзыв") do
      post :create, :article => { :article_type_id => 5, :content => defaultTextContent, :name => "Review name", :user_id => u.id, status_id: 1, visibility_status_id:1, accident_date: Time.now}
    end
    assert_redirected_to article_path(assigns(:article))
    
    get :edit, :id => my_article
    assert_response :success, "#{type} не удалось зайти на страницу своего материала"
    
    put :update, :id => my_article, :article => { :article_type_id => my_article.article_type_id, :content => my_article.content, :name => my_article.name, :user_id => my_article.user_id }
    assert_redirected_to article_path(my_article), "#{type} не удалось обновить свой материал"
     
    assert_difference('Article.count',-1, "#{type} удалось не удалить свой материал") do
        delete :destroy, :id => my_article
    end 
            
    get :edit, :id => @report
    assert_response :success, "#{type} не удалось зайти на страницу изменения чужого материала" 
    
    put :update, :id => @report, :article => { :article_type_id => @report.article_type_id, :content => @report.content, :name => @report.name, :user_id => @report.user_id }
    assert_redirected_to article_path(@report), "#{type} не удалось измененить чужой материал"

    assert_difference('Article.count', -1, "#{type} не удалось удалить чужой материал") do
        delete :destroy, :id => @report
    end
  end
  #test "should get index" do
  #  get :index
  #  assert_response :success
  #  assert_not_nil assigns(:articles)
  #end

  #test "should get new" do
  #  get :new
  #  assert_response :success
  #end

  #test "should create article" do
  #  assert_difference('Article.count') do
  #    post :create, :article => { :article_type_id => @article.article_type_id, :content => @article.content, :event_id => @article.event_id, :name => @article.name, :user_id => @article.user_id }
  #  end

  #  assert_redirected_to article_path(assigns(:article))
  #end

  #test "should show article" do
  #  get :show, :id => @article
  #  assert_response :success
  #end

  #test "should get edit" do
  #  get :edit, :id => @article
  #  assert_response :success
  #end

  #test "should update article" do
  #  put :update, :id => @article, :article => { :article_type_id => @article.article_type_id, :content => @article.content, :event_id => @article.event_id, :name => @article.name, :user_id => @article.user_id }
  #  assert_redirected_to article_path(assigns(:article))
  #end

  #test "should destroy article" do
  #  assert_difference('Article.count', -1) do
  #    delete :destroy, :id => @article
  #  end
  #
  #  assert_redirected_to articles_path
  #end
end
