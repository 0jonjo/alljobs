# frozen_string_literal: true

require 'rails_helper'

describe 'Stars API' do
  let(:apply) { create(:apply) }
  let(:headhunter) { create(:headhunter) }

  before do
    headhunter
    allow_any_instance_of(Api::V1::StarsController).to receive(:authenticate_with_token).and_return(true)
    allow_any_instance_of(Api::V1::StarsController).to receive(:current_headhunter_id).and_return(headhunter.id)
  end

  context 'POST /api/v1/job/apply/stars' do
    context 'when with success' do
      it 'create and return the star' do
        post api_v1_job_apply_stars_path(apply.job_id, apply.id), as: :json

        expect(response.status).to eq 201
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response['headhunter_id']).to eq headhunter.id
        expect(json_response['apply_id']).to eq apply.id
      end
    end

    context 'when without success' do
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

  context 'DELETE /api/v1/job/apply/stars/:id' do
    let(:star) { create(:star, headhunter:, apply:) }
    let(:star_another_headhunter) { create(:star, apply:) }

    context 'when with success' do
      it 'delete the star' do
        delete api_v1_job_apply_star_path(apply.job_id, apply.id, star.id)

        expect(response).to have_http_status(204)
      end
    end

    context 'when without success' do
      it 'return error when star does not exist' do
        delete api_v1_job_apply_star_path(apply.job_id, apply.id, 99_999_999)

        expect(response).to have_http_status(404)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'return error when headhunter is not the owner' do
        delete api_v1_job_apply_star_path(apply.job_id, apply.id, star_another_headhunter.id)

        expect(response).to have_http_status(401)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response['error']).to eq(I18n.t('auth.unauthorized'))
      end

      it 'return internal error' do
        allow(Star).to receive(:find).and_raise(ActiveRecord::QueryCanceled)

        delete api_v1_job_apply_star_path(apply.job_id, apply.id, star.id)

        expect(response).to have_http_status(500)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end
end
