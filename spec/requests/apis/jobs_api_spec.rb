# frozen_string_literal: true

require 'rails_helper'

describe 'Job API' do
  context 'GET /api/v1/jobs/1' do
    it 'with sucess' do
      job = create(:job)

      get "/api/v1/jobs/#{job.id}"

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')

      json_response = JSON.parse(response.body)

      expect(json_response['title']).to include(job.title)
      expect(json_response['description']).to include(job.description)
      expect(json_response.keys).not_to include('created_at')
      expect(json_response.keys).not_to include('updated_at')
    end

    it "and fail because can't find the job" do
      get '/api/v1/jobs/99999999'
      expect(response.status).to eq 404
    end
  end

  context 'GET /api/v1/jobs' do
    it 'with sucess' do
      job1 = create(:job)
      job2 = create(:job)

      get '/api/v1/jobs/'

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')

      json_response = JSON.parse(response.body)

      expect(json_response.length).to eq 2
      expect(json_response.first['title']).to eq(job1.title)
      expect(json_response.last['title']).to eq(job2.title)
    end

    it "return empty - there aren't jobs" do
      get '/api/v1/jobs/'

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')

      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end

    it 'without sucess - internal error' do
      allow(Job).to receive(:all).and_raise(ActiveRecord::QueryCanceled)

      get '/api/v1/jobs/'

      expect(response).to have_http_status(500)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  context 'POST /api/v1/jobs/1' do
    let(:country) { create(:country) }
    let(:company) { create(:company) }

    it 'with sucess' do
      job_params = { job: { title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet',
                            skills: 'Nam mattis, felis ut adipiscing.', salary: '99', company_id: company.id.to_s,
                            level: 'Junior', country_id: country.id.to_s, city: 'Remote Job',
                            date: 1.month.from_now } }
      post '/api/v1/jobs/', params: job_params

      expect(response).to have_http_status(201)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      json_response = JSON.parse(response.body)

      expect(json_response['title']).to include('Job Opening Test 123')
      expect(json_response['description']).to include('Lorem ipsum dolor sit amet')
      expect(json_response['skills']).to include('Nam mattis, felis ut adipiscing.')
      expect(json_response['salary']).to eq('99.0')
      expect(json_response['company_id']).to eq(company.id)
      expect(json_response['level']).to include('Junior')
      expect(json_response['country_id']).to eq(country.id)
      expect(json_response['city']).to include('Remote Job')
    end

    it 'without sucess - imcomplete parameters' do
      job_params = { job: { title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet',
                            skills: '', salary: '', company: '', level: '', place: '',
                            date: '' } }
      post '/api/v1/jobs/', params: job_params

      expect(response).to have_http_status(412)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(response.body).not_to include('Título não pode ficar em branco')
      expect(response.body).to include('Habilidades não pode ficar em branco')
      expect(response.body).to include('Salário não pode ficar em branco')
      expect(response.body).to include('Country é obrigatório')
      expect(response.body).to include('Nível não pode ficar em branco')
      expect(response.body).to include('Data não pode ficar em branco')
      expect(response.body).to include('Salário não pode ficar em branco')
    end

    it 'without sucess - internal error' do
      allow(Job).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)

      job_params = { job: { title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet',
                            skills: 'Nam mattis, felis ut adipiscing.', salary: '99', company_id: company.id.to_s,
                            level: 'Junior', country_id: country.id.to_s, city: 'Remote Job',
                            date: 1.month.from_now } }

      post '/api/v1/jobs/', params: job_params

      expect(response).to have_http_status(500)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  context 'PUT /api/v1/jobs/1' do
    let(:job) { create(:job) }

    it 'with sucess' do
      job_params = { job: { title: 'Test title', description: 'Test description',
                            skills: 'Test skills', salary: '66', level: 'Test level', city: 'Test place',
                            date: 1.month.from_now } }
      put "/api/v1/jobs/#{job.id}", params: job_params

      expect(response).to have_http_status(200)
      expect(response.body).to include('Test title')
      expect(response.content_type).to eq('application/json; charset=utf-8')

      JSON.parse(response.body)
    end

    it 'without sucess - imcomplete parameters' do
      job_params = { job: { title: 'Test title', description: 'Test description',
                            skills: '', salary: '', company: '', level: '', city: '',
                            date: '' } }
      put "/api/v1/jobs/#{job.id}", params: job_params

      expect(response).to have_http_status(412)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      expect(response.body).not_to include('Título não pode ficar em branco')
      expect(response.body).to include('Habilidades não pode ficar em branco')
      expect(response.body).to include('Salário não pode ficar em branco')
      expect(response.body).to include('Nível não pode ficar em branco')
      expect(response.body).to include('Data não pode ficar em branco')
      expect(response.body).to include('Salário não pode ficar em branco')
    end

    xit 'without sucess - internal error' do
      allow(Job).to receive(:update).and_raise(ActiveRecord::ActiveRecordError)

      job_params = { job: { title: 'Test title', description: 'Test description',
                            skills: 'Test skills', salary: '66',
                            company: 'Test company', level: 'Test level', place: 'Test place',
                            date: 1.month.from_now } }
      put "/api/v1/jobs/#{job.id}", params: job_params

      expect(response).to have_http_status(500)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  context 'DELETE /api/v1/jobs/1' do
    let(:job) { create(:job) }

    it 'with sucess' do
      delete "/api/v1/jobs/#{job.id}"

      expect(response.status).to eq 200
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'without sucess - no job' do
      delete '/api/v1/jobs/999999'

      expect(response.status).to eq 404
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    xit 'without sucess - internal error' do
      allow(Job).to receive(:destroy).and_raise(ActiveRecord::ActiveRecordError)
      delete "/api/v1/jobs/#{job.id}"

      expect(response.status).to eq 500
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end
end
