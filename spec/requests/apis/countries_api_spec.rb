# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Countries API', type: :request do
  let(:headhunter) { create(:headhunter) }

  before do
    allow_any_instance_of(Api::V1::CountriesController).to receive(:valid_token?).and_return(true)
    allow_any_instance_of(Api::V1::CountriesController).to receive(:decode)
      .and_return([{ 'requester_type' => 'Headhunter', 'requester_id' => headhunter.id }])
    allow_any_instance_of(Api::V1::CountriesController).to receive(:requester_exists?).and_return(true)
  end

  context 'GET /api/v1/countries' do
    it 'returns all countries ordered by name' do
      create(:country, name: 'Brazil')
      create(:country, name: 'Argentina')

      get api_v1_countries_path, headers:, as: :json

      expect(response).to have_http_status(:ok)
      expect(json_response.map { |c| c['name'] }).to eq(json_response.map { |c| c['name'] }.sort)
    end
  end
end
