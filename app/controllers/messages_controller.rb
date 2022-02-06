class MessagesController < ApplicationController
  before_action :verify

  # GET /messages
  def index
    @messages = @chat.messages
    render json: @messages, status: :ok
  end

  # GET /messages/1
  def show
    set_message or return
    render json: @message
  end

  # POST /messages
  def create
    Chat.transaction do
      @chat = @chat.reload
      @chat.lock!
      @chat.update!(messages_count: @chat.messages_count + 1)
    end

    @message = @chat.messages.new(name: message_params[:body], identifier: @chat.messages_count)
    PUBLISHER.publish({ action: "create", message: @message , chat_identifier: params["chat_identifier"]})
    render json: @message, status: :created
  end

  # PATCH/PUT /messages/1
  def update
    if @message.update(message_params)
      render json: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /messages/1
  def destroy
    @message.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = @chat.messages.find_by(params[:message_number])
    end

    # Only allow a trusted parameter "white list" through.
    def message_params
      params.fetch(:message).permit(:body)
    end

  def return_entity_not_found(msg)
    render json: { 'msg' => msg }, status: :not_found
  end

  def verify
    puts params
    @application = Application.find_by(token: params[:application_token])
    return_entity_not_found("no application was found with this token") and return false unless @application

    @chat = @application.chats.find_by("identifier": params[:chat_number])
    return_entity_not_found("chat identifier is not found") and return false unless @chat

    true
  end
end
