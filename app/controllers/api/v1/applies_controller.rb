# frozen_string_literal: true

module Api
  module V1
    # ApplyController of API
    class AppliesController < Api::V1::ApiController
      before_action :apply, only: %i[update destroy]
      before_action :job, only: %i[update destroy]

      def show
        @apply = Apply.find(params[:id])
        render status: 200, json: @apply.as_json(except: %i[created_at updated_at])
      rescue StandardError
        render status: 404, json: @apply
      end

      def index
        @applys = Apply.all
        render status: 200, json: @applys.as_json(except: %i[created_at updated_at])
      end

      def create
        @apply = Apply.new(apply_params)
        if @apply.save
          render status: 201, json: @apply
        else
          render status: 412, json: { errors: @apply.errors.full_messages }
        end
      end

      def update
        if @apply.update(apply_update_params)
          render status: 200, json: @apply
        else
          render status: 412, json: { errors: @apply.errors.full_messages }
        end
      end

      def destroy
        if @apply.destroy
          render status: 200, json: @apply
        else
          render status: 412, json: { errors: @apply.errors.full_messages }
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
