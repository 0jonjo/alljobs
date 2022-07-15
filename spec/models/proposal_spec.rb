require 'rails_helper'

RSpec.describe Proposal, type: :model do
  describe "#valid?" do
    it "benefits is mandatory" do
      proposal = Proposal.new(benefits:'')
      proposal.valid?
      expect(proposal.errors.include?(:benefits)).to be true                       
    end
    
    it "expectations is mandatory" do
      proposal = Proposal.new(expectations:'')
      proposal.valid?
      expect(proposal.errors.include?(:expectations)).to be true                       
    end
    
    it "apply_id is mandatory" do
      proposal = Proposal.new(apply_id:'')
      proposal.valid?
      expect(proposal.errors.include?(:apply_id)).to be true                       
    end
    
    it "salary is mandatory" do
      proposal = Proposal.new(salary:'')
      proposal.valid?
      expect(proposal.errors.include?(:salary)).to be true                       
    end

    it "salary must be only decimal" do
      proposal = Proposal.new(salary:'test')
      proposal.valid?
      expect(proposal.errors.include?(:salary)).to be true                       
    end
  end    
end
