# frozen_string_literal: true

require 'rails_helper'

describe 'Profile API' do
  let!(:country) { create(:country) }
  let!(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:headhunter) { create(:headhunter) }
  let(:profile) { create(:profile) }
  let(:profile_user) { create(:profile, user_id: user.id) }
  let(:profile_valid_attributes) { attributes_for(:profile, country_id: country.id, user_id: user.id) }

  context 'GET /api/v1/profiles/1' do
    before do
      allow_any_instance_of(Api::V1::ProfilesController).to receive(:valid_token?).and_return(true)
      allow_any_instance_of(Api::V1::ProfilesController).to receive(:decode).and_return([{ 'requester_type' => 'User', 'requester_id' => user.id }])
      allow_any_instance_of(Api::V1::ProfilesController).to receive(:requester_exists?).and_return(true)
    end

    context 'for owner' do
      it 'with success' do
        get api_v1_profile_path(profile_user.id), as: :json

        expect(response.status).to eq 200
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response['name']).to include(profile_user.name)
        expect(json_response['description']).to include(profile_user.description)
        expect(json_response.keys).not_to include('created_at')
        expect(json_response.keys).not_to include('updated_at')
      end

      it "and fail because can't find the profile" do
        get api_v1_profile_path(99_999_999), as: :json
        expect(response.status).to eq 404
      end
    end

    context 'for admin' do
      before do
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:valid_token?).and_return(true)
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:decode).and_return([{ 'requester_type' => 'Headhunter', 'requester_id' => headhunter.id }])
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:requester_exists?).and_return(true)
      end

      it 'with success' do
        get api_v1_profile_path(profile.id), as: :json

        expect(response.status).to eq 200
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response['name']).to include(profile.name)
      end
    end

    context 'for not owner' do
      it 'without success - unauthorized' do
        get api_v1_profile_path(profile.id), as: :json

        expect(response).to have_http_status(401)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  context 'GET /api/v1/profiles' do
    context 'for admin' do
      before do
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:valid_token?).and_return(true)
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:decode).and_return([{ 'requester_type' => 'Headhunter', 'requester_id' => headhunter.id }])
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:requester_exists?).and_return(true)
      end

      it 'with success' do
        create_list(:profile, 2)

        get api_v1_profiles_path, as: :json

        expect(response.status).to eq 200
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response.length).to eq 2
      end
    end

    context 'for user' do
      before do
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:valid_token?).and_return(true)
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:decode).and_return([{ 'requester_type' => 'User', 'requester_id' => another_user.id }])
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:requester_exists?).and_return(true)
      end

      it 'without success - unauthorized' do
        get api_v1_profiles_path, as: :json

        expect(response).to have_http_status(401)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  context 'POST /api/v1/profiles/1' do
    context 'for owner' do
      before do
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:valid_token?).and_return(true)
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:decode).and_return([{ 'requester_type' => 'User', 'requester_id' => user.id }])
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:requester_exists?).and_return(true)
        allow_any_instance_of(Profile).to receive(:send_mail_success).and_return(true)
      end

      it 'with success' do
        post api_v1_profiles_path, params: profile_valid_attributes, as: :json

        expect(response).to have_http_status(201)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response['name']).to include(profile_valid_attributes[:name])
        expect(json_response['social_name']).to include(profile_valid_attributes[:social_name])
        expect(json_response['birthdate']).to include(profile_valid_attributes[:birthdate].to_s[0..9])
        expect(json_response['description']).to include(profile_valid_attributes[:description])
        expect(json_response['educacional_background']).to include(profile_valid_attributes[:educacional_background])
        expect(json_response['experience']).to include(profile_valid_attributes[:experience])
        expect(json_response['city']).to include(profile_valid_attributes[:city])
        expect(json_response['country_id']).to eq(country.id)
        expect(json_response['user_id']).to eq(user.id)
      end

      it 'without success - incomplete parameters' do
        profile_params = attributes_for(:profile, country_id: nil, user_id: user.id)
        post api_v1_profiles_path, params: profile_params, as: :json

        expect(response).to have_http_status(412)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).not_to include('Nome não pode ficar em branco')
        expect(response.body).to include('País é obrigatório')
      end
    end

    context 'for not owner' do
      before do
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:valid_token?).and_return(true)
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:decode).and_return([{ 'requester_type' => 'User', 'requester_id' => another_user.id }])
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:requester_exists?).and_return(true)
      end

      it 'without success - unauthorized' do
        post api_v1_profiles_path, params: profile_valid_attributes, as: :json

        expect(response).to have_http_status(401)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  context 'PUT /api/v1/profiles/1' do
    context 'for owner' do
      before do
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:valid_token?).and_return(true)
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:decode).and_return([{ 'requester_type' => 'User', 'requester_id' => user.id }])
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:requester_exists?).and_return(true)
      end

      it 'with success' do
        put api_v1_profile_path(profile_user.id), params: profile_valid_attributes, as: :json

        expect(response).to have_http_status(200)
        expect(response.body).to include(profile_valid_attributes[:name])
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'without success - incomplete parameters' do
        profile_params = { profile: { name: 'Profile Tester', social_name: '',
                                      birthdate: '', description: '', educacional_background: '',
                                      experience: '', city: '', country_id: '', user_id: '' } }
        put api_v1_profile_path(profile_user.id), params: profile_params

        expect(response).to have_http_status(412)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        expect(response.body).not_to include('Nome não pode ficar em branco')
        expect(response.body).to include('Data de Nascimento não pode ficar em branco')
        expect(response.body).to include('Descrição não pode ficar em branco')
        expect(response.body).to include('País é obrigatório')
        expect(response.body).to include('Experiência não pode ficar em branco')
        expect(response.body).to include('Cidade não pode ficar em branco')
      end
    end

    context 'for not owner' do
      before do
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:valid_token?).and_return(true)
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:decode).and_return([{ 'requester_type' => 'User', 'requester_id' => another_user.id }])
        allow_any_instance_of(Api::V1::ProfilesController).to receive(:requester_exists?).and_return(true)
      end

      it 'without success - unauthorized' do
        put api_v1_profile_path(profile.id), params: profile_valid_attributes, as: :json

        expect(response).to have_http_status(401)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end
end
