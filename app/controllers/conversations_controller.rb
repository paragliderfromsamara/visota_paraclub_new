class ConversationsController < ApplicationController
  include ConversationMessagesHelper
  before_action :check_signed_user
  before_action :set_conversation, only: [:show, :edit, :update, :destroy, :last_conversation_message]
  
  # GET /conversations
  # GET /conversations.json
  def index
    @title = @header = "Диалоги"
    @conversations = current_user.conversations#Conversation.all
    
  end

  # GET /conversations/1
  # GET /conversations/1.json
  def show
    offset = params[:offset].blank? ? 10 : params[:offset].to_i 
    if (params[:type] == 'before' || params[:type] == 'after') && !params[:val].blank?
      if params[:type] == 'before'
        prev_msg = nil
        @conversation_messages = current_user.conversation_messages(@conversation).where("conversation_message_id < ?", params[:val].to_i).last(offset)
      elsif params[:type] == 'after'   
        prev_msg = ConversationMessage.find_by(id: params[:val]) 
        @conversation_messages = current_user.conversation_messages(@conversation).where("conversation_message_id > ?", params[:val].to_i).last(offset)
      end
    else
      @conversation_messages = current_user.conversation_messages(@conversation).last(offset)
    end
    @conversation_message = ConversationMessage.new
    
    @title = @header = @conversation.alter_name(current_user)
    respond_to do |format|
      format.html
      format.json {render json: {val: current_user.conversation_messages(@conversation).size, html: cnv_message_rows(@conversation_messages,prev_msg)}}
    end
  end

  # GET /conversations/new
  def new
    @conversation = Conversation.new
    @title = @header = "Новый диалог"
  end

  # GET /conversations/1/edit
  def edit
    
  end

  # POST /conversations
  # POST /conversations.json
  def create
    @conversation = Conversation.new(conversation_params)
    @title = "Новый диалог"
    respond_to do |format|
      if @conversation.save
        format.html { redirect_to @conversation, notice: 'Диалог успешно открыт' }
        format.json { render :show, status: :created, location: @conversation }
      else
        format.html { render :new }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conversations/1
  # PATCH/PUT /conversations/1.json
  def update
    respond_to do |format|
      if @conversation.update(conversation_params)
        format.html { redirect_to @conversation, notice: 'Conversation was successfully updated.' }
        format.json { render :show, status: :ok, location: @conversation }
      else
        format.html { render :edit }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conversations/1
  # DELETE /conversations/1.json
  def destroy
    @conversation.destroy
    respond_to do |format|
      format.html { redirect_to conversations_url, notice: 'Conversation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def last_conversation_message
    f = false
    lId = 0
    lMsg = nil
    if !params[:last_visible_msg].blank?
      lId = params[:last_visible_msg].to_i
      lMsg = ConversationMessage.find(lId)
    end
    lMsgs = current_user.conversation_messages(@conversation, lId) 
    f = lMsgs.length > 0
    val = "null"
    html = "null" 
    if f
      val = lMsgs.last.conversation_message.id
      html = cnv_message_rows(lMsgs,lMsg)
    end
    render json: {need_to_upd: f, val: val, html: html }
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conversation
      @conversation = Conversation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conversation_params
      params.require(:conversation).permit(:name, :salt, :conversation_message, :assigned_users, :message_content, :user_id)
    end
    
    def check_signed_user
      redirect_to '/signin' if !signed_in?#if user_type != 'super_admin'
    end
end
