# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Headhunter, type: :model do
  it { should have_many(:stars) }

  it 'has many comments as author (polymorphic)' do
    headhunter = build(:headhunter)
    expect(headhunter).to respond_to(:comments)
  end
end
