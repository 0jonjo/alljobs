# frozen_string_literal: true

module Api
  module V1
    # ApplyController of API
    class AppliesController < Api::V1::ApiController
      include Authenticable
      before_action :authenticate_with_token
      before_action :apply, only: %i[destroy]
      before_action :job, only: %i[destroy]

      def show
        @apply = Apply.find(params[:id])
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

      def apply_params
        params.require(:apply).permit(:job_id, :user_id, :feedback_headhunter)
      end

      def apply_update_params
        params.require(:apply).permit(:feedback_headhunter)
      end

      def apply
        @apply = Apply.find(params[:id])
      end

      def job
        @job = Job.find(params[:job_id])
      end
    end
  end
end
