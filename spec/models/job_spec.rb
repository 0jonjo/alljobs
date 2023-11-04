# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

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

  let(:country) { build(:country) }
  let(:company) { build(:company) }
  let(:job) { build(:job) }
  let(:apply) { build(:apply) }

  describe 'generate a code' do
    it 'when create a job with sucess' do
      # job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet',
      # skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
      # company: company, level: 'Junior', country: country, city: 'Test', date: 1.month.from_now)
      expect(job.code.length).to eq 8
    end

    it 'and it should be is uniqueness' do
      allow(SecureRandom).to receive(:alphanumeric).and_return('12345678')
      Job.create!(title: job.title, description: 'Lorem ipsum dolor sit amet',
                  skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                  company: company, level: 0, country: country, city: 'Test',
                  date: 1.month.from_now)
      job2 = Job.new(title: 'Test 2', description: 'Dolor sit amet',
                     skills: 'Nam mattis.', salary: '299',
                     company: company, level: 1, country: country, city: 'Test',
                     date: 1.month.from_now)
      expect(job2.valid?).to eq false
    end
  end

  describe 'date' do
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

    it 'must be in future' do
      job = Job.new(date: 1.day.from_now)
      job.valid?
      expect(job.errors.include?(:date)).to be false
    end
  end

  describe 'cleanup one job' do
    it 'on queue with sucess' do
      expect(ApplyListJob.jobs.size).to eq(0)
      create(:job)
      create(:apply, job: job)
      job.draft!
      expect(ApplyListJob.jobs.size).to eq(1)
    end
  end
end
