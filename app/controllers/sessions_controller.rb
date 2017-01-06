class SessionsController < ApplicationController
  def new
	 @title = @header = 'Вход на сайт'
   @hideSesPanel = true
   render layout: false if params[:nolayout] == "true" 
  end

  def create
	@title = @header = 'Вход на сайт'
    user = User.authenticate(params[:session][:name],
                             params[:session][:password])
    if user.nil?
      flash.now[:alert] = "Неверное имя пользователя или пароль"
      @title = @header = 'Вход на сайт'
      @hideSesPanel = true
	    respond_to do |format|
	      format.html { render 'new' }
		    format.json { head :no_content }
	    end
    else
      sign_in user
	    redirect_to user
    end
  end

  def destroy
	sign_out
    redirect_to root_path
  end
end
