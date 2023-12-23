# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Proposal, type: :model do
  describe '#valid?' do
    it 'benefits is mandatory' do
      proposal = Proposal.new(benefits: '')
      proposal.valid?
      expect(proposal.errors.include?(:benefits)).to be true
    end

    it 'expectations is mandatory' do
      proposal = Proposal.new(expectations: '')
      proposal.valid?
      expect(proposal.errors.include?(:expectations)).to be true
    end

    it 'apply_id is mandatory' do
      proposal = Proposal.new(apply_id: '')
      proposal.valid?
      expect(proposal.errors.include?(:apply_id)).to be true
    end

    it 'salary is mandatory' do
      proposal = Proposal.new(salary: '')
      proposal.valid?
      expect(proposal.errors.include?(:salary)).to be true
    end

    it 'salary must be only decimal' do
      proposal = Proposal.new(salary: 'test')
      proposal.valid?
      expect(proposal.errors.include?(:salary)).to be true
    end
  end

  describe 'expected_start' do
    it "can't be in past" do
      proposal = Proposal.new(expected_start: 10.day.ago)
      proposal.valid?
      expect(proposal.errors.include?(:expected_start)).to be true
      expect(proposal.errors[:expected_start]).to include(" expected start can't be in past.")
    end

    it 'must be in future' do
      proposal = Proposal.new(expected_start: 1.day.from_now)
      proposal.valid?
      expect(proposal.errors.include?(:expected_start)).to be false
    end
  end

  describe 'scopes' do
    describe '.by_apply_id' do
      let!(:apply) { create(:apply) }

      subject { Proposal.by_apply_id(apply.id) }

      it 'returns proposals with matching apply_id' do
        proposal1 = create(:proposal, apply_id: apply.id)
        proposal2 = create(:proposal)

        expect(subject).to include(proposal1)
        expect(subject).not_to include(proposal2)
      end
    end
  end
end
