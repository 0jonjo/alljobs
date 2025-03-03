# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Job API - Stars', type: :request do
  let(:headhunter) { create(:headhunter) }
  let(:user) { create(:user) }
  let(:job) { create(:job) }
  let(:apply) { create(:apply, job_id: job.id, user_id: user.id) }
  let(:star) { create(:star, apply_id: apply.id, headhunter_id: headhunter.id) }

  before do
    allow_any_instance_of(Api::V1::JobsController).to receive(:authenticate_with_token).and_return(true)
    allow_any_instance_of(Api::V1::JobsController).to receive(:current_headhunter_id).and_return(headhunter.id)
    star
  end

  context 'GET /api/v1/jobs/1/stars' do
    context 'with success' do
      before do
        allow_any_instance_of(Job).to receive(:stars).and_return([star])
      end

      it 'and correct status' do
        get stars_api_v1_job_path(job.id)

        expect(response.status).to eq 200
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'and correct response' do
        get stars_api_v1_job_path(job.id)

        expect(json_response.first['id']).to eq(star.id)
        expect(json_response.first['headhunter_id']).to eq(headhunter.id)
        expect(json_response.first['apply_id']).to eq(apply.id)
      end
    end

    context 'without success' do
      it 'and there no star' do
        star.destroy

        get stars_api_v1_job_path(job.id)

        expect(json_response).to eq []
      end

      it "and fail because can't find the job" do
        get stars_api_v1_job_path(99_999_999)
        expect(response.status).to eq 404
      end
    end
  end
end
