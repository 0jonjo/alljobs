# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Job API', type: :request do
  let(:headhunter) { create(:headhunter) }
  let(:country) { create(:country) }
  let(:company) { create(:company) }
  let(:job_attributes_valid) { attributes_for(:job, company_id: company.id, country_id: country.id) }
  let(:job_attributes_invalid) do
    { job: { title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet',
             skills: '', salary: '', company_id: '',
             level: '', country_id: '', city: '',
             date: '' } }
  end

  before do
    allow_any_instance_of(Api::V1::JobsController).to receive(:valid_token?).and_return(true)
    allow_any_instance_of(Api::V1::JobsController).to receive(:decode).and_return([{ 'requester_type' => 'Headhunter', 'requester_id' => headhunter.id }])
    allow_any_instance_of(Api::V1::JobsController).to receive(:requester_exists?).and_return(true)
  end

  context 'GET /api/v1/jobs/1' do
    it 'with success' do
      job = create(:job)

      get api_v1_job_path(job.id), headers:, as: :json

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(json_response['title']).to include(job.title)
      expect(json_response['description']).to include(job.description)
    end

    it "and fail because can't find the job" do
      get api_v1_job_path(99_999_999), headers:, as: :json
      expect(response.status).to eq 404
    end
  end

  context 'GET /api/v1/jobs' do
    let!(:job1) { create(:job, title: 'Job Opening Test 123') }
    let!(:job2) { create(:job, title: 'Job Opening Test 456') }

    it 'with success' do
      get api_v1_jobs_path, headers:, as: :json

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(json_response.length).to eq 2
      expect(json_response.first['title']).to eq(job1.title)
      expect(json_response.last['title']).to eq(job2.title)
    end

    it 'with success - using search' do
      get '/api/v1/jobs?title=123', headers:, as: :json

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(json_response.length).to eq 1
      expect(json_response.first['title']).to eq(job1.title)
    end
  end

  context 'GET /api/v1/jobs' do
    it "return empty - there aren't jobs" do
      get api_v1_jobs_path, headers:, as: :json

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(json_response).to eq []
    end

    it 'without success - internal error' do
      allow(Job).to receive(:all).and_raise(ActiveRecord::QueryCanceled)

      get api_v1_jobs_path, headers:, as: :json

      expect(response).to have_http_status(500)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  context 'POST /api/v1/jobs/1' do
    it 'with success' do
      post api_v1_jobs_path, params: job_attributes_valid, headers:, as: :json

      expect(response).to have_http_status(201)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(json_response['title']).to include(job_attributes_valid[:title])
      expect(json_response['description']).to include(job_attributes_valid[:description])
      expect(json_response['skills']).to include(job_attributes_valid[:skills])
      expect(json_response['salary'].to_f).to eq(job_attributes_valid[:salary])
      expect(json_response['company_id']).to eq(company.id)
      expect(json_response['level']).to include('junior')
      expect(json_response['country_id']).to eq(country.id)
      expect(json_response['city']).to include(job_attributes_valid[:city])
    end

    it 'without success - incomplete parameters' do
      post api_v1_jobs_path, params: job_attributes_invalid, headers:, as: :json

      expect(response).to have_http_status(412)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(response.body).not_to include('Título não pode ficar em branco')
      expect(response.body).to include('Habilidades não pode ficar em branco')
      expect(response.body).to include('Salário não pode ficar em branco')
      expect(response.body).to include('País é obrigatório')
      expect(response.body).to include('Nível não pode ficar em branco')
      expect(response.body).to include('Data não pode ficar em branco')
      expect(response.body).to include('Salário não pode ficar em branco')
    end

    it 'without success - internal error' do
      allow(Job).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)

      post api_v1_jobs_path, params: job_attributes_valid, headers:, as: :json

      expect(response).to have_http_status(500)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  context 'PUT /api/v1/jobs/1' do
    let(:job) { create(:job) }

    it 'with success' do
      put api_v1_job_path(job.id), params: job_attributes_valid, headers:, as: :json

      expect(response).to have_http_status(200)
      expect(json_response['title']).to include(job_attributes_valid[:title])
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'without success - incomplete parameters' do
      put api_v1_job_path(job.id), params: job_attributes_invalid, headers:, as: :json

      expect(response).to have_http_status(412)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(response.body).not_to include('Título não pode ficar em branco')
      expect(response.body).to include('Habilidades não pode ficar em branco')
      expect(response.body).to include('Salário não pode ficar em branco')
      expect(response.body).to include('Nível não pode ficar em branco')
      expect(response.body).to include('Data não pode ficar em branco')
      expect(response.body).to include('Salário não pode ficar em branco')
    end
  end

  context 'PATCH /api/v1/jobs/1' do
    let(:job) { create(:job) }

    it 'with success' do
      patch api_v1_job_path(job.id), params: job_attributes_valid, headers:, as: :json

      expect(response).to have_http_status(200)
      expect(json_response['title']).to include(job_attributes_valid[:title])
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'without success - incomplete parameters' do
      patch api_v1_job_path(job.id), params: job_attributes_invalid, headers:, as: :json

      expect(response).to have_http_status(412)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(response.body).not_to include('Título não pode ficar em branco')
      expect(response.body).to include('Habilidades não pode ficar em branco')
      expect(response.body).to include('Salário não pode ficar em branco')
      expect(response.body).to include('Nível não pode ficar em branco')
      expect(response.body).to include('Data não pode ficar em branco')
      expect(response.body).to include('Salário não pode ficar em branco')
    end
  end

  context 'DELETE /api/v1/jobs/1' do
    let(:job) { create(:job) }

    it 'with success' do
      delete api_v1_job_path(job.id), headers:, as: :json

      expect(response.status).to eq 204
    end

    it 'without success - no job' do
      delete api_v1_job_path(99_999_999), headers:, as: :json

      expect(response.status).to eq 404
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end
end
