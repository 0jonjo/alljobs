# frozen_string_literal: true

module Token
  def authenticate_with_token
    @token ||= request.headers['Authorization']

    render_unauthorized unless valid_token?
  end

  def render_unauthorized
    render json: { error: I18n.t('auth.unauthorized') },
           status: :unauthorized
  end

  def current_headhunter_id
    get_id('headhunter')
  end

  def current_user_id
    get_id('user')
  end

  def not_headhunter
    render_unauthorized unless current_headhunter_id
  end

  def not_owner_headhunter(headhunter_id)
    current_headhunter_id != headhunter_id
  end

  def not_owner_user(user_id)
    current_user_id != user_id
  end

  def check_existence
    render_unauthorized unless current_headhunter_id || current_user_id
  end

  def check_authorized(user_id)
    render_unauthorized unless current_headhunter_id || (current_user_id && current_user_id == user_id)
  end

  def check_user_owner(user_id)
    current_user_id == user_id if current_user_id
  end

  private

  def get_id(user_type)
    return unless decoded_token&.first

    decoded_token.first["#{user_type}_id".to_sym]
  end

  def decoded_token
    JsonWebToken.decode(@token)
  end

  def valid_token?
    decoded_token.first['exp'] > Time.now.to_i if decoded_token
  end
end
