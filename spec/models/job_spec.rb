require 'rails_helper'

RSpec.describe Job, type: :model do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_presence_of :skills }
  it { is_expected.to validate_presence_of :salary }
  it { is_expected.to validate_presence_of :level }
  it { is_expected.to validate_presence_of :company }
  it { is_expected.to validate_presence_of :country }
  it { is_expected.to validate_presence_of :city }
  it { is_expected.to validate_presence_of :date }

  #it { should validate_uniqueness_of :code }

  let(:country) { build(:country) }
  let(:company) { build(:company) }
  let(:job) { build(:job) }
  let(:apply) { build(:apply) }

  describe "generate a code" do
    it "when create a job with sucess" do
      #job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet',
                        #skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                        #company: company, level: 'Junior', country: country, city: 'Test', date: 1.month.from_now)
        expect(job.code.length).to eq 8
      end

      it "and it should be is uniqueness" do
        allow(SecureRandom).to receive(:alphanumeric).and_return('12345678')
        job1 = Job.create!(title: job.title, description: 'Lorem ipsum dolor sit amet', 
                            skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                            company: company, level: 'Senior', country: country, city: 'Test', 
                            date: 1.month.from_now)
        job2 = Job.new(title: 'Test 2', description: 'Dolor sit amet', 
                            skills: 'Nam mattis.', salary: '299',
                            company: company, level: 'Senior', country: country, city: 'Test', 
                            date: 1.month.from_now)
        expect(job2.valid?).to eq false
      end
    end

    describe "date" do
      it "can't be in past" do
        job = Job.new(date: 10.day.ago)
        job.valid?
        expect(job.errors.include?(:date)).to be true
        expect(job.errors[:date]).to include(" date can't be in past or today.")
      end

      it "can't be today" do
        job = Job.new(date: Date.today)
        job.valid?
        expect(job.errors.include?(:date)).to be true
        expect(job.errors[:date]).to include(" date can't be in past or today.")
      end

      it "must be in future" do
        job = Job.new(date: 1.day.from_now)
        job.valid?
        expect(job.errors.include?(:date)).to be false
      end
    end

    describe "cleanup one job" do
      it "job on queue with sucess" do
        ActiveJob::Base.queue_adapter = :test
        expect(Delayed::Job.count).to eq 0
        job = create(:job)
        create(:apply)
        job.draft!
        expect(Delayed::Job.count).to eq 1
        Delayed::Worker.new.work_off
        expect(ApplyListJob).to have_been_enqueued
      end
    end
end
