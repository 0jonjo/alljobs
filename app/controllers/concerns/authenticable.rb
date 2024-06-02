# frozen_string_literal: true

module Authenticable
  def authenticate_with_token
    @token ||= request.headers["Authorization"]

    render_unauthorized unless valid_token?
  end

  def valid_token?
    body = JsonWebToken.decode(@token)
    return false if body.nil?
    return false if body[0]["exp"] < Time.now.to_i
    true
  end

  def render_unauthorized
    render json: { errors: "Provide an valid Authorization header." },
           status: :unauthorized
  end
end
