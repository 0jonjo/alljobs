# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should validate_presence_of(:body) }

  describe 'scope comments_by_headhunter' do
    let(:headhunter) { create(:headhunter) }
    let(:profile) { create(:profile) }

    before do
      create(:comment, headhunter:, profile:)
      create(:comment, headhunter:, profile:)
      create(:comment, headhunter:)
    end

    it 'returns comments by the specified headhunter and profile' do
      comments = Comment.comments_by_headhunter(headhunter, profile)
      expect(comments.count).to eq(2)
      expect(comments).to all(have_attributes(headhunter:, profile:))
    end
  end
end
