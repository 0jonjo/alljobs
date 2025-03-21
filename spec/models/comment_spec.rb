# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:author_id) }
  it { should validate_presence_of(:author_type) }
end
