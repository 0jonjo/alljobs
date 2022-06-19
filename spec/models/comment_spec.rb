require 'rails_helper'

RSpec.describe Comment, type: :model do
    it "body is mandatory" do
      comment = Comment.new(body: '')
      comment.valid?
      expect(comment.errors.include?(:body)).to be true 
    end

    it "datetime is mandatory" do
      comment = Comment.new(datetime: '')
      comment.valid?
      expect(comment.errors.include?(:datetime)).to be true  
    end
end
