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

  def current_headhunter_id
    body = JsonWebToken.decode(@token)

    body[0]['headhunter_id'] if body && body[0] && body[0]['headhunter_id']
  end

  def current_user_id
    body = JsonWebToken.decode(@token)

    body[0]['user_id'] if body && body[0] && body[0]['user_id']
  end

  def not_headhunter
    render_unauthorized unless current_headhunter_id
  end

  def not_owner
    check_authorized(@profile.user_id)
  end

  def not_owner_apply
    check_authorized(@apply.user_id)
  end

  def not_owner_params_apply
    check_authorized(params[:apply][:user_id])
  end

  def not_owner_params
    check_authorized(params[:profile][:user_id])
  end

  def check_authorized(user_id)
    render_unauthorized unless current_headhunter_id || (current_user_id && current_user_id == user_id)
  end
end
