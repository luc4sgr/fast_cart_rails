class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    if token
      decoded = JwtService.decode(token)
      @current_user = User.find(decoded[:user_id]) if decoded
    end

    render json: { error: "Não autorizado" }, status: :unauthorized unless @current_user
  end
end
