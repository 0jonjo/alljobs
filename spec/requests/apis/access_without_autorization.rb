# frozen_string_literal: true

require 'rails_helper'

describe 'API' do
  context 'Try a route' do
    it 'without an authorization' do
      get '/api/v1/jobs'

      expect(response.status).to eq 401
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(json_response).to include('error' => I18n.t('auth.unauthorized'))
    end

    it 'without a valid authorization' do
      get '/api/v1/jobs', headers: { Authorization: '012345678' }, as: :json

      expect(response.status).to eq 401
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(json_response).to include('error' => I18n.t('auth.unauthorized'))
    end

    context 'with an expired authorization' do
      let(:user) { create(:user) }
      let(:token) { JsonWebToken.encode(user_id: user.id, exp: 1.second.ago) }

      it 'and receive the correct error' do
        travel 1.second do
          get '/api/v1/jobs', headers: { Authorization: token }, as: :json

          # expect(response.status).to eq 401
          expect(response.content_type).to eq('application/json; charset=utf-8')
          expect(json_response).to include('error' => I18n.t('auth.unauthorized'))
        end
      end
    end
  end
end
