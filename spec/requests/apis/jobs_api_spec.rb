# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Job API', type: :request do
  subject { JSON.parse(response.body) }

  let(:valid_headers) do
    { Authorization: '0123456789' }
  end

  let(:invalid_headers) do
    { Authorization: '' }
  end
  let(:country) { create(:country) }
  let(:company) { create(:company) }
  let(:job_attributes_valid) do
    { job: { title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet',
             skills: 'Nam mattis, felis ut adipiscing.', salary: '99', company_id: company.id.to_s,
             level: :junior, country_id: country.id.to_s, city: 'Remote Job',
             date: 1.month.from_now } }
  end
  let(:job_attributes_invalid) do
    { job: { title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet',
             skills: '', salary: '', company_id: '',
             level: '', country_id: '', city: '',
             date: '' } }
  end

  context 'GET /api/v1/jobs/1' do
    it 'with sucess' do
      job = create(:job)

      get api_v1_job_path(job.id), headers: valid_headers, as: :json

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(subject['title']).to include(job.title)
      expect(subject['description']).to include(job.description)
      expect(subject.keys).not_to include('created_at')
      expect(subject.keys).not_to include('updated_at')
    end

    it "and fail because can't find the job" do
      get api_v1_job_path(99_999_999), headers: valid_headers, as: :json
      expect(response.status).to eq 404
    end
  end

  context 'GET /api/v1/jobs' do
    let!(:job1) { create(:job, title: 'Job Opening Test 123') }
    let!(:job2) { create(:job, title: 'Job Opening Test 456') }

    it 'with sucess' do
      get api_v1_jobs_path, headers: valid_headers, as: :json

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(subject.length).to eq 2
      expect(subject.first['title']).to eq(job1.title)
      expect(subject.last['title']).to eq(job2.title)
    end

    it 'with sucess - using search' do
      get '/api/v1/jobs?title=123', headers: valid_headers, as: :json

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(subject.length).to eq 1
      expect(subject.first['title']).to eq(job1.title)
    end
  end

  context 'GET /api/v1/jobs' do
    it "return empty - there aren't jobs" do
      get api_v1_jobs_path, headers: valid_headers, as: :json

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(subject).to eq []
    end

    it 'without sucess - internal error' do
      allow(Job).to receive(:all).and_raise(ActiveRecord::QueryCanceled)

      get api_v1_jobs_path, headers: valid_headers, as: :json

      expect(response).to have_http_status(500)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  context 'POST /api/v1/jobs/1' do
    it 'with sucess' do
      post api_v1_jobs_path, params: job_attributes_valid, headers: valid_headers, as: :json

      expect(response).to have_http_status(201)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(subject['title']).to include('Job Opening Test 123')
      expect(subject['description']).to include('Lorem ipsum dolor sit amet')
      expect(subject['skills']).to include('Nam mattis, felis ut adipiscing.')
      expect(subject['salary']).to eq('99.0')
      expect(subject['company_id']).to eq(company.id)
      expect(subject['level']).to include('junior')
      expect(subject['country_id']).to eq(country.id)
      expect(subject['city']).to include('Remote Job')
    end

    it 'without sucess - imcomplete parameters' do
      post api_v1_jobs_path, params: job_attributes_invalid, headers: valid_headers, as: :json

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

    it 'without sucess - internal error' do
      allow(Job).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)

      post api_v1_jobs_path, params: job_attributes_valid, headers: valid_headers, as: :json

      expect(response).to have_http_status(500)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  context 'PUT /api/v1/jobs/1' do
    let(:job) { create(:job, title: 'Job Opening Test 456') }

    it 'with sucess' do
      put api_v1_job_path(job.id), params: job_attributes_valid, headers: valid_headers, as: :json

      expect(response).to have_http_status(200)
      expect(response.body).to include('Job Opening Test 123')
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'without sucess - imcomplete parameters' do
      put api_v1_job_path(job.id), params: job_attributes_invalid, headers: valid_headers, as: :json

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
    let(:job) { create(:job, title: 'Job Opening Test 456') }

    it 'with sucess' do
      patch api_v1_job_path(job.id), params: job_attributes_valid, headers: valid_headers, as: :json

      expect(response).to have_http_status(200)
      expect(response.body).to include('Job Opening Test 123')
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'without sucess - imcomplete parameters' do
      patch api_v1_job_path(job.id), params: job_attributes_invalid, headers: valid_headers, as: :json

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

    it 'with sucess' do
      delete api_v1_job_path(job.id), headers: valid_headers, as: :json

      expect(response.status).to eq 204
    end

    it 'without sucess - no job' do
      delete api_v1_job_path(99_999_999), headers: valid_headers, as: :json

      expect(response.status).to eq 404
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end
end
