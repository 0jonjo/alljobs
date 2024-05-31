# frozen_string_literal: true

class Authenticate
  def initialize(email, password)
    @email = email
    @password = password
  end

  def call_user
    JsonWebToken.encode(user_id: user.id) if user
  end

  def call_headhunter
    JsonWebToken.encode(headhunter_id: headhunter.id) if headhunter
  end

  private

  attr_reader :email, :password

  def user
    user ||= User.find_by(email: email)
    return user if user&.valid_password?(password)

    raise ActiveRecord::RecordNotFound
  end

  def headhunter
    headhunter ||= Headhunter.find_by(email: email)
    return headhunter if headhunter&.valid_password?(password)

    raise ActiveRecord::RecordNotFound
  end
end
