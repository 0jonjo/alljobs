# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Star, type: :model do
  describe 'scopes' do
    let(:headhunter) { create(:headhunter) }
    let(:apply) { create(:apply) }

    describe '.filtered_by_ids' do
      subject { Star.filtered_by_ids(headhunter.id, apply.id) }

      it 'returns stars filtered by headhunter_id and apply_id' do
        star1 = create(:star, headhunter: headhunter, apply: apply)
        star2 = create(:star, headhunter: headhunter)
        expect(subject).to eq([ star1 ])
        expect(subject).not_to eq([ star2 ])
      end
    end

    describe '.filtered_by_headhunter' do
      subject { Star.filtered_by_headhunter(headhunter.id) }

      it 'returns only stars filtered by headhunter_id' do
        star1 = create(:star, headhunter: headhunter)
        star2 = create(:star, headhunter: headhunter)
        star3 = create(:star)
        expect(subject).to include(star1)
        expect(subject).to include(star2)
        expect(subject).not_to include(star3)
      end
    end
  end
end
