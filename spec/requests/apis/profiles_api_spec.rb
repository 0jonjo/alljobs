# frozen_string_literal: true

require 'rails_helper'

describe 'Profile API' do
  subject { JSON.parse(response.body) }

  let!(:country) { create(:country) }
  let!(:user) { create(:user) }
  let(:profile_valid_attributes) { attributes_for(:profile, country_id: country.id, user_id: user.id) }

  context 'GET /api/v1/profiles/1' do
    it 'with sucess' do
      profile = create(:profile)

      get api_v1_profile_path(profile.id), as: :json

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(subject['name']).to include(profile.name)
      expect(subject['description']).to include(profile.description)
      expect(subject.keys).not_to include('created_at')
      expect(subject.keys).not_to include('updated_at')
    end

    it "and fail because can't find the profile" do
      get api_v1_profile_path(99_999_999), as: :json
      expect(response.status).to eq 404
    end
  end

  context 'GET /api/v1/profiles' do
    it 'with sucess' do
      profile1 = create(:profile)
      profile2 = create(:profile)

      get api_v1_profiles_path, as: :json

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(subject.length).to eq 2
      expect(subject.first['name']).to eq(profile1.name)
      expect(subject.last['name']).to eq(profile2.name)
    end

    it "return empty - there aren't profiles" do
      get api_v1_profiles_path, as: :json

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(subject).to eq []
    end

    it 'without sucess - internal error' do
      allow(Profile).to receive(:all).and_raise(ActiveRecord::QueryCanceled)

      get api_v1_profiles_path, as: :json

      expect(response).to have_http_status(500)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  context 'POST /api/v1/profiles/1' do
    it 'with sucess' do
      post api_v1_profiles_path, params: profile_valid_attributes, as: :json

      expect(response).to have_http_status(201)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(subject['name']).to include(profile_valid_attributes[:name])
      expect(subject['social_name']).to include(profile_valid_attributes[:social_name])
      expect(subject['birthdate']).to include(profile_valid_attributes[:birthdate].to_s[0..9])
      expect(subject['description']).to include(profile_valid_attributes[:description])
      expect(subject['educacional_background']).to include(profile_valid_attributes[:educacional_background])
      expect(subject['experience']).to include(profile_valid_attributes[:experience])
      expect(subject['city']).to include(profile_valid_attributes[:city])
      expect(subject['country_id']).to eq(country.id)
      expect(subject['user_id']).to eq(user.id)
    end

    it 'without sucess - imcomplete parameters' do
      profile_params = { profile: { name: 'Profile Tester', social_name: '',
                                    birthdate: '', description: '', educacional_background: '',
                                    experience: '', city: '', country_id: '', user_id: '' } }
      post api_v1_profiles_path, params: profile_params

      expect(response).to have_http_status(412)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(response.body).not_to include('Nome não pode ficar em branco')
      expect(response.body).to include('Data de Nascimento não pode ficar em branco')
      expect(response.body).to include('Descrição não pode ficar em branco')
      expect(response.body).to include('País é obrigatório')
      expect(response.body).to include('Experiência não pode ficar em branco')
      expect(response.body).to include('Cidade não pode ficar em branco')
      expect(response.body).to include('País não pode ficar em branco')
      expect(response.body).to include('Usuário não pode ficar em branco')
    end

    it 'without sucess - internal error' do
      allow(Profile).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)
      post api_v1_profiles_path, params: profile_valid_attributes, as: :json

      expect(response).to have_http_status(500)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  context 'PUT /api/v1/profiles/1' do
    let(:profile) { create(:profile) }

    it 'with sucess' do
      put api_v1_profile_path(profile.id), params: profile_valid_attributes, as: :json

      expect(response).to have_http_status(200)
      expect(response.body).to include(profile_valid_attributes[:name])
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'without sucess - imcomplete parameters' do
      profile_params = { profile: { name: 'Profile Tester', social_name: '',
                                    birthdate: '', description: '', educacional_background: '',
                                    experience: '', city: '', country_id: '', user_id: '' } }
      put api_v1_profile_path(profile.id), params: profile_params

      expect(response).to have_http_status(412)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(response.body).not_to include('Nome não pode ficar em branco')
      expect(response.body).to include('Data de Nascimento não pode ficar em branco')
      expect(response.body).to include('Descrição não pode ficar em branco')
      expect(response.body).to include('País é obrigatório')
      expect(response.body).to include('Experiência não pode ficar em branco')
      expect(response.body).to include('Cidade não pode ficar em branco')
      expect(response.body).to include('País não pode ficar em branco')
      expect(response.body).to include('Usuário não pode ficar em branco')
    end
  end
end
