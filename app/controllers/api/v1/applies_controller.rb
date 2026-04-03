# frozen_string_literal: true

module Api
  module V1
    class AppliesController < Api::V1::ApiController
      before_action :set_apply, only: %i[show destroy]
      before_action :not_owner, only: %i[show destroy]
      before_action :not_owner_params, only: %i[create]

      def index
        @applies = Apply.all.sorted_id
        render status: :ok, json: @applies
      end

      def show
        render status: :ok, json: @apply.as_json(except: %i[created_at updated_at])
      end

      def create
        @apply = Apply.create!(apply_params)
        render status: :created, json: @apply, location: api_v1_job_apply_path(@apply.job_id, @apply.id)
      end

      def destroy
        @apply.destroy!
        render status: :ok, json: {}
      end

      private

      def set_apply
        @apply = Apply.find(params[:id])
      end

      def not_owner
        check_authorized(@apply.user_id)
      end

      def not_owner_params
        check_authorized(params[:apply][:user_id])
      end

      def apply_params
        params.expect(apply: %i[job_id user_id])
      end
    end
  end
end
