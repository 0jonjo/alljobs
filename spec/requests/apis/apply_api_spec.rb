# frozen_string_literal: true

require 'rails_helper'

describe 'Apply API' do
  subject { JSON.parse(response.body) }

  let(:job) { create(:job) }

  context 'GET /api/v1/jobs/1/applies/1' do
    it 'with sucess' do
      apply = create(:apply, job_id: job.id, feedback_headhunter: 'test')

      get "/api/v1/jobs/#{job.id}/applies/#{apply.id}"

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(subject['user_id']).to eq(apply.user_id)
      expect(subject['job_id']).to eq(job.id)
      expect(subject['feedback_headhunter']).to include(apply.feedback_headhunter)
      expect(subject.keys).not_to include('created_at')
      expect(subject.keys).not_to include('updated_at')
    end

    it "and fail because can't find the job" do
      get "/api/v1/jobs/#{job.id}/applies/99999999"
      expect(response.status).to eq 404
    end
  end

  context 'GET /api/v1/jobs/1/applies/' do
    it 'with sucess' do
      apply1 = create(:apply, job_id: job.id)
      apply2 = create(:apply, job_id: job.id)

      get "/api/v1/jobs/#{job.id}/applies/"

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(subject.length).to eq 2
      expect(subject.first['user_id']).to eq(apply1.user_id)
      expect(subject.last['user_id']).to eq(apply2.user_id)
    end

    it "return empty - there aren't applies" do
      get "/api/v1/jobs/#{job.id}/applies"

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(subject).to eq []
    end

    it 'without sucess - internal error' do
      allow(Apply).to receive(:all).and_raise(ActiveRecord::QueryCanceled)

      get "/api/v1/jobs/#{job.id}/applies"

      expect(response).to have_http_status(500)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  context 'POST /api/v1/jobs/1/applies' do
    let(:user) { create(:user) }

    it 'with sucess' do
      apply_params = { apply: { job_id: job.id.to_s, user_id: user.id.to_s,
                                feedback_headhunter: 'test' } }
      post "/api/v1/jobs/#{job.id}/applies", params: apply_params

      expect(response).to have_http_status(201)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(subject['user_id']).to eq(user.id)
      expect(subject['job_id']).to eq(job.id)
      expect(subject['feedback_headhunter']).to include('test')
    end

    it 'without sucess - imcomplete parameters' do
      apply_params = { apply: { job_id: job.id.to_s, user_id: '',
                                feedback_headhunter: 'test' } }
      post "/api/v1/jobs/#{job.id}/applies", params: apply_params

      expect(response).to have_http_status(412)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(response.body).not_to include('Job não pode ficar em branco')
      expect(response.body).to include('User é obrigatório')
    end

    it 'without sucess - internal error' do
      allow(Apply).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)
      apply_params = { apply: { job_id: job.id.to_s, user_id: user.id.to_s,
                                feedback_headhunter: 'test' } }
      post "/api/v1/jobs/#{job.id}/applies", params: apply_params

      expect(response).to have_http_status(500)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  context 'DELETE /api/v1/jobs/1' do
    let(:apply) { create(:apply) }

    it 'with sucess' do
      delete "/api/v1/jobs/#{job.id}/applies/#{apply.id}"

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'without sucess - no job' do
      delete "/api/v1/jobs/#{job.id}/applies/999999"

      expect(response.status).to eq 404
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end
end
