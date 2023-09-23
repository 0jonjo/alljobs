# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplyCleanupJob, type: :job do
  describe 'Clean apply to a job opening' do
    it 'with sucess' do
      apply = create(:apply)
      ApplyCleanupJob.new.perform(apply.id)
      apply_to_clean = Apply.where(job_id: apply.job_id)
      expect(apply_to_clean.exists?).to be false
    end
  end
end
