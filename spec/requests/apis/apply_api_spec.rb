# frozen_string_literal: true

require 'rails_helper'

describe 'Apply API' do
  let(:headhunter) { create(:headhunter) }
  let(:user) { create(:user) }
  let(:job) { create(:job) }
  let(:apply) { create(:apply, job_id: job.id, feedback_headhunter: 'test') }

  before do
    allow_any_instance_of(Api::V1::AppliesController).to receive(:authenticate_with_token).and_return(true)
    allow_any_instance_of(Api::V1::AppliesController).to receive(:current_headhunter_id).and_return(headhunter.id)
  end

  context 'GET /api/v1/jobs/1/applies/1' do
    context 'when headhunter' do
      it 'with success' do
        get "/api/v1/jobs/#{job.id}/applies/#{apply.id}"

        expect(response.status).to eq 200
        expect(response.content_type).to eq('application/json; charset=utf-8')

        expect(json_response['user_id']).to eq(apply.user_id)
        expect(json_response['job_id']).to eq(job.id)
        expect(json_response['feedback_headhunter']).to include(apply.feedback_headhunter)
        expect(json_response.keys).not_to include('created_at')
        expect(json_response.keys).not_to include('updated_at')
      end

      it "and fail because can't find the job" do
        get "/api/v1/jobs/#{job.id}/applies/99999999"
        expect(response.status).to eq 404
      end
    end

    context 'when owner' do
      before do
        allow_any_instance_of(Api::V1::AppliesController).to receive(:current_user_id).and_return(user.id)
      end

      it 'with success' do
        get "/api/v1/jobs/#{job.id}/applies/#{apply.id}"

        expect(response.status).to eq 200
        expect(response.content_type).to eq('application/json; charset=utf-8')

        expect(json_response['user_id']).to eq(apply.user_id)
        expect(json_response['job_id']).to eq(job.id)
        expect(json_response['feedback_headhunter']).to include(apply.feedback_headhunter)
      end
    end

    context 'when not owner' do
      before do
        allow_any_instance_of(Api::V1::AppliesController).to receive(:current_headhunter_id).and_return(nil)
        allow_any_instance_of(Api::V1::AppliesController).to receive(:current_user_id).and_return(user.id + 99)
      end

      it 'with unauthorized' do
        get "/api/v1/jobs/#{job.id}/applies/#{apply.id}"

        expect(response.status).to eq 401
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  context 'GET /api/v1/jobs/1/applies/' do
    it 'with success' do
      apply1 = create(:apply, job_id: job.id)
      apply2 = create(:apply, job_id: job.id)

      get "/api/v1/jobs/#{job.id}/applies/"

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(json_response.length).to eq 2
      expect(json_response.first['user_id']).to eq(apply1.user_id)
      expect(json_response.last['user_id']).to eq(apply2.user_id)
    end

    it "return empty - there aren't applies" do
      get "/api/v1/jobs/#{job.id}/applies"

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(json_response).to eq []
    end

    it 'without success - internal error' do
      allow(Apply).to receive(:all).and_raise(ActiveRecord::QueryCanceled)

      get "/api/v1/jobs/#{job.id}/applies"

      expect(response).to have_http_status(500)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  context 'POST /api/v1/jobs/1/applies' do
    let(:user) { create(:user) }

    context 'when owner or headhunter' do
      it 'with success' do
        apply_params = { apply: { job_id: job.id.to_s, user_id: user.id.to_s,
                                  feedback_headhunter: 'test' } }
        post "/api/v1/jobs/#{job.id}/applies", params: apply_params

        expect(response).to have_http_status(201)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        expect(json_response['user_id']).to eq(user.id)
        expect(json_response['job_id']).to eq(job.id)
        expect(json_response['feedback_headhunter']).to include('test')
      end

      it 'without success - incomplete parameters' do
        apply_params = { apply: { job_id: job.id.to_s, user_id: '',
                                  feedback_headhunter: 'test' } }
        post "/api/v1/jobs/#{job.id}/applies", params: apply_params

        expect(response).to have_http_status(412)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).not_to include('Job não pode ficar em branco')
        expect(response.body).to include('User é obrigatório')
      end

      it 'without success - internal error' do
        allow(Apply).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)
        apply_params = { apply: { job_id: job.id.to_s, user_id: user.id.to_s,
                                  feedback_headhunter: 'test' } }
        post "/api/v1/jobs/#{job.id}/applies", params: apply_params

        expect(response).to have_http_status(500)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'when do not owner' do
      before do
        allow_any_instance_of(Api::V1::AppliesController).to receive(:current_headhunter_id).and_return(nil)
        allow_any_instance_of(Api::V1::AppliesController).to receive(:current_user_id).and_return(user.id + 99)
      end

      it 'with unauthorized' do
        apply_params = { apply: { job_id: job.id.to_s, user_id: user.id.to_s,
                                  feedback_headhunter: 'test' } }
        post "/api/v1/jobs/#{job.id}/applies", params: apply_params

        expect(response).to have_http_status(401)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  context 'DELETE /api/v1/jobs/1' do
    context 'when headhunter'
    it 'with success' do
      delete "/api/v1/jobs/#{job.id}/applies/#{apply.id}"

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'without success - no job' do
      delete "/api/v1/jobs/#{job.id}/applies/999999"

      expect(response.status).to eq 404
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    context 'when not owner' do
      before do
        allow_any_instance_of(Api::V1::AppliesController).to receive(:current_headhunter_id).and_return(nil)
        allow_any_instance_of(Api::V1::AppliesController).to receive(:current_user_id).and_return(user.id + 99)
      end

      it 'with unauthorized' do
        delete "/api/v1/jobs/#{job.id}/applies/#{apply.id}"

        expect(response.status).to eq 401
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end
end
