class ApplicationsController < ApplicationController
  before_action :verify_application_token, only: [:show, :update]

  # GET /applications
  def show
    render json: @application, status: :ok
  end

  # POST /applications

  def create
    @application = Application.new(name: application_params[:name])
    if @application.save
      render json: @application, status: :created
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /applications
  def update
    if @application.update(name: application_params[:name])
      render status: :no_content
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_application
    @application = Application.find(params[:id])
  end

  def return_entity_not_found
    render json: { 'msg' => "no application was found with this token" }, status: :not_found
  end

  def verify_application_token
    @application = Application.find_by(token: params[:token])
    return_entity_not_found and return false unless @application
    true
  end

  # Only allow a trusted parameter "white list" through.
  def application_params
    params.fetch(:application).permit(:name)
  end
end