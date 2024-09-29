# frozen_string_literal: true

module Api
  module V1
    class StarsController < Api::V1::ApiController
      include Authenticable
      before_action :authenticate_with_token
      before_action :headhunter_id

      def index
        @stars = Star.filtered_by_headhunter(@headhunter_id)

        render status: :ok, json: @stars.as_json(except: %i[created_at updated_at])
      end

      def destroy
        set_star

        return render status: :unauthorized, json: { error: 'Unauthorized' } unless @star.headhunter_id == @headhunter_id

        return render status: :no_content, json: {} if @star.destroy

        render status: :precondition_failed, json: { errors: @profile.errors.full_messages }
      end

      def create
        @star = Star.new(headhunter_id: @headhunter_id, apply_id: params[:apply_id])

        return render status: :created, json: @star if @star.save

        render status: :precondition_failed, json: { errors: @star.errors.full_messages }
      end

      private

      def headhunter_id
        @headhunter_id = current_headhunter_id
        @headhunter_id || render_unauthorized
      end
    end
  end
end
