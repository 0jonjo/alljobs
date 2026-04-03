# frozen_string_literal: true

module Api
  module V1
    class JobsController < Api::V1::ApiController
      before_action :set_job, only: %i[show update destroy stars]

      def index
        @pagy, @jobs = pagy(filtered_jobs)
        render status: :ok, json: { data: @jobs, pagination: pagy_metadata(@pagy) }
      end

      def show
        render status: :ok, json: @job
      end

      def create
        @job = Job.create!(job_params)
        render status: :created, json: @job, location: api_v1_job_path(@job)
      end

      def update
        @job.update!(job_params)
        render status: :ok, json: @job
      end

      def destroy
        @job.destroy!
        head :no_content
      end

      def stars
        return render_unauthorized unless Current.headhunter?

        render status: :ok, json: @job.stars(Current.requester_id)
      end

      private

      def filtered_jobs
        Job.published
           .search(params[:title])
           .by_level(params[:level])
           .by_work_mode(params[:work_mode])
           .by_country(params[:country_id])
           .sorted_id
      end

      def set_job
        @job = Job.find(params[:id])
      end

      def job_params
        params.expect(job: %i[title description skills salary company_id
                              level country_id city date job_status work_mode contract_type])
      end
    end
  end
end
