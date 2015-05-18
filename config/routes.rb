Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
resources :voices, :only => [:create, :destroy]	
  resources :votes
  resources :events

  #events 
  post "events/upload_photos"
  get '/events/:id/upload_photos', :to => 'events#upload_photos' #загрузка с помощью dropzone.js и собственную функцию
  #events end
  #admin_tools
	get "admin_tools/deleted_albums"   #удалённые альбомы
	get "admin_tools/deleted_themes"   #удалённые темы
	get "admin_tools/deleted_messages" #удалённые сообщения или комментарии
	get "admin_tools/deleted_articles" #удалённые статьи
	get "admin_tools/deleted_photos"   #удалённые статьи
	get "admin_tools/hidden_albums"    #скрытые альбомы
	get "admin_tools/hidden_themes"	   #скрытые альбомы
	get "admin_tools/hidden_messages"  #скрытые сообщения
	get "admin_tools/hidden_articles"  #скрытые статьи
	get "admin_tools/hidden_photos"    #скрытые фотографии
	get "admin_tools/deleted_entities" #удалённые объекты
  get "admin_tools/hidden_entities"  #скрытые объекты	
	get "admin_tools/site_images" #изображения для сайта	
	get "admin_tools/entities_recovery"	#Восстановление удалённых объектов
	get "admin_tools/disabled_events" #Скрытые новости
	get "admin_tools/adaptation_to_new"     #Создать темы
  #admin_tools_end
  
  #articles
  resources :articles
  get "articles/bind_videos_and_albums"
  post "articles/upload_photos"
  get '/articles/:id/upload_photos', :to => 'articles#upload_photos'
  get '/articles/:id/bind_videos_and_albums', :to => 'articles#bind_videos_and_albums'
  #articles_end

  #old_messages_controller
  resources :old_messages, :only => [:index, :edit, :update, :destroy]
  get "old_messages/get_old_messages"
  get "old_messages/old_msg_users"
  get "old_messages/assign_users_to_old_msgs"
  post "old_messages/assign_users_to_old_msgs"
  #old_messages_controller end
  
  #messages_controller
  resources :messages
  get "messages/replace_message"
  get "messages/do_replace_message"
  get '/messages/:id/replace_message', :to => 'messages#replace_message'

  get '/messages/:id/upload_photos', :to => 'messages#upload_photos'

  post '/messages/:id/upload_photos', :to => 'messages#upload_photos' #загрузка с помощью dropzone.js и собственную функцию photosUploader() в application.js
  get '/do_replace_message', :to => 'messages#do_replace_message'
  #messages_controller end
  
  #themes_controller  
  resources :themes
  get "themes/merge_themes"
  get "themes/get_themes_list"
  post "themes/do_merge_themes"
  post "themes/theme_switcher"
  post "themes/add_photos"
  post "themes/add_files"
  get '/themes/:id/theme_switcher', :to => 'themes#theme_switcher'
  get '/get_themes_list', :to => 'themes#get_themes_list'
  get '/themes/:id/merge_themes', :to => 'themes#merge_themes'
  get '/themes/:id/new_message', :to => 'themes#new_message' #Новое сообщение в теме
  get '/themes/:id/add_photos', :to => 'themes#add_photos' #Загрузка фото
  get '/themes/:id/add_files', :to => 'themes#add_files' #Загрузка файлов
  get '/do_merge_themes', :to => 'themes#do_merge_themes'
  post '/themes/:id/upload_photos', :to => 'themes#upload_photos' #загрузка с помощью dropzone.js и собственную функцию photosUploader() в application.js
  #themes_controller end

  #topics controller
  resources :topics
  get '/visota_life', :to => 'topics#index'
  get '/gost.htm', :to => 'topics#index'
  #topics controller end

  #videos_controller
  resources :videos
  get "videos/new_comment"
  get '/videos/:id/new_comment', :to => 'videos#new_comment'
  #videos_controller end

  #photos_controller
  resources :photos
  get "photos/recovery"
  post "photos/update_photos"
  get '/photos/:id/recovery', :to => 'photos#recovery' #восстановление
  get '/edit_photos', :to => 'photos#edit_photos'

  post '/edit_photos', :to => 'photos#edit_photos'
  post '/update_photos', :to => 'photos#update_photos'
  #photos_controller end

  #photo_albums_controller
  resources :photo_albums
  get "photo_albums/unbinded_to_article_albums"
  get "photo_albums/get_albums_list"
  get '/get_albums_list', :to => 'photo_albums#get_albums_list'
  get '/unbinded_to_article_albums', :to => 'photo_albums#unbinded_to_article_albums'#Ссылка на вывод списка альбомов не прикрепленных к статье...
  post '/photo_albums/:id/upload_photos', :to => 'photo_albums#upload_photos' #загрузка с помощью dropzone.js и собственную функцию photosUploader() в application.js
  #photo_albums_controller end


  resources :steps
  
  #users_controller
  resources :users
  get "users/password_mail_sent"
  get "users/make_mail"
  get "users/remember_password"
  get "users/mail_switcher"
  get "users/thanks"
  put "users/update_mailer"
  get "users/user_check"
  get "users/mail_test"
  get "users/check_email_and_name"
  get "users/videos"
  get "users/photo_albums"
  get "users/articles"
  get "users/steps"
  get '/password_mail_sent', :to => 'users#password_mail_sent'
  get '/make_mail', :to => 'users#make_mail'
  get '/remember_password', :to => 'users#remember_password'
  get '/thanks', :to => 'users#thanks'
  get '/mail_switcher', :to => 'users#mail_switcher'
  get '/user_check', :to => 'users#user_check'
  get "/pilots", :to => 'users#index'
  get "/welcome", :to => 'users#welcome'
  get "/update_mailer", :to => 'users#update_mailer'
  get "/check_email_and_name", :to => 'users#check_email_and_name' #проверка имени и почтового адреса на занятость.
  get "/users/:id/videos", :to => "users#videos"
  get "/users/:id/steps", :to => "users#steps"
  get '/users/:id/photo_albums', :to => 'users#photo_albums'
  get '/users/:id/articles', :to => 'users#articles'
  #users_controller
  
  #sessions_controller
  resources :sessions, :only => [:new, :create, :destroy]
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  get '/create_session',  :to => 'sessions#create'
  get '/signup',  :to => 'users#new'
  get '/signin',  :to => 'sessions#new'
  get '/signout', :to => 'sessions#destroy'
  #sessions_controller end
  
  #pages_controller
  get "pages/index"
  get "pages/school"
  get "pages/contacts"
  get "pages/about_us"
  get "pages/feed"
  get "pages/search"
  get '/index', :to => 'pages#index'
  get '/school', :to => 'pages#school'
  get '/about_us', :to => 'pages#about_us'
  get '/contacts', :to => 'pages#contacts'
  get '/styles', :to => 'pages#styles'
  get '/feed', :to => 'pages#feed'
  get '/search', :to => 'pages#search'
  #pages_controller end
  # You can have the root of your site routed with "root"
  root 'pages#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
