# frozen_string_literal: true

module Token
  def authenticate_with_token
    token ||= request.headers['Authorization']

    @decoded_token = decode(token)

    render_unauthorized unless valid_token?

    @requester_type = @decoded_token.first['requester_type']

    @requester_id = @decoded_token.first['requester_id']

    render_unauthorized unless requester_exists?
  end

  def render_unauthorized
    render json: { error: I18n.t('auth.unauthorized') },
           status: :unauthorized
  end

  def current_headhunter_id
    @requester_id if @requester_type == 'Headhunter'
  end

  def requester_exists?
    @requester_type.constantize.find(@requester_id)
  end

  def not_headhunter
    render_unauthorized if @requester_type != 'Headhunter'
  end

  def check_authorized(user_id)
    render_unauthorized unless @requester_type == 'Headhunter' || (@requester_type == 'User' && @requester_id == user_id)
  end

  private

  def decode(token)
    JsonWebToken.decode(token)
  end

  def valid_token?
    @decoded_token.first['exp'] > Time.now.to_i if @decoded_token
  rescue StandardError
    false
  end
end
