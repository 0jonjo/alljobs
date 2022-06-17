require 'rails_helper'

RSpec.describe Job, type: :model do
    describe "#valid?" do
      it "title is mandatory" do
        job = Job.new(title: '', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '$99/m',
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: '24/12/2099')
        expect(job.valid?).to eq false                       
      end

      it "description is mandatory" do
        job = Job.new(title: 'Job Opening Test', description: '', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '$99/m',
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: '24/12/2099')
        expect(job.valid?).to eq false                       
      end

      it "skills is mandatory" do
        job = Job.new(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                          skills: '', salary: '$99/m',
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: '24/12/2099')
        expect(job.valid?).to eq false                       
      end

      it "salary is mandatory" do
        job = Job.new(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '',
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: '24/12/2099')
        expect(job.valid?).to eq false                       
      end

      it "company is mandatory" do
        job = Job.new(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '$99/m',
                          company: '', level: 'Junior', place: 'Remote Job',
                          date: '24/12/2099')
        expect(job.valid?).to eq false                       
      end

      it "level is mandatory" do
        job = Job.new(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '$99/m',
                          company: 'Acme', level: '', place: 'Remote Job',
                          date: '24/12/2099')
        expect(job.valid?).to eq false                       
      end

      it "place is mandatory" do
        job = Job.new(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '$99/m',
                          company: 'Acme', level: 'Junior', place: '',
                          date: '24/12/2099')
        expect(job.valid?).to eq false                       
      end

      it "date is mandatory" do
        job = Job.new(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '$99/m',
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: '')
        expect(job.valid?).to eq false                       
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
        job2 = Job.create(title: 'Test 2', description: 'Dolor sit amet', 
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
        result = job.errors.include?(:date)
        expect(result).to be true 
        expect(job.errors[:date]).to include(" date can't be in past or today.")              
      end 

      it "can't be today" do
        job =  Job.new(date: Date.today)
        job.valid?
        result = job.errors.include?(:date)
        expect(result).to be true 
        expect(job.errors[:date]).to include(" date can't be in past or today.")              
      end 

      it "must be in future" do
        job =  Job.new(date: 1.day.from_now)
        job.valid?
        result = job.errors.include?(:date)
        expect(result).to be false 
      end 
    end   
end
