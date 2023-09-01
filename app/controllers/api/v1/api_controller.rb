# frozen_string_literal: true

module Api
  module V1
    class ApiController < ActionController::API
      rescue_from ActiveRecord::ActiveRecordError, with: :return_500
      rescue_from ActiveRecord::RecordNotFound, with: :return_404

      private

      def return_404
        render status: 404, json: @job
      end

      def return_500
        render status: 500, json: @job
      end
    end
  end
end
