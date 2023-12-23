# frozen_string_literal: true

require 'rails_helper'

describe 'Profile API' do
  let(:country) { create(:country) }
  let(:user) { create(:user) }

  context 'GET /api/v1/profiles/1' do
    it 'with sucess' do
      profile = create(:profile)

      get "/api/v1/profiles/#{profile.id}"

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')

      json_response = JSON.parse(response.body)

      expect(json_response['name']).to include(profile.name)
      expect(json_response['description']).to include(profile.description)
      expect(json_response.keys).not_to include('created_at')
      expect(json_response.keys).not_to include('updated_at')
    end

    it "and fail because can't find the profile" do
      get '/api/v1/profiles/99999999'
      expect(response.status).to eq 404
    end
  end

  context 'GET /api/v1/profiles' do
    it 'with sucess' do
      profile1 = create(:profile)
      profile2 = create(:profile)

      get '/api/v1/profiles/'

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')

      json_response = JSON.parse(response.body)

      expect(json_response.length).to eq 2
      expect(json_response.first['name']).to eq(profile1.name)
      expect(json_response.last['name']).to eq(profile2.name)
    end

    it "return empty - there aren't profiles" do
      get '/api/v1/profiles/'

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')

      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end

    it 'without sucess - internal error' do
      allow(Profile).to receive(:all).and_raise(ActiveRecord::QueryCanceled)

      get '/api/v1/profiles/'

      expect(response).to have_http_status(500)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  context 'POST /api/v1/profiles/1' do
    it 'with sucess' do
      profile_params = { profile: { name: 'Profile Tester', social_name: 'Social Name Test',
                                    birthdate: '1970-01-01', description: 'Lorem ipsum dolor sit amet',
                                    educacional_background: 'Nam mattis, felis ut adipiscing.',
                                    experience: 'Test Experience', city: 'Test City', country_id: country.id.to_s,
                                    user_id: user.id.to_s } }
      post '/api/v1/profiles/', params: profile_params

      expect(response).to have_http_status(201)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      json_response = JSON.parse(response.body)

      expect(json_response['name']).to include('Profile Tester')
      expect(json_response['social_name']).to include('Social Name Test')
      expect(json_response['birthdate']).to include('1970-01-01')
      expect(json_response['description']).to include('Lorem ipsum dolor sit amet')
      expect(json_response['educacional_background']).to include('Nam mattis, felis ut adipiscing.')
      expect(json_response['experience']).to include('Test Experience')
      expect(json_response['city']).to include('Test City')
      expect(json_response['country_id']).to eq(country.id)
      expect(json_response['user_id']).to eq(user.id)
    end

    it 'without sucess - imcomplete parameters' do
      profile_params = { profile: { name: 'Profile Tester', social_name: '',
                                    birthdate: '', description: '', educacional_background: '',
                                    experience: '', city: '', country_id: '', user_id: '' } }
      post '/api/v1/profiles/', params: profile_params

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

      profile_params = { profile: { name: 'Profile Tester', social_name: 'Social Name Test',
                                    birthdate: '1970-01-01', description: 'Lorem ipsum dolor sit amet',
                                    educacional_background: 'Nam mattis, felis ut adipiscing.',
                                    experience: 'Test Experience', city: 'Test City', country_id: country.id.to_s,
                                    user_id: user.id.to_s } }

      post '/api/v1/profiles/', params: profile_params

      expect(response).to have_http_status(500)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  context 'PUT /api/v1/profiles/1' do
    let(:profile) { create(:profile) }

    it 'with sucess' do
      profile_params = { profile: { name: 'Profile Tester', social_name: 'Social Name Test',
                                    birthdate: '1970-01-01', description: 'Lorem ipsum dolor sit amet',
                                    educacional_background: 'Nam mattis, felis ut adipiscing.',
                                    experience: 'Test Experience', city: 'Test City', country_id: country.id.to_s,
                                    user_id: user.id.to_s } }
      put "/api/v1/profiles/#{profile.id}", params: profile_params

      expect(response).to have_http_status(200)
      expect(response.body).to include('Profile Tester')
      expect(response.content_type).to eq('application/json; charset=utf-8')

      JSON.parse(response.body)
    end

    it 'without sucess - imcomplete parameters' do
      profile_params = { profile: { name: 'Profile Tester', social_name: '',
                                    birthdate: '', description: '', educacional_background: '',
                                    experience: '', city: '', country_id: '', user_id: '' } }
      put "/api/v1/profiles/#{profile.id}", params: profile_params

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
