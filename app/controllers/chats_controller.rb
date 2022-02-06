class ChatsController < ApplicationController
  before_action :verify_token, only: [:index, :update, :create, :show]

  # GET /chats
  def index
    # verify_application_token or return
    @chats = @application.chats
    render status: :ok, json: @chats
  end

  # POST /chats
  def create
   #  sql = "UPDATE applications
   # SET chats_count = (@cur_value := chats_count + 1)
   # WHERE id = 1; select @cur_value;"
   #  records_array = ActiveRecord::Base.connection.execute(sql)
   Application.transaction do
     @application = @application.reload
     @application.lock!
     @application.update!(chats_count: @application.chats_count + 1)
   end

    @chat = @application.chats.new(name: chat_params[:name], identifier: @application.chats_count)
    PUBLISHER.publish({ action: "create", chat: @chat , token: params["application_token"]})
    render json: @chat, status: :created
  end

  # PATCH/PUT /chats/1
  def update
    set_chat or return
    PUBLISHER.publish({ action: "update", chat: @chat , token: params["application_token"]})
    render status: :no_content
  end

  def show
    set_chat or return
    render json: @chat
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = Chat.find_by(identifier: params[:number])
      return_entity_not_found("chat not found") and return false unless @chat
      true
    end

  def return_entity_not_found(msg)
    render json: { 'msg' => msg }, status: :not_found
  end

  def verify_token
    puts params
    @application = Application.find_by_token(params[:application_token])
    return_entity_not_found("no application was found with this token") and return false unless @application
    true
  end

    # Only allow a trusted parameter "white list" through.
    def chat_params
      params.fetch(:chat).permit(:name)
    end

  def invalid_parameters(exception)
    render json: { errors: { exception.parameter => "'Value #{ exception.value }' is invalid." } }, status: 400
  end
end
