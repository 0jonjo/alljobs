# frozen_string_literal: true

class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
    end

    def decode(token)
      JWT.decode(token, Rails.application.secret_key_base, true, algorithms: ['HS256'])
    rescue StandardError
      nil
    end
  end
end
