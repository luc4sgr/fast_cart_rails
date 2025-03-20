module AuthHelper
  def generate_jwt(user)
    payload = { user_id: user.id }
    JWT.encode(payload, Rails.application.secret_key_base, "HS256")
  end
end
