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
  end 
end    
