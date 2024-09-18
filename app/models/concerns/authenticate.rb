# frozen_string_literal: true

class Authenticate
  def initialize(email, password, account_type)
    @email = email
    @password = password
    @account_type = account_type
  end

  def call
    authenticate!

    JsonWebToken.encode(@payload)
  end

  private

  attr_reader :email, :password

  def authenticate!
    @account = @account_type.constantize.find_by(email:)
    raise ActiveRecord::RecordNotFound unless @account&.valid_password?(password)

    @account_type == 'User' ? user_payload : headhunter_payload
  end

  def user_payload
    @payload = { user_id: @account.id }
  end

  def headhunter_payload
    @payload = { headhunter_id: @account.id }
  end
end
