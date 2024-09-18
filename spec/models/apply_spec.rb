# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Apply, type: :model do
  describe 'scopes' do
    describe '.sorted_id' do
      it 'orders the applies by id' do
        apply1 = create(:apply)
        apply2 = create(:apply)
        apply3 = create(:apply)

        expect(Apply.sorted_id).to eq([apply1, apply2, apply3])
      end
    end

    describe '.applied_by_user' do
      let(:job) { create(:job) }
      let(:user) { create(:user) }

      it 'returns the applies applied by the specified user for the specified job' do
        apply1 = create(:apply, job:, user:)
        create(:apply)

        expect(Apply.applied_by_user(job.id, user.id)).to eq([apply1])
      end
    end
  end
end
