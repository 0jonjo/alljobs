# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < Api::V1::ApiController
      include Token
      before_action :set_profile, only: %i[show update destroy]
      before_action :not_headhunter, only: %i[index destroy]
      before_action :not_owner, only: %i[show update]
      before_action :not_owner_params, only: %i[create]

      def show
        render status: :ok, json: @profile.as_json(except: %i[created_at updated_at])
      rescue ActiveRecord::RecordNotFound
        render status: :not_found, json: { errors: 'Profile not found' }
      end

      def index
        @profiles = Profile.all
        render status: :ok, json: @profiles.as_json(except: %i[created_at updated_at])
      end

      def create
        @profile = Profile.new(profile_params)
        if @profile.save
          @profile.send_mail_success('created', api_v1_profile_url(@profile.id))
          render status: :created, json: @profile
        else
          render status: :precondition_failed, json: { errors: @profile.errors.full_messages }
        end
      end

      def update
        if @profile.update(profile_params)
          render status: :ok, json: @profile
        else
          render status: :precondition_failed, json: { errors: @profile.errors.full_messages }
        end
      end

      def destroy
        if @profile.destroy
          render status: :ok, json: @profile
        else
          render status: :precondition_failed, json: { errors: @profile.errors.full_messages }
        end
      end

      private

      def not_owner
        check_authorized(@profile.user_id)
      end

      def not_owner_params
        check_authorized(params[:profile][:user_id])
      end

      def profile_params
        params.require(:profile).permit(:name, :social_name, :birthdate, :description, :educacional_background,
                                        :experience, :city, :user_id, :country_id)
      end
    end
  end
end
