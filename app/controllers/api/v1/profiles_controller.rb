# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < Api::V1::ApiController
      include Authenticable
      before_action :authenticate_with_token
      before_action :find_id_profile, only: %i[show update destroy]

      def show
        render status: :ok, json: @profile.as_json(except: %i[created_at updated_at])
      rescue StandardError
        render status: :not_found, json: @profile
      end

      def index
        @profiles = Profile.all
        render status: :ok, json: @profiles.as_json(except: %i[created_at updated_at])
      end

      def create
        @profile = Profile.new(profile_params)
        if @profile.save
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

      def profile_params
        params.require(:profile).permit(:name, :social_name, :birthdate, :description, :educacional_background,
                                        :experience, :city, :user_id, :country_id)
      end

      def find_id_profile
        @profile = Profile.find(params[:id])
      end
    end
  end
end
