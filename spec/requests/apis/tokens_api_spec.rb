# frozen_string_literal: true

require 'rails_helper'

describe 'Tokens API' do
  context 'POST /api/v1/tokens/auth_user' do
    let(:user) { create(:user) }

    before do
      user
    end

    it 'with sucess' do
      post api_v1_auth_user_path, params: { email: user.email, password: user.password }, as: :json

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(json_response['token']).not_to be_nil
    end

    it 'and fail because the user does not exist' do
      post api_v1_auth_user_path, params: { email: '', password: '' }, as: :json

      expect(response.status).to eq 404
      expect(json_response['error']).to include(I18n.t('auth.incorrect_data', class_name: User.model_name.human))
    end
  end

  context 'POST /api/v1/tokens/headhunter_auth' do
    let(:headhunter) { create(:headhunter) }

    before do
      headhunter
    end

    it 'with sucess' do
      post api_v1_auth_headhunter_path, params: { email: headhunter.email, password: headhunter.password }, as: :json

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(json_response['token']).not_to be_nil
    end

    it 'and fail because the headhunter does not exist' do
      post api_v1_auth_headhunter_path, params: { email: '', password: '' }, as: :json

      expect(response.status).to eq 404
      expect(json_response['error']).to include(I18n.t('auth.incorrect_data', class_name: Headhunter.model_name.human))
    end
  end
end
