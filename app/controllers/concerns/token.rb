# frozen_string_literal: true

module Token
  ALLOWED_REQUESTER_TYPES = %w[User Headhunter].freeze

  def authenticate_with_token
    token = request.headers['Authorization']

    @decoded_token = decode(token)

    return render_unauthorized unless valid_token?

    @requester_type = @decoded_token.first['requester_type']
    @requester_id   = @decoded_token.first['requester_id']

    return render_unauthorized unless requester_exists?

    Current.requester_id   = @requester_id
    Current.requester_type = @requester_type
  end

  def render_unauthorized
    render json: { error: I18n.t('auth.unauthorized') },
           status: :unauthorized
  end

  def requester_exists?
    return false unless ALLOWED_REQUESTER_TYPES.include?(@requester_type)

    @requester_type.constantize.exists?(@requester_id)
  end

  def not_headhunter
    render_unauthorized if Current.requester_type != 'Headhunter'
  end

  def check_authorized(user_id)
    render_unauthorized unless Current.requester_type == 'Headhunter' ||
                               (Current.requester_type == 'User' && Current.requester_id == user_id)
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
