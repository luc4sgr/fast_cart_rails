class AuthController < ApplicationController
    skip_before_action :authenticate_request, only: [:login]

    def login
      user = User.find_by(email: params[:email])
  
      if user
        token = JwtService.encode(user_id: user.id)
        render json: { token: token, user: user }, status: :ok
      else
        render json: { error: "Usuário não encontrado" }, status: :unauthorized
      end
    end
  end
  