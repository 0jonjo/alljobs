# frozen_string_literal: true

module Api
  module V1
    # API Controller
    class ApiController < ActionController::API
      rescue_from ActiveRecord::ActiveRecordError, with: :return500
      rescue_from ActiveRecord::RecordNotFound, with: :return404

      def set_apply
        @apply = Apply.find(params[:id])
      end

      def set_job
        @job = Job.find(params[:job_id])
      end

      def set_profile
        @profile = Profile.find(params[:id])
      end

      def set_star
        @star = Star.find(params[:id])
      end

      private

      def return404
        render status: :not_found, json: { errors: 'Not found' }
      end

      def return500
        render status: :internal_server_error, json: { errors: 'Internal Server Error' }
      end
    end
  end
end
