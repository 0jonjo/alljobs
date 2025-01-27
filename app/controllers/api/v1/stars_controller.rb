# frozen_string_literal: true

module Api
  module V1
    class StarsController < Api::V1::ApiController
      include Authenticable
      before_action :not_headhunter, only: %i[index create destroy]

      def index
        @stars = Star.filtered_by_headhunter(@headhunter_id)

        render status: :ok, json: @stars.as_json(except: %i[created_at updated_at])
      end

      def destroy
        set_star

        return render_unauthorized if not_owner_headhunter(@star.headhunter_id)

        return render status: :precondition_failed, json: { errors: @star.errors.full_messages } if @star.errors.any?

        render status: :no_content, json: {} if @star.destroy
      end

      def create
        @star = Star.new(headhunter_id: current_headhunter_id, apply_id: params[:apply_id])

        return render status: :created, json: @star if @star.save

        render status: :precondition_failed, json: { errors: @star.errors.full_messages }
      end
    end
  end
end
