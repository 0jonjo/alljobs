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
    @requester_id if @requester_type == 'Headhunter'
  end

  def current_user_id
    @requester_id if @requester_type == 'User'
  end

  def not_headhunter
    render_unauthorized unless current_headhunter_id
  end

  def check_authorized(user_id)
    render_unauthorized unless @requester_type == 'Headhunter' || (@requester_type == 'User' && @requester_id == user_id)
  end

  private

  def decoded_token
    JsonWebToken.decode(@token)
  end

  def valid_token?
    decoded_token.first['exp'] > Time.now.to_i if decoded_token
  end
end
