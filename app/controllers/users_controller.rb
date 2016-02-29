class UsersController < ApplicationController
include UsersHelper
  # GET /users
  # GET /users.json
  def index
	category = params[:g]
  per_page = 25
	if category == 'club_friends'
		@title = 'Друзья клуба'
		@active_button = 1 
		@users = User.paginate(:page => params[:page], :per_page => per_page).where(user_group_id: 3)
	elsif category == 'just_came'
		@title = 'Вновь прибывшие'
		@active_button = 2
		@users = User.paginate(:page => params[:page], :per_page => per_page).where(user_group_id: 5)
	elsif category == 'bun_list' and is_admin?
		@title = 'Бан лист'
		@active_button = 3 
		@users = User.paginate(:page => params[:page], :per_page => per_page).where(user_group_id: 4)
	else 
		@title = 'Клубные пилоты'
		@active_button = 0
		@users = User.paginate(:page => params[:page], :per_page => per_page).where(user_group_id: [1, 2, 6]).order('user_group_id DESC').order('order_number ASC')
	end
  @header = @title
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end
  def videos
	@user = User.find_by_id(params[:id])
	if @user != nil
		@per_page = 18
		case params[:c]
		when 'paragliding'
			@videos = @user.videos.paginate(:page => params[:page], :per_page => @per_page).where(category_id: 5).order('created_at DESC')
			@category_name = 'Свободные полёты'
		when 'power_paragliding'
			@videos = @user.videos.paginate(:page => params[:page], :per_page => @per_page).where(category_id: 4).order('created_at DESC')
			@category_name = 'Моторные полёты'
		when 'kiting'
			@videos = @user.videos.paginate(:page => params[:page], :per_page => @per_page).where(category_id: 2).order('created_at DESC')
			@category_name = 'Кайтинг'		
		when 'club_events'
			@videos = @user.videos.paginate(:page => params[:page], :per_page => @per_page).where(category_id: 3).order('created_at DESC')
			@category_name = 'Клубные мероприятия'
		when 'another'
			@videos = @user.videos.paginate(:page => params[:page], :per_page => @per_page).where(category_id: 1).order('created_at DESC')
			@category_name = 'Разное'
		else
			@videos = @user.videos.paginate(:page => params[:page], :per_page => @per_page).all.order('created_at DESC')
			@category_name = 'Все видео'
		end
		@title = "Видео пользователя #{@user.name}" if @user != current_user
    @title = "Мои видео" if @user == current_user
    @header = "#{@title}: #{@category_name}"
		@path_array = [
						{:name => 'Видео', :link => videos_path},
						{:name => "Видео пользователя #{@user.name}"}
					  ]
		respond_to do |format|
			format.html { render 'videos/index' }
			format.json { render :json => @videos }
		end
	else
		redirect_to '/404'
	end
  end
  def photo_albums
	@user = User.find_by_id(params[:id])
	if @user != nil
		@title = @header = "Фотоальбомы пользователя #{@user.name}" if @user != current_user
    @title = @header = "Мои фотоальбомы" if @user == current_user
		@per_page = 18
		case params[:c]
		when 'paragliding'
			@albums = @user.photo_albums.paginate(:page => params[:page], :per_page => @per_page).where(category_id: 5, status_id: 1).order('created_at DESC')
			@category_name = 'Свободные полёты'
		when 'power_paragliding'
			@albums = @user.photo_albums.paginate(:page => params[:page], :per_page => @per_pag).where(category_id: 4, status_id: 1).order('created_at DESC')
			@category_name = 'Моторные полёты'
		when 'kiting'
			@albums = @user.photo_albums.paginate(:page => params[:page], :per_page => @per_page).where(category_id: 2, status_id: 1).order('created_at DESC')
			@category_name = 'Кайтинг'		
		when 'club_events'
			@albums = @user.photo_albums.paginate(:page => params[:page], :per_page => @per_page).where(category_id: 3, status_id: 1).order('created_at DESC')
			@category_name = 'Клубные мероприятия'
			
		when 'another'
			@albums = @user.photo_albums.paginate(:page => params[:page], :per_page => @per_page).where(category_id: 1, status_id: 1).order('created_at DESC')
			@category_name = 'Разное'
		else
			@albums = @user.photo_albums.paginate(:page => params[:page], :per_page => @per_page).where(status_id: 1).order('created_at DESC')
			@category_name = 'Все альбомы'
		end
		respond_to do |format|
		  format.html {render 'photo_albums/index'}# index.html.erb
		  format.json { render :json => @photo_albums }
		end
	else
		redirect_to '/404'
	end
  end
  def articles
      @user = User.find_by_id(params[:id])
    	if @user != nil
    		@title = @header = "Материалы пользователя #{@user.name}"
      	article = Article.new
      	@curArtCat = article.types.first
      	article.types.each do |t|
      		if params[:c] == t[:link]
      			@curArtCat = t
      			break
      		end
      	end  
      	@title = @curArtCat[:multiple_name]
        vStatus = (is_not_authorized?)? [1]:[1,2]
      	@articles = Article.where(article_type_id: @curArtCat[:value], status_id: 1, visibility_status_id: vStatus, user_id: @user.id).order('created_at DESC')
      	  respond_to do |format|
            format.html {render 'articles/index'}# index.html.erb
            format.json { render :json => @articles }
          end
      else
    		redirect_to '/404'
    	end
  end
  
  def themes
    @user = User.find_by(id: params[:id])
    if @user != nil
      @title = @header = "Все темы пользователя #{@user.name}" if @user != current_user
      @title = @header = "Мои темы" if @user == current_user
      @visibility_ids = 1 if is_not_authorized? and @user != current_user
      @visibility_ids = [1,2] if !is_not_authorized? or @user == current_user
      @topics = Topic.all.order('name ASC')
    else
      redirect_to '/404'
    end
  end
  
  # GET /users/1
  # GET /users/1.json
  def show 
    @user = User.find_by(id: params[:id])
  	if @user != nil
  		#@alter_logo = @user.photo if @user.photo?
  		@title = "#{@user.name}"
      @albums = @user.photo_albums.where(status_id: 1).order("created_at DESC").limit(4)
  		respond_to do |format|
  		  format.html # show.html.erb
  		  format.json { render :json => @user }
  		end
  	else
  		redirect_to '/404'
  	end
  end

  # GET /users/new
  # GET /users/new.json
  def new
  	if user_type == 'guest'
  		@user = User.new
  		@action_type = 'new'
  		@title = @header = "Регистрация на сайте"
  		respond_to do |format|
  		  format.html # new.html.erb
  		  format.json { render :json => @user }
  		end
  	else
  		redirect_to user_path(current_user)
  	end
  end

  # GET /users/1/edit
  def edit
    @user = User.find_by(id: params[:id])
	if userCanEditUserCard?(@user)
		if @user.mailer == nil and params[:tab] == 'notification_upd'
			#send mail_check if @user.make_mailer
		end
		@action_type = 'edit'
	else
		redirect_to '/404'
	end
  end

  # POST /users
  # POST /users.json
  def create
    if user_type == 'guest'
			params[:user][:user_group_id] = 5
			params[:user][:email_status] = 'Проверка'
			@user = User.new(params[:user])
			@add_functions = "userFieldsChecking();"
			if @user.image_valid?(params[:abi][:value], params[:abi][:name])
				respond_to do |format|
				  if @user.save
					UserMailer.user_check(@user).deliver_now
					user = User.authenticate(params[:user][:name],
											params[:user][:password])
					sign_in user
					format.html { redirect_to @user, :notice => "<b>Приветствуем в нашей крылатой компании!!!</b><br /><br /> На электронный адрес <b>#{@user.email}</b> было отправлено сообщение с ссылкой на подтверждение Вашей учётной записи. <br />
			Подтвердив свою учётную запись, Вы сможете делиться своими фотографиями и видеозаписями." }
					format.json { render :json => @user, :status => :created, :location => @user }
				  else
					format.html { render :action => "new" }
					format.json { render :json => @user.errors, :status => :unprocessable_entity }
				  end
				end
		else
			respond_to do |format|
				format.html {redirect_to :back, :alert => 'Неправильно введён текст изображения', @user => params[:user]}
			end
		end
	else
		redirect_to "/404"
	end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
	if userCanEditUserCard?(@user)
		if params[:tab] == 'email_upd'
      params[:user][:email_status] = 'Проверка' if @user.email != params[:user][:email]
    end
		respond_to do |format|
		  if @user.update_attributes(params[:user])
    		my_notice = 'Профиль успешно обновлён'
    		case params[:tab]
    		when 'email_upd' 
    			my_notice = 'E-mail адрес обновлён. На новый адрес отправлено проверочное сообщение.' if sendCheckUserData(@user)
    		when 'password_upd'
    			my_notice = 'Пароль успешно обновлён.'
    		end
			format.html { redirect_to @user, :notice => my_notice }
			format.json { head :no_content }
		  else
			format.html { render :action => 'edit' }
			format.json { render :json => @user.errors, :status => :unprocessable_entity }
		  end
		end
	else
		redirect_to '/404'
	end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find_by(id: params[:id])
  	if is_super_admin?
  		@user.destroy
  		respond_to do |format|
  		  format.html { redirect_to users_url }
  		  format.json { head :no_content }
  		end
  	else
  		redirect_to '/404'
  	end
  end
  
  def welcome
	  @title = @header = 'Приветствуем в нашей крылатой компании!!!'
	  @photo_albums
	  @videos
	  @articles
	  redirect_to root_path if user_type != 'new_user'
  end
  def authorization
	  @title = @header = 'Инструкция по авторизации'
	  redirect_to root_path if user_type != 'new_user'
  end
  def thanks
	  @title = 'Аккаунт успешно активирован!!!'
  end
  
  def update_mailer
	if user_type != 'guest'
		@mailer = Mailer.find_by(user_id: params[:id])
		if @mailer != nil and (@mailer.user == current_user or user_type == 'super_admin')
			respond_to do |format|
			  if @mailer.update_attributes(params[:mailer])
				format.html { redirect_to edit_user_path(:id => @mailer.user.id, :tab => 'notification_upd'), :notice => 'Список уведомлений отправляемых на электронную почту успешно обновлён' }
				format.json { head :no_content }
			  end
			end
		else
			redirect_to '/404'
		end
	else
		redirect_to '/404'
	end
  end
  
  def user_check
	user = User.find_by(name: params[:name], salt: params[:value], email: params[:email])
	if user != nil
		if user.user_group_id == 5
      sign_in user if !signed_in?
			user.update_attributes(:user_group_id => 3, :email_status => "Активен")
			mailer = Mailer.create(
                :user_id => user.id, 
								:album => 'no',  # Уведомление о новых фотоальбомах
								:video => 'no',  # Уведомление о новых видеозаписях
								:message => 'no', # Уведомление о всех новых сообщениях
								:article => 'no', # Уведомление о всех новых статьях
								:photo_comment => 'no', # Уведомление о всех новых комментариях к фото в альбомах пользователя
								:video_comment => 'no'
								)
			redirect_to edit_user_path(:id => user.id, :tab => 'notification_upd'), :notice => 'Ваш аккаунт успешно подтверждён'
		end
	else
		redirect_to '/404'
	end		
  end
  
  def remember_password
	  redirect_to '/404' if signed_in?
    @title = @header = 'Восстановление пароля'
  end
  
  def make_mail
	eaddr = (params[:user][:email]).strip
  user = nil
  @title = @header = 'Восстановление пароля'
  abiUsr = User.new
	if (eaddr != ''  and eaddr != nil and abiUsr.image_valid?(params[:abi][:value], params[:abi][:name]))
    users = User.all
    users.each do |u|
      if params[:user][:email] != '' and params[:user][:email] != nil
        if u.email.downcase == params[:user][:email].downcase
            user = u
          break
        end
      end
    end
		if user == nil
      flash.now[:alert] = "Пользователь с почтовым адресом <b>#{params[:user][:email]}</b> не найден"
			render 'remember_password'
		else
      flash.now[:mail] = user.email 
			redirect_to "/remember_password", :notice => "На электронный адрес <b>#{params[:user][:email]}</b> отправлено сообщение для восстановления пароля"  if UserMailer.mail_remember_password(user).deliver
		end
  elsif eaddr == '' || eaddr == nil 
    flash.now[:alert] = "Поле 'Почтовый адрес' должно быть заполнено"
    render 'remember_password'
  elsif !abiUsr.image_valid?(params[:abi][:value], params[:abi][:name])
    flash[:alert] = "Неправильно введён текст отображенный на картинке"
    render 'remember_password'
  end
  
  end
  
  def mail_switcher
	action = params[:action_type]
	user = User.find_by(salt: params[:value], name: params[:name], email: params[:email])
	if action != nil and action != '' and user != nil
		current_user = user
		case action
		when 'mail_check'
			user.mailer.update_attribute(:email, user.email)
			redirect_to edit_user_path(:id => user.id, :tab => 'notification_upd'), :notice => "Ваш E-mail: #{user.email} успешно активирован" if user.update_attribute(:email_status, 'Активен')
    when 'remember_password'
			redirect_to edit_user_path(:id => user.id, :tab => 'password_upd', :value_s => user.salt) if sign_in user
		when 'user_check'
			new_user_group = (user.user_group_id == 5)? 3 : user.user_group_id 
			user.update_attributes(:email_status => 'Активен', :user_group_id => new_user_group) #активирует E-mail и переводит пользователя в группу Друг Клуба
			redirect_to edit_user_path(:id => user.id, :tab => 'notification_upd'), :notice => 'Ваш аккаунт успешно подтверждён'
		else
			redirect_to root_path
		end
	else
		redirect_to root_path #redirect_to '/404'
	end
	
  end
  
  def check_email_and_name
  	@status = {:status => 'false'}
    users = User.all
    users.each do |u|
      if params[:email] != '' and params[:email] != nil
        if u.email.downcase == params[:email].downcase
          @status = {:status => 'true'}
          break
        end
      end
      if params[:name] != '' and params[:name] != nil
        if u.name.mb_chars.downcase == params[:name].mb_chars.downcase
          @status = {:status => 'true'}
          break
        end
      end
    end
  	respond_to do |format|
  		format.json { render :json => @status }
  	end
  end
  
  def mail_test
	#UserMailer.user_check(current_user).deliver
	#UserMailer.mail_remember_password(current_user).deliver
	#UserMailer.mail_check(current_user).deliver
  end
  def send_email_check_message
    user = User.find(params[:id])
    if (current_user == user and user != nil) || is_admin?
      if sendCheckUserData(user)
        #UserMailer.user_check(user).deliver if user.user_group_id == 5
        #UserMailer.mail_check(user).deliver if user.user_group_id != 5
        respond_to do |format|
    	    format.json {render :json => {:callback => 'success'} }
        end
      end
    end
  end
  def get_conversation
    @user = User.find(params[:id])
    redirect_to '/404' if @user.nil? || !is_not_authorized?
    redirect_to current_user.get_conversation(@user)
  end
  def steps
	  if is_super_admin?
	    @user = User.find_by(id: params[:id])
		  @steps = Step.where(user_id: @user.id)
	    respond_to do |format|
		    format.html { render 'steps/index' }
		    format.json { render :json => @steps }
	    end
	  else
		  redirect_to '/404'
    end
  end
end
