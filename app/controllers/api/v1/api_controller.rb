# frozen_string_literal: true

module Api
  module V1
    # API Controller
    class ApiController < ActionController::API
      include Token

      rescue_from ActiveRecord::ActiveRecordError, with: :return500
      rescue_from ActiveRecord::RecordNotFound, with: :return404

      before_action :authenticate_with_token, except: %i[auth_user auth_headhunter]

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

      private

      def set_resource(resource, param_key = :id)
        # Security: Use allowlist to prevent arbitrary class instantiation
        allowed_resources = {
          'apply' => 'Apply',
          'job' => 'Job',
          'profile' => 'Profile',
          'star' => 'Star',
          'comment' => 'Comment'
        }

        class_name = allowed_resources[resource.to_s]
        raise ArgumentError, "Invalid resource type: #{resource}" unless class_name

        instance_variable_set("@#{resource}", class_name.constantize.find(params[param_key]))
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
