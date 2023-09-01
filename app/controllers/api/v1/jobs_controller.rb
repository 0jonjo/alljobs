# frozen_string_literal: true

module Api
  module V1
    class JobsController < Api::V1::ApiController
      before_action :find_id_job, only: %i[update destroy]

      def show
        @job = Job.find(params[:id])
        render status: 200, json: @job.as_json(except: %i[created_at updated_at])
      rescue StandardError
        render status: 404, json: @job
      end

      def index
        @jobs = Job.all
        render status: 200, json: @jobs.as_json(except: %i[created_at updated_at])
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
          render status: 200, json: @job
        else
          render status: 412, json: { errors: @job.errors.full_messages }
        end
      end

      private

      def job_params
        params.require(:job).permit(:title, :code, :description, :skills, :salary, :company_id, :level, :country_id, :city,
                                    :date, :job_status)
      end

      def find_id_job
        @job = Job.find(params[:id])
      end
    end
  end
end
