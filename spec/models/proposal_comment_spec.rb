# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProposalComment, type: :model do
  describe 'scopes' do
    describe '.by_proposal_id' do
      subject { ProposalComment.by_proposal_id(proposal1.id) }

      let!(:proposal1) { create(:proposal) }
      let!(:proposal2) { create(:proposal) }
      let!(:proposal_comment1) { create(:proposal_comment, proposal_id: proposal1.id) }
      let!(:proposal_comment2) { create(:proposal_comment, proposal_id: proposal2.id) }

      it 'returns proposal comments with the given proposal_id' do
        expect(subject).to include(proposal_comment1)
        expect(subject).not_to include(proposal_comment2)
      end
    end

    describe '.by_author' do
      subject { ProposalComment.by_author('Headhunter', author1.id) }

      let!(:author1) { create(:headhunter) }
      let!(:author2) { create(:headhunter) }
      let!(:proposal_comment1) { create(:proposal_comment, author_type: 'Headhunter', author_id: author1.id) }
      let!(:proposal_comment2) { create(:proposal_comment, author_type: 'Headhunter', author_id: author2.id) }

      it 'returns proposal comments with the given author_type and author_id' do
        expect(subject).to include(proposal_comment1)
        expect(subject).not_to include(proposal_comment2)
      end
    end
  end
end
