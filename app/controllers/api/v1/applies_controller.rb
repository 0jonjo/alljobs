# frozen_string_literal: true

module Api
  module V1
    # ApplyController of API
    class AppliesController < Api::V1::ApiController
      include Token

      before_action :set_apply, only: %i[show destroy]
      before_action :set_job_id, only: %i[destroy]
      before_action :not_owner, only: %i[show destroy]
      before_action :not_owner_params, only: %i[create]

      def show
        render status: :ok, json: @apply.as_json(except: %i[created_at updated_at])
      rescue StandardError
        render status: :not_found, json: @apply
      end

      def index
        @applies = Apply.all.sorted_id
        render status: :ok, json: @applies
      end

      def create
        @apply = Apply.new(apply_params)
        if @apply.save
          render status: :created, json: @apply, location: api_v1_job_apply_path(@apply.job_id, @apply.id)
        else
          render status: :precondition_failed, json: { errors: @apply.errors.full_messages }
        end
      end

      def destroy
        if @apply.destroy
          render status: :ok, json: {}
        else
          render status: :precondition_failed, json: { errors: @apply.errors.full_messages }
        end
      end

      private

      def not_owner
        check_authorized(@apply.user_id)
      end

      def not_owner_params
        check_authorized(params[:apply][:user_id])
      end

      def apply_params
        params.require(:apply).permit(:job_id, :user_id)
      end
    end
  end
end
