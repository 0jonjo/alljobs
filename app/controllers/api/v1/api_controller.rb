# frozen_string_literal: true

module Api
  module V1
    # API Controller
    class ApiController < ActionController::API
      rescue_from ActiveRecord::ActiveRecordError, with: :return500
      rescue_from ActiveRecord::RecordNotFound, with: :return404

      private

      def return404
        render status: 404, json: @job
      end

      def return500
        render status: 500, json: @job
      end
    end
  end
end
