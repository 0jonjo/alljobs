# frozen_string_literal: true

module Api
  module V1
    class CountriesController < Api::V1::ApiController
      def index
        @countries = Country.order(:name)
        render status: :ok, json: @countries
      end
    end
  end
end
