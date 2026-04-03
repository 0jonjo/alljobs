# frozen_string_literal: true

module Api
  module V1
    class CompaniesController < Api::V1::ApiController
      before_action :not_headhunter
      before_action :set_company, only: %i[show update]

      def index
        @companies = Company.order(:name)
        render status: :ok, json: @companies
      end

      def show
        render status: :ok, json: @company
      end

      def create
        @company = Company.create!(company_params)
        render status: :created, json: @company, location: api_v1_company_path(@company)
      end

      def update
        @company.update!(company_params)
        render status: :ok, json: @company
      end

      private

      def set_company
        @company = Company.find(params[:id])
      end

      def company_params
        params.expect(company: %i[name description email phone website])
      end
    end
  end
end
