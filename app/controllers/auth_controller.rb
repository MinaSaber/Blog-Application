class AuthController < ApplicationController
  skip_before_action :authorized, only: [ :login ]

    def login
        @user = User.find_by!(email: login_params[:email])
        if @user.authenticate(login_params[:password])
            @token = encode_token(user_id:  @user.id)
            render json: { token: @token }, status: :accepted
        else
            render json: { message: "Incorrect password" }, status: :unauthorized
        end
    end

    private

    def login_params
        params.require(:user).permit(:email, :password)
    end

    def handle_record_not_found(e)
        render json: { message: "User doesn't exist" }, status: :unauthorized
    end
end
