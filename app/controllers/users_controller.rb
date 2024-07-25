class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :create, :destroy ]

  def new
    @user = User.new
  end

  def index
    @users = User.all
    render json: @users
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user.as_json.merge(image_url: @user.image_url), status: :created
    else
      Rails.logger.error("#{@user.errors.full_messages.inspect}")
      render json: { errors: format_errors(@user.errors) }, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user
      render json: @user
    else
      Rails.logger.error("User with ID #{params[:id]} not found")
      render json: { error: "User with ID #{params[:id]} not found" }, status: :not_found
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    if @user
      @user.destroy
      render json: { message: "User deleted successfully" }, status: :ok
    else
      Rails.logger.error("User with ID #{params[:id]} not found")
      render json: { error: "User with ID #{params[:id]} not found" }, status: :not_found
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :image)
  end

  def format_errors(errors)
    messages = errors.full_messages.map do |message|
      case message
      when /minimum/
        "#{message}"
      when /valid email/
        "#{message}"
      when /can't be blank/
        "#{message}"
      else
        "#{message}"
      end
    end
    messages
  end
end
