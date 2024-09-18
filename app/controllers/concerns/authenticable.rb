# frozen_string_literal: true

module Authenticable
  def authenticate_with_token
    @token ||= request.headers['Authorization']

    render_unauthorized unless valid_token?
  end

  def valid_token?
    body = JsonWebToken.decode(@token)
    body[0]['exp'] > Time.now.to_i if body
  end

  def render_unauthorized
    render json: { error: I18n.t('auth.unauthorized') },
           status: :unauthorized
  end
end
