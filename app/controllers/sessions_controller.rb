class SessionsController < ApplicationController
  def new
    redirect_to current_user if signed_in? 
	 @title = @header = 'Вход на сайт'
   @hideSesPanel = true
   render layout: false if params[:nolayout] == "true" 
  end

  def create
    redirect_to current_user if signed_in? 
	@title = @header = 'Вход на сайт'
    @user = User.authenticate(params[:session][:name],
                             params[:session][:password])
    if @user.nil?
      flash.now[:alert] = "Неверное имя пользователя или пароль"
      @title = @header = 'Вход на сайт'
      @hideSesPanel = true
	    respond_to do |format|
	      format.html { render 'new' }
        format.js {}
      end
    else
      sign_in @user
	    respond_to do |format|
	      format.html { redirect_to @user }
        format.js {}
      end
    end
  end

  def destroy
	sign_out
    redirect_to root_path
  end
end
