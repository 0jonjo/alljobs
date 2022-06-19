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
                        company: 'Acme', level: 'Junior', place: 'Test', date: '24/12/2099')
        result = job.code 
        expect(result).not_to be_empty
        expect(result.length).to eq 8               
      end  

      it "and it should be is uniqueness" do
        allow(SecureRandom).to receive(:alphanumeric).and_return('12345678')
        job1 = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                            skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                            company: 'Acme', level: 'Junior', place: 'Test', 
                            date: '24/12/2099')
        job2 = Job.new(title: 'Test 2', description: 'Dolor sit amet', 
                            skills: 'Nam mattis.', salary: '299',
                            company: 'Tabajara', level: 'Senior', place: 'Test', 
                            date: '24/12/2099')
        expect(job2.valid?).to eq false                  
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
end
