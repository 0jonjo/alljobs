# frozen_string_literal: true

module Authenticable
  def authenticate_with_token
    @token ||= request.headers['Authorization']

    render_unauthorized unless valid_token?
  end

  def valid_token?
    @token.present? && @token.size >= 10
  end

  def render_unauthorized
    render json: { errors: 'Provide an valid Authorization header.' },
           status: :unauthorized
  end
end
