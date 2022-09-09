require 'rails_helper'

RSpec.describe Job, type: :model do
    describe "#valid?" do
      it "title is mandatory" do
        job = Job.new(title:'')
        job.valid?
        expect(job.errors.include?(:title)).to be true                       
      end

      it "description is mandatory" do
        job = Job.new(description:'')
        job.valid?
        expect(job.errors.include?(:description)).to be true                     
      end

      it "skills is mandatory" do
        job = Job.new(skills:'')
        job.valid?
        expect(job.errors.include?(:skills)).to be true                       
      end

      it "salary is mandatory" do
        job = Job.new(salary:'')
        job.valid?
        expect(job.errors.include?(:salary)).to be true               
      end

      it "company is mandatory" do
        job = Job.new(company:'')
        job.valid?
        expect(job.errors.include?(:company)).to be true                     
      end

      it "level is mandatory" do
        job = Job.new(level:'')
        job.valid?
        expect(job.errors.include?(:level)).to be true                   
      end

      it "place is mandatory" do  
        job = Job.new(place:'')
        job.valid?
        expect(job.errors.include?(:place)).to be true                    
      end

      it "date is mandatory" do
        job = Job.new(date:'')
        job.valid?
        expect(job.errors.include?(:date)).to be true
      end
    end  

    describe "generate a code" do
      it "when create a job with sucess" do
        job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                        skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                        company: 'Acme', level: 'Junior', place: 'Test', date: 1.month.from_now)
        result = job.code 
        expect(result).not_to be_empty
        expect(result.length).to eq 8               
      end  

      it "and it should be is uniqueness" do
        allow(SecureRandom).to receive(:alphanumeric).and_return('12345678')
        job1 = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                            skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                            company: 'Acme', level: 'Junior', place: 'Test', 
                            date: 1.month.from_now)
        job2 = Job.new(title: 'Test 2', description: 'Dolor sit amet', 
                            skills: 'Nam mattis.', salary: '299',
                            company: 'Tabajara', level: 'Senior', place: 'Test', 
                            date: 1.month.from_now)
        expect(job2.valid?).to eq false                  
      end

      it "and it can't change after an update" do
        job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                        skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                        company: 'Acme', level: 'Junior', place: 'Test', date: 1.month.from_now)
        result = job.code 
        job.update!(company: "Test")
        expect(result).not_to be_empty
        expect(result).to eq job.code              
      end  
    end

    describe "date" do
      it "can't be in past" do
        job =  Job.new(date: 10.day.ago)
        job.valid?
        expect(job.errors.include?(:date)).to be true 
        expect(job.errors[:date]).to include(" date can't be in past or today.")              
      end 

      it "can't be today" do
        job =  Job.new(date: Date.today)
        job.valid?
        expect(job.errors.include?(:date)).to be true 
        expect(job.errors[:date]).to include(" date can't be in past or today.")              
      end 

      it "must be in future" do
        job =  Job.new(date: 1.day.from_now)
        job.valid? 
        expect(job.errors.include?(:date)).to be false 
      end 
    end 
    
    describe "cleanup one job" do
      it "job on queue with sucess" do
        ActiveJob::Base.queue_adapter = :test
        expect(Delayed::Job.count).to eq 0 
        user = User.create!(:email => "user@test.com", :password => 'test123')
        job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum', 
                          skills: 'Nam mattis', salary: '99', 
                          company: 'Acme', level: 'Junior', place: 'Remote',
                          date: 1.month.from_now)
        apply = Apply.create!(:job => job, :user => user) 
        job.draft!
        expect(Delayed::Job.count).to eq 1
        Delayed::Worker.new.work_off
        expect(ApplyListJob).to have_been_enqueued 
      end 
    end  
end
