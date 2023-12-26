# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe Job, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to validate_presence_of :skills }
    it { is_expected.to validate_presence_of :salary }
    it { is_expected.to validate_presence_of :level }
    it { is_expected.to validate_presence_of :company }
    it { is_expected.to validate_presence_of :country }
    it { is_expected.to validate_presence_of :city }
    it { is_expected.to validate_presence_of :date }
  end

  let(:country) { build(:country) }
  let(:company) { build(:company) }
  let(:apply) { build(:apply) }

  describe 'scopes' do
    describe '.search' do
      it 'returns jobs with matching title' do
        job = create(:job, title: 'Ruby Developer')
        create(:job, title: 'Python Developer')
        create(:job, title: 'Java Developer')

        expect(Job.search('Ruby')).to contain_exactly(job)
      end

      it 'returns empty array if no matching jobs' do
        create(:job, title: 'Ruby Developer')
        create(:job, title: 'Python Developer')
        create(:job, title: 'Java Developer')

        expect(Job.search('PHP')).to be_empty
      end

      it 'returns all jobs if search term is blank' do
        job1 = create(:job, title: 'Ruby Developer')
        job2 = create(:job, title: 'Python Developer')
        job3 = create(:job, title: 'Java Developer')

        expect(Job.search('')).to contain_exactly(job1, job2, job3)
      end
    end

    describe '.sorted_id' do
      it 'returns jobs sorted by id in ascending order' do
        job1 = create(:job)
        job2 = create(:job)
        job3 = create(:job)

        expect(Job.sorted_id).to eq([job1, job2, job3])
      end
    end

    describe '.indexed' do
      it 'returns jobs with the specified job_status' do
        job1 = create(:job, job_status: :draft)
        job2 = create(:job, job_status: :published)
        job3 = create(:job, job_status: :archived)

        expect(Job.indexed(:draft)).to contain_exactly(job1)
        expect(Job.indexed(:published)).to contain_exactly(job2)
        expect(Job.indexed(:archived)).to contain_exactly(job3)
      end
    end

    describe '.search_web' do
      it 'returns jobs with matching code' do
        allow(SecureRandom).to receive(:alphanumeric).and_return('ABC12345')
        job1 = create(:job)
        allow(SecureRandom).to receive(:alphanumeric).and_return('DEF67890')
        create(:job)

        expect(Job.search_web('ABC')).to contain_exactly(job1)
      end

      it 'returns jobs with matching title' do
        job1 = create(:job, title: 'Ruby Developer')
        create(:job, title: 'Python Developer')
        create(:job, title: 'Java Developer')

        expect(Job.search_web('Ruby')).to contain_exactly(job1)
      end

      it 'returns jobs with matching description' do
        job1 = create(:job, description: 'Ruby on Rails Developer')
        create(:job, description: 'Python Developer')
        create(:job, description: 'Java Developer')

        expect(Job.search_web('Rails')).to contain_exactly(job1)
      end

      it 'returns jobs with matching title or description' do
        job1 = create(:job, title: 'Ruby Developer', description: 'Ruby on Rails Developer')
        job2 = create(:job, title: 'Python Developer', description: 'Django Developer')
        job3 = create(:job, title: 'Java Developer', description: 'Spring Developer')

        expect(Job.search_web('Developer')).to contain_exactly(job1, job2, job3)
      end

      it 'returns empty array if no matching jobs' do
        create(:job, code: 'ABC123', title: 'Ruby Developer')
        create(:job, code: 'DEF456', title: 'Python Developer')
        create(:job, code: 'GHI789', title: 'Java Developer')

        expect(Job.search_web('PHP')).to be_empty
      end

      it 'returns all jobs if search term is blank' do
        job1 = create(:job, code: 'ABC123', title: 'Ruby Developer')
        job2 = create(:job, code: 'DEF456', title: 'Python Developer')
        job3 = create(:job, code: 'GHI789', title: 'Java Developer')

        expect(Job.search_web('')).to contain_exactly(job1, job2, job3)
      end
    end
  end

  describe 'generate a code' do
    let(:job) { build(:job) }

    it 'when create a job with sucess' do
      expect(job.code.length).to eq 8
    end

    it 'and it should be is uniqueness' do
      allow(SecureRandom).to receive(:alphanumeric).and_return('12345678')
      create(:job)
      job = build(:job)
      expect(job.valid?).to eq false
    end
  end

  describe 'date' do
    it "can't be in past" do
      job = build(:job, date: 10.days.ago)
      job.valid?
      expect(job.errors.include?(:date)).to be true
      expect(job.errors[:date]).to include(" date can't be in past or today.")
    end

    it "can't be today" do
      job = build(:job, date: Time.zone.today)
      job.valid?
      expect(job.errors.include?(:date)).to be true
      expect(job.errors[:date]).to include(" date can't be in past or today.")
    end

    it 'must be in future' do
      job = build(:job, date: 1.day.from_now)
      job.valid?
      expect(job.errors.include?(:date)).to be false
    end
  end

  describe 'cleanup one job' do
    it 'on queue with sucess' do
      expect(ApplyListJob.jobs.size).to eq(0)
      job = create(:job)
      create(:apply, job: job)
      job.draft!
      expect(ApplyListJob.jobs.size).to eq(1)
    end
  end
end
