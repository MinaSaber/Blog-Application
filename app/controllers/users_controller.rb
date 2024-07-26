class UsersController < ApplicationController
  skip_before_action :authorized, only: [ :create ]
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user.custom_user_parameters, status: :created
    else
      Rails.logger.error("#{@user.errors.full_messages.inspect}")
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def me
    render json: current_user.custom_user_parameters, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :image)
  end
end
