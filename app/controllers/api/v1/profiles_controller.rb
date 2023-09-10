# frozen_string_literal: true

module Api
  module V1
    # ProfileController of API
    class ProfilesController < Api::V1::ApiController
      before_action :find_id_profile, only: %i[update destroy]

      def show
        @profile = Profile.find(params[:id])
        render status: 200, json: @profile.as_json(except: %i[created_at updated_at])
      rescue StandardError
        render status: 404, json: @profile
      end

      def index
        @profiles = Profile.all
        render status: 200, json: @profiles.as_json(except: %i[created_at updated_at])
      end

      def create
        @profile = Profile.new(profile_params)
        if @profile.save
          render status: 201, json: @profile
        else
          render status: 412, json: { errors: @profile.errors.full_messages }
        end
      end

      def update
        if @profile.update(profile_params)
          render status: 200, json: @profile
        else
          render status: 412, json: { errors: @profile.errors.full_messages }
        end
      end

      def destroy
        if @profile.destroy
          render status: 200, json: @profile
        else
          render status: 412, json: { errors: @profile.errors.full_messages }
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
