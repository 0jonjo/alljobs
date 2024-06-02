# frozen_string_literal: true

require 'rails_helper'

describe 'API' do
  context 'Try a route' do
    it 'without an authorization' do
      get '/api/v1/jobs'

      expect(response.status).to eq 401
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(json_response).to include('errors' => 'Provide an valid Authorization header.')
    end

    it 'without a valid authorization' do
      get '/api/v1/jobs', headers: { Authorization: '012345678' }, as: :json

      expect(response.status).to eq 401
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(json_response).to include('errors' => 'Provide an valid Authorization header.')
    end

    context 'with a expired authorization' do
      let(:user) { create(:user) }
      let(:token) { JsonWebToken.encode(user_id: user.id, exp: 1.second.ago) }

      it 'and is redirect to root path' do
        get '/api/v1/jobs', headers: { Authorization: token }, as: :json

        expect(response.status).to eq 401
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response).to include('errors' => 'Provide an valid Authorization header.')
      end
    end
  end
end
