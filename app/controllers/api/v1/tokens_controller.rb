# frozen_string_literal: true

module Api
  module V1
    class TokensController < Api::V1::ApiController
      include Log

      def auth_user
        authenticate('User')
      end

      def auth_headhunter
        authenticate('Headhunter')
      end

      private

      def authenticate(user_type)
        auth = Authenticate.new(params[:email], params[:password], user_type).call
        auth_user_type(user_type, auth)
      rescue ActiveRecord::RecordNotFound
        log_and_return_error(user_type)
      end

      def auth_user_type(user_type, auth)
        log_auth_request_success(user_type.constantize.model_name.human, params[:email])
        render json: { token: auth }, status: :ok
      end

      def log_and_return_error(user_type)
        log_auth_request_fail(user_type.constantize.model_name.human, params[:email])
        render json: { error: incorrect_data(user_type.constantize.model_name.human) }, status: :not_found
      end

      def incorrect_data(class_name)
        I18n.t('auth.incorrect_data', class_name:)
      end
    end
  end
end
