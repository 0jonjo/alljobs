# frozen_string_literal: true

module Api
  module V1
    class TokensController < Api::V1::ApiController
      def auth_user
        auth = Authenticate.new(params[:email], params[:password]).call_user
        log_auth_request_success(User.model_name.human, params[:email])
        render status: :ok, json: { token: auth }
      rescue ActiveRecord::RecordNotFound
        log_auth_request_fail(User.model_name.human, params[:email])
        render json: { error: incorrect_data_user }, status: :not_found
      end

      def auth_headhunter
        auth = Authenticate.new(params[:email], params[:password]).call_headhunter
        log_auth_request_success(Headhunter.model_name.human, params[:email])
        render status: :ok, json: { token: auth }
      rescue ActiveRecord::RecordNotFound
        log_auth_request_fail(Headhunter.model_name.human, params[:email])
        render json: { error: incorrect_data_headhunter }, status: :not_found
      end

      private

      def log_auth_request_success(class_name, email)
        logger.info(I18n.t("auth.log.auth_request_success", class_name: class_name, email: email))
      end

      def log_auth_request_fail(class_name, email)
        logger.info(I18n.t("auth.log.auth_request_fail", class_name: class_name, email: email))
      end

      def incorrect_data_user
        I18n.t("auth.incorrect_data", class_name: User.model_name.human)
      end

      def incorrect_data_headhunter
        I18n.t("auth.incorrect_data", class_name: Headhunter.model_name.human)
      end
    end
  end
end
