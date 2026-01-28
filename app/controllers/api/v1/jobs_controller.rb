# frozen_string_literal: true

module Api
  module V1
    class JobsController < Api::V1::ApiController
      include Token
      before_action :set_job, only: %i[show update destroy stars]

      def show
        render status: :ok, json: @job
      rescue ActiveRecord::RecordNotFound
        render status: :not_found, json: { errors: 'Job not found' }
      end

      def index
        @jobs = Job.search(params[:title]).sorted_id
        render status: :ok, json: @jobs
      end

      def create
        @job = Job.new(job_params)
        if @job.save
          render status: :created, json: @job, location: api_v1_job_path(@job)
        else
          render status: :precondition_failed, json: { errors: @job.errors.full_messages }
        end
      end

      def update
        if @job.update(job_params)
          render status: :ok, json: @job
        else
          render status: :precondition_failed, json: { errors: @job.errors.full_messages }
        end
      end

      def destroy
        if @job.destroy
          render status: :no_content, json: {}
        else
          render status: :precondition_failed, json: { errors: @job.errors.full_messages }
        end
      end

      def stars
        headhunter_id = @requester_id && @requester_type == 'Headhunter'

        return render_unauthorized unless headhunter_id

        stars = @job.stars(headhunter_id)
        render status: :ok, json: stars
      rescue ActiveRecord::RecordNotFound
        render status: :not_found, json: { errors: 'Stars not found' }
      end

      private

      def job_params
        params.require(:job).permit(:title, :description, :skills, :salary, :company_id,
                                    :level, :country_id, :city, :date, :job_status)
      end
    end
  end
end
