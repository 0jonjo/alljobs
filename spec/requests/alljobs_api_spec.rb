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
    end
  end  
end    
