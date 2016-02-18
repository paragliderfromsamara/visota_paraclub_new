class StepsController < ApplicationController
  # GET /steps
  # GET /steps.json
  before_action :check_admin
  def index
		@steps = Step.all
		respond_to do |format|
		  format.html # index.html.erb
		  format.json { render :json => @steps }
		end
  end

  # GET /steps/1
  # GET /steps/1.json
  def show
		@step = Step.find(params[:id])
		respond_to do |format|
		  format.html # show.html.erb
		  format.json { render :json => @step }
		end
  end

  # GET /steps/new
  # GET /steps/new.json
  def new
		@step = Step.new
		respond_to do |format|
		  format.html # new.html.erb
		  format.json { render :json => @step }
		end
  end

  # GET /steps/1/edit
  def edit
		@step = Step.find(params[:id])
  end

  def update
		#@step = Step.find(params[:id])

		#respond_to do |format|
		#  if @step.update_attributes(params[:step])
		#	format.html { redirect_to @step, :notice => 'Step was successfully updated.' }
		#	format.json { head :no_content }
		#  else
		#	format.html { render :action => "edit" }
		#	format.json { render :json => @step.errors, :status => :unprocessable_entity }
		#  end
		#end
  end

  # DELETE /steps/1
  # DELETE /steps/1.json
  def destroy
		@step = Step.find(params[:id])
		@step.destroy

		respond_to do |format|
		  format.html { redirect_to steps_url }
		  format.json { head :no_content }
		end
  end
  
  def check_admin
    redirect_to '/404' if !is_super_admin?
  end
end
