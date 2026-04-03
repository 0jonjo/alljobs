# frozen_string_literal: true

module Api
  module V1
    class StarsController < Api::V1::ApiController
      before_action :not_headhunter, only: %i[index create destroy]

      def index
        @stars = Star.filtered_by_headhunter(Current.requester_id)
        render status: :ok, json: @stars.as_json(except: %i[created_at updated_at])
      end

      def create
        @star = Star.create!(headhunter_id: Current.requester_id, apply_id: params[:apply_id])
        render status: :created, json: @star
      end

      def destroy
        @star = Star.find(params[:id])

        return render_unauthorized if Current.requester_id != @star.headhunter_id

        @star.destroy!
        head :no_content
      end
    end
  end
end
