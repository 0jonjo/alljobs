# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'validations' do
    %i[title description skills salary level company country city date].each do |attribute|
      it { is_expected.to validate_presence_of(attribute) }
    end
  end

  let(:country) { build(:country) }
  let(:company) { build(:company) }
  let(:apply) { build(:apply) }

  describe 'scopes' do
    describe '.search' do
      let!(:ruby_job) { create(:job, title: 'Ruby Developer') }
      let!(:python_job) { create(:job, title: 'Python Developer') }
      let!(:java_job) { create(:job, title: 'Java Developer') }

      context 'when search term matches a job title' do
        it 'returns jobs with matching title' do
          expect(Job.search('Ruby')).to contain_exactly(ruby_job)
        end
      end

      context 'when no jobs match the search term' do
        it 'returns an empty array' do
          expect(Job.search('PHP')).to be_empty
        end
      end

      context 'when search term is blank' do
        it 'returns all jobs' do
          expect(Job.search('')).to contain_exactly(ruby_job, python_job, java_job)
        end
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
      let!(:draft_job) { create(:job, job_status: :draft) }
      let!(:published_job) { create(:job, job_status: :published) }
      let!(:archived_job) { create(:job, job_status: :archived) }

      it 'returns jobs with the specified job_status' do
        expect(Job.indexed(:draft)).to contain_exactly(draft_job)
        expect(Job.indexed(:published)).to contain_exactly(published_job)
        expect(Job.indexed(:archived)).to contain_exactly(archived_job)
      end
    end

    describe '.search_web' do
      let!(:job1) { create(:job, title: 'Ruby Developer', description: 'Ruby on Rails Developer') }
      let!(:job2) { create(:job, title: 'Python Developer', description: 'Django Developer') }
      let!(:job3) { create(:job, title: 'Java Developer', description: 'Spring Developer') }

      context 'when search term matches a job code' do
        it 'returns jobs with matching code' do
          allow(SecureRandom).to receive(:alphanumeric).and_return('ABC12345')
          job_with_code = create(:job)
          allow(SecureRandom).to receive(:alphanumeric).and_return('DEF67890')
          create(:job)

          expect(Job.search_web('ABC')).to contain_exactly(job_with_code)
        end
      end

      context 'when search term matches a job title' do
        it 'returns jobs with matching title' do
          expect(Job.search_web('Ruby')).to contain_exactly(job1)
        end
      end

      context 'when search term matches a job description' do
        it 'returns jobs with matching description' do
          expect(Job.search_web('Rails')).to contain_exactly(job1)
        end
      end

      context 'when search term matches a job title or description' do
        it 'returns jobs with matching title or description' do
          expect(Job.search_web('Developer')).to contain_exactly(job1, job2, job3)
        end
      end

      context 'when no jobs match the search term' do
        it 'returns an empty array' do
          expect(Job.search_web('PHP')).to be_empty
        end
      end

      context 'when search term is blank' do
        it 'returns all jobs' do
          expect(Job.search_web('')).to contain_exactly(job1, job2, job3)
        end
      end
    end
  end

  describe 'generate a code' do
    let(:job) { build(:job) }

    it 'generates a unique code when a job is created' do
      expect(job.code.length).to eq 8
    end

    it 'ensures the code is unique' do
      allow(SecureRandom).to receive(:alphanumeric).and_return('12345678')
      create(:job)
      job_with_duplicate_code = build(:job)
      expect(job_with_duplicate_code.valid?).to be false
    end
  end

  describe 'date validation' do
    it "doesn't allow dates in the past" do
      job = build(:job, date: 10.days.ago)
      job.valid?
      expect(job.errors[:date]).to include(" date can't be in past or today.")
    end

    it "doesn't allow today's date" do
      job = build(:job, date: Time.zone.today)
      job.valid?
      expect(job.errors[:date]).to include(" date can't be in past or today.")
    end

    it 'allows dates in the future' do
      job = build(:job, date: 1.day.from_now)
      job.valid?
      expect(job.errors[:date]).to be_empty
    end
  end

  describe 'cleanup one job' do
    it 'queues the job successfully' do
      ActiveJob::Base.queue_adapter = :test
      expect do
        job = create(:job)
        create(:apply, job: job)
        job.draft!
      end.to have_enqueued_job(ApplyListJob)
    end
  end
end
