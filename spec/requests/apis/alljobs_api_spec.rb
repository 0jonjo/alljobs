require 'rails_helper'

describe "Alljobs API" do
  context "GET /api/v1/jobs/1" do
    it "with sucess" do
      job = Job.create!(title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet', 
                      skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                      company: 'Acme', level: 'Junior', place: 'Remote Job',
                      date: 1.month.from_now)
      get "/api/v1/jobs/#{job.id}"
      
      expect(response.status).to eq 200
      expect(response.content_type).to eq("application/json; charset=utf-8") 

      json_response = JSON.parse(response.body)

      expect(json_response["title"]).to include("Job Opening Test 123")
      expect(json_response["description"]).to include("Lorem ipsum dolor sit amet")
      expect(json_response.keys).not_to include("created_at")
      expect(json_response.keys).not_to include("updated_at") 
    end

    it "and fail because can't find the job" do
      get "/api/v1/jobs/99999999"
      
      expect(response.status).to eq 404
    end
  end  

  context "GET /api/v1/jobs" do
    it "with sucess" do
      job1 = Job.create!(title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: 1.month.from_now)
      job2 = Job.create!(title: 'Job Opening Test 456', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: 1.month.from_now)
      
      get "/api/v1/jobs/"

      expect(response.status).to eq 200
      expect(response.content_type).to eq("application/json; charset=utf-8") 

      json_response = JSON.parse(response.body)
    
      expect(json_response.length).to eq 2
      expect(json_response.first["title"]).to eq('Job Opening Test 123')
      expect(json_response.last["title"]).to eq('Job Opening Test 456')
    end  

    it "return empty - there aren't jobs" do   
      get "/api/v1/jobs/"

      expect(response.status).to eq 200
      expect(response.content_type).to eq("application/json; charset=utf-8") 

      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end  

    it "without sucess - internal error" do
      allow(Job).to receive(:all).and_raise(ActiveRecord::QueryCanceled)  

      get "/api/v1/jobs/"
      
      expect(response).to have_http_status(500)
      expect(response.content_type).to eq("application/json; charset=utf-8")
    end  
  end 

  context "POST /api/v1/jobs/1" do
    it "with sucess" do
      job_params = { job: { title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet', 
              skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
              company: 'Acme', level: 'Junior', place: 'Remote Job',
              date: 1.month.from_now } }
      post "/api/v1/jobs/", params: job_params
      
      expect(response).to have_http_status(201)
      expect(response.content_type).to eq("application/json; charset=utf-8") 
      
      json_response = JSON.parse(response.body)

      expect(json_response["title"]).to include("Job Opening Test 123")
      expect(json_response["description"]).to include("Lorem ipsum dolor sit amet")
      expect(json_response["skills"]).to include('Nam mattis, felis ut adipiscing.')
      expect(json_response["salary"]).to include("99")
      expect(json_response["company"]).to include("Acme")
      expect(json_response["level"]).to include("Junior")
      expect(json_response["place"]).to include("Remote Job")
    end

    it "without sucess - imcomplete parameters" do
      job_params = { job: { title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet', 
              skills: '', salary: '', company: '', level: '', place: '',
              date: '' } }
      post "/api/v1/jobs/", params: job_params
      
      expect(response).to have_http_status(412)
      expect(response.content_type).to eq("application/json; charset=utf-8") 
    
      expect(response.body).not_to include("Title can't be blank")
      expect(response.body).to include("Skills can't be blank")
      expect(response.body).to include("Salary can't be blank")
      expect(response.body).to include("Company can't be blank")
      expect(response.body).to include("Level can't be blank")
      expect(response.body).to include("Date can't be blank")
      expect(response.body).to include("Salary is not a number")
    end

    it "without sucess - internal error" do
      allow(Job).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)  

      job_params = { job: { title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet', 
                            skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                            company: 'Acme', level: 'Junior', place: 'Remote Job',
                            date: 1.month.from_now } }

      post "/api/v1/jobs/", params: job_params
      
      expect(response).to have_http_status(500)
      expect(response.content_type).to eq("application/json; charset=utf-8") 
    end
  end
end    
