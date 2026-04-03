# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < Api::V1::ApiController
      before_action :set_profile, only: %i[show update destroy]
      before_action :not_headhunter, only: %i[index destroy]
      before_action :not_owner, only: %i[show update]
      before_action :not_owner_params, only: %i[create]

      def index
        @pagy, @profiles = pagy(Profile.order(:id))
        render status: :ok,
               json: { data: @profiles.as_json(except: %i[created_at updated_at]), pagination: pagy_metadata(@pagy) }
      end

      def show
        render status: :ok, json: @profile.as_json(except: %i[created_at updated_at])
      end

      def create
        @profile = Profile.create!(profile_params)
        @profile.send_mail_success('created', api_v1_profile_url(@profile.id))
        render status: :created, json: @profile
      end

      def update
        @profile.update!(profile_params)
        render status: :ok, json: @profile
      end

      def destroy
        @profile.destroy!
        render status: :ok, json: @profile
      end

      private

      def set_profile
        @profile = Profile.find(params[:id])
      end

      def not_owner
        check_authorized(@profile.user_id)
      end

      def not_owner_params
        check_authorized(params[:profile][:user_id])
      end

      def profile_params
        params.expect(profile: %i[name social_name birthdate description educational_background
                                  experience city user_id country_id])
      end
    end
  end
end
