# frozen_string_literal: true

require 'rails_helper'

describe 'API' do
  context 'Try a route' do
    subject { JSON.parse(response.body) }

    it 'without an authorization' do
      get '/api/v1/jobs'

      expect(response.status).to eq 401
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(subject).to include('errors' => 'Provide an valid Authorization header.')
    end

    it 'without a valid authorization' do
      get '/api/v1/jobs', headers: { Authorization: '012345678' }, as: :json

      expect(response.status).to eq 401
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(subject).to include('errors' => 'Provide an valid Authorization header.')
    end
  end
end
