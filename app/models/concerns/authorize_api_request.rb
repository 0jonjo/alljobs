# frozen_string_literal: true

class AuthorizeApiRequest
  def initialize(token)
    @token = token
  end

  def call_user
    user
  end

  def call_headhunter
    headhunter
  end

  private

  attr_reader :token

  def user
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
  end

  def headhunter
    @headhunter ||= Headhunter.find(decoded_auth_token[:headhunter_id]) if decoded_auth_token
  end

  def decoded_auth_token
    JsonWebToken.decode(@token)
  end
end
