class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def encode_token(payload)
    JWT.encode(payload, ENV["JWT_SECRET_KEY"])
  end

  def decode_token
    auth_header = request.headers["Authorization"]
    if auth_header
      token = auth_header.split(" ").last
      begin
        JWT.decode(token, ENV["JWT_SECRET_KEY"], true, algorithm: "HS256")

      rescue JWT::DecodeError
          nil
      end

    end
  end

  def authorized_account
      decoded_token = decode_token()
      if decoded_token
        account_number = decoded_token[0]["account_number"]
        @account = Account.find_by(number: account_number)
      end
  end

  def authorize
      render json: { message: "Você precisa estar logado" }, status: :unauthorized unless authorized_account
  end
end
