# frozen_string_literal: true

module Api
  module V1
    # JobController of API
    class JobsController < Api::V1::ApiController
      before_action :set_job, only: %i[show update destroy]

      def show
        render status: 200, json: @job
      rescue StandardError
        render status: 404, json: @job
      end

      def index
        @jobs = Job.all.sorted_id
        render status: 200, json: @jobs
      end

      def create
        @job = Job.new(job_params)
        if @job.save
          render status: 201, json: @job
        else
          render status: 412, json: { errors: @job.errors.full_messages }
        end
      end

      def update
        if @job.update(job_params)
          render status: 200, json: @job
        else
          render status: 412, json: { errors: @job.errors.full_messages }
        end
      end

      def destroy
        if @job.destroy
          render status: 204, json: {}
        else
          render status: 412, json: { errors: @job.errors.full_messages }
        end
      end

      private

      def job_params
        params.require(:job).permit(:title, :description, :skills, :salary, :company_id,
                                    :level, :country_id, :city, :date, :job_status)
      end

      def set_job
        @job = Job.find(params[:id])
      end
    end
  end
end
