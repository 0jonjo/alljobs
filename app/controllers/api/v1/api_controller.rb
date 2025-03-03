# frozen_string_literal: true

module Api
  module V1
    # API Controller
    class ApiController < ActionController::API
      rescue_from ActiveRecord::ActiveRecordError, with: :return500
      rescue_from ActiveRecord::RecordNotFound, with: :return404

      before_action :requester, except: %i[auth_user auth_headhunter]

      def set_apply
        set_resource(:apply)
      end

      def set_job_id
        set_resource(:job, :job_id)
      end

      def set_job
        set_resource(:job)
      end

      def set_profile
        set_resource(:profile)
      end

      def set_star
        set_resource(:star)
      end

      def set_comment
        set_resource(:comment)
      end

      def requester
        if current_headhunter_id
          @requester_id = current_headhunter_id
          @requester_type = 'Headhunter'
        elsif current_user_id
          @requester_id = current_user_id
          @requester_type = 'User'
        end
      end

      private

      def set_resource(resource, param_key = :id)
        instance_variable_set("@#{resource}", resource.to_s.classify.constantize.find(params[param_key]))
      end

      def return404
        render status: :not_found, json: { errors: 'Not found' }
      end

      def return500
        render status: :internal_server_error, json: { errors: 'Internal Server Error' }
      end
    end
  end
end
