# frozen_string_literal: true

require 'rails_helper'

describe 'Profile API' do
  let(:apply) { create(:apply) }
  let(:headhunter) { create(:headhunter) }

  before do
    headhunter
    allow_any_instance_of(Api::V1::StarsController).to receive(:authenticate_with_token).and_return(true)
    allow_any_instance_of(Api::V1::StarsController).to receive(:current_headhunter_id).and_return(headhunter.id)
  end

  # Create route to headhunter get all stars of applies of a specific Job

  context 'POST /api/v1/job/apply/stars' do
    context 'when with sucess' do
      it 'create and return the star' do
        post api_v1_job_apply_stars_path(apply.job_id, apply.id), as: :json

        expect(response.status).to eq 201
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response['headhunter_id']).to eq headhunter.id
        expect(json_response['apply_id']).to eq apply.id
      end
    end

    context 'when without sucess' do
      it 'return error when star already exists' do
        create(:star, headhunter:, apply:)

        post api_v1_job_apply_stars_path(apply.job_id, apply.id), as: :json

        expect(response).to have_http_status(412)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response['errors'].first).to eq('Headhunter has already been taken for this application')
      end

      it 'return internal error' do
        allow(Star).to receive(:new).and_raise(ActiveRecord::QueryCanceled)

        post api_v1_job_apply_stars_path(apply.job_id, apply.id), as: :json

        expect(response).to have_http_status(500)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end
end
