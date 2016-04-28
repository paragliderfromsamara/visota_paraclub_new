class VotesController < ApplicationController
  def index
  	@completed_votes = Vote.completed_votes
  	@active_votes = Vote.active_votes
  	@path_array = [
  						    {:name => 'Общение', :link => '/visota_life'},
  						    {:name => 'Опросы'}
  				        ]
    @title = @header = 'Опросы'
  	respond_to do |format|
  	  format.html # index.html.erb
        format.json { render :json => @votes }
  	end
  end

  def show
  	@vote = Vote.find(params[:id])
    @theme = @vote.theme
    @title = @header = (@vote.theme.blank?)? @vote.name : @vote.theme.name
  	@path_array = [
  						{:name => 'Общение', :link => '/visota_life'},
  						{:name => 'Опросы', :link => votes_path},
  						{:name => @vote.name}
  				  ]
  	respond_to do |format|
  		format.html # show.html.erb
  	  format.json { render :json => @vote }
  	end
  end

  def new
  	if !is_not_authorized?
  		@vote = Vote.new
  		@title = @header = 'Новый опрос'
  		@path_array = [
  						        {:name => 'Клубная жизнь', :link => '/visota_life'},
  						        {:name => 'Опросы', :link => votes_path},
  						        {:name => 'Новый опрос'}
  					        ]
  	else 
  		redirect_to '/404'
  	end
  end

  def create
	if !is_not_authorized?
		params[:vote][:user_id] = current_user.id
		@vote = Vote.new(params[:vote])
		respond_to do |format|
		 if @vote.save
			format.html { redirect_to @vote, :notice => 'Опрос успешно добавлен...' }
			format.json { render :json => @vote, :status => :created, :location => @vote }
		 else
			@title = 'Новый опрос'
			@add_functions = "initVoteForm('#new_vote');"
			@path_array = [
						{:name => 'Общение', :link => '/visota_life'},
						{:name => 'Опросы', :link => votes_path},
						{:name => 'Новый опрос'}
					  ]
			format.html { render :action => "new"}
			format.json { render :json => @vote.errors, :status => :unprocessable_entity }
		 end
		end
	else 
		redirect_to '/404'
	end
  end

  def edit
    @vote = Vote.find(params[:id])
    redirect_to '/404' if @vote.user != current_user && is_not_admin?
		@title = @header = 'Изменение опроса'
    @path_array = [
					{:name => 'Общение', :link => '/visota_life'},
					{:name => 'Опросы', :link => votes_path},
					{:name => @header }
				  ]
  end

  def update
    @vote = Vote.find(params[:id])
    redirect_to '/404' if @vote.user != current_user && is_not_admin?
		respond_to do |format|
		 if @vote.update_attributes(params[:vote])
			format.html { redirect_to @vote, :notice => 'Опрос успешно обновлен...' }
			format.json { render :json => @vote, :status => :updated, :location => @vote }
		 else
 			format.html { redirect_to @vote, :alert => 'Не удалось обновить опрос...' }
 			format.json { render :json => @vote, :status => :error, :location => @vote }
		 end
		end
  end

  def destroy
    vote = Vote.find_by_id(params[:id])
    if userCanEditVote?(vote)
      vote.destroy
      redirect_to votes_path
    else 
      redirect_to '/404'
    end
  end
end
