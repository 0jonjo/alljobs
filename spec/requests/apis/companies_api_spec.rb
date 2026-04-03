# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Companies API', type: :request do
  let(:headhunter) { create(:headhunter) }

  before do
    allow_any_instance_of(Api::V1::CompaniesController).to receive(:valid_token?).and_return(true)
    allow_any_instance_of(Api::V1::CompaniesController).to receive(:decode)
      .and_return([{ 'requester_type' => 'Headhunter', 'requester_id' => headhunter.id }])
    allow_any_instance_of(Api::V1::CompaniesController).to receive(:requester_exists?).and_return(true)
  end

  context 'GET /api/v1/companies' do
    it 'returns all companies' do
      create(:company, name: 'Alpha Corp')
      create(:company, name: 'Beta Ltd')

      get api_v1_companies_path, headers:, as: :json

      expect(response).to have_http_status(:ok)
      expect(json_response.length).to be >= 2
    end
  end

  context 'GET /api/v1/companies/:id' do
    it 'returns the company' do
      company = create(:company)

      get api_v1_company_path(company.id), headers:, as: :json

      expect(response).to have_http_status(:ok)
      expect(json_response['name']).to eq(company.name)
    end

    it 'returns 404 when not found' do
      get api_v1_company_path(99_999_999), headers:, as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'POST /api/v1/companies' do
    it 'creates a company' do
      post api_v1_companies_path, params: { company: { name: 'New Corp' } }, headers:, as: :json

      expect(response).to have_http_status(:created)
      expect(json_response['name']).to eq('New Corp')
    end

    it 'returns 422 with invalid params' do
      post api_v1_companies_path, params: { company: { name: '' } }, headers:, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'PUT /api/v1/companies/:id' do
    it 'updates a company' do
      company = create(:company, name: 'Old Name')

      put api_v1_company_path(company.id), params: { company: { name: 'New Name' } }, headers:, as: :json

      expect(response).to have_http_status(:ok)
      expect(json_response['name']).to eq('New Name')
    end
  end
end
