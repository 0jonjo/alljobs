# frozen_string_literal: true

module Api
  module V1
    class TokensController < Api::V1::ApiController

      def auth_user
        auth = Authenticate.new(params[:email], params[:password]).call_user
        render status: :ok, json: { token: auth }

      rescue Authenticate::AuthenticationError => e
        render json: { error: e.message }, status: :not_found
      end

      def auth_headhunter
        auth = Authenticate.new(params[:email], params[:password]).call_headhunter
        render status: :ok, json: { token: auth }

      rescue Authenticate::AuthenticationError => e
        render json: { error: e.message }, status: :not_found
      end
    end
  end
end
