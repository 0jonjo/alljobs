# frozen_string_literal: true

module Api
  module V1
    class StarsController < Api::V1::ApiController
      include Authenticable
      # change to only auth headhunter
      before_action :authenticate_with_token
      before_action :find_id_star, only: %i[destroy]

      def index
        @stars = Star.filtered_by_headhunter(current_headhunter_id)

        render status: :ok, json: @stars.as_json(except: %i[created_at updated_at])
      end

      def destroy
        render status: :ok, json: @star if @star.destroy

        render status: :precondition_failed, json: { errors: @profile.errors.full_messages }
      end

      def create
        @star = Star.new(headhunter_id: current_headhunter_id, apply_id: params[:apply_id])

        return render status: :created, json: @star if @star.save

        render status: :precondition_failed, json: { errors: @star.errors.full_messages }
      end

      private

      def star_params
        params.require(:star).permit(:headhunter_id, :apply_id)
      end

      def find_id_star
        @star = Star.find(params[:id])
      end
    end
  end
end
