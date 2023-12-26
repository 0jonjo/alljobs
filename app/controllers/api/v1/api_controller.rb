# frozen_string_literal: true

module Api
  module V1
    # API Controller
    class ApiController < ActionController::API
      rescue_from ActiveRecord::ActiveRecordError, with: :return500
      rescue_from ActiveRecord::RecordNotFound, with: :return404

      private

      def return404
        render status: :not_found, json: @job
      end

      def return500
        render status: :internal_server_error, json: @job
      end
    end
  end
end
