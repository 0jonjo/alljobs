# frozen_string_literal: true

module Api
  module V1
    class ApiController < ActionController::API
      include Pagy::Backend
      include Token

      rescue_from ActiveRecord::ActiveRecordError, with: :return500
      rescue_from ActiveRecord::RecordNotFound,    with: :return404
      rescue_from ActiveRecord::RecordInvalid,     with: :return422

      before_action :authenticate_with_token

      private

      def return404
        render status: :not_found, json: { errors: 'Not found' }
      end

      def return422(error)
        render status: :unprocessable_entity, json: { errors: error.record.errors.full_messages }
      end

      def return500
        render status: :internal_server_error, json: { errors: 'Internal Server Error' }
      end
    end
  end
end
