# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendApplyConfirmedEmailJob, type: :job do
  describe '#perform' do
    let(:apply) { create(:apply) }

    it 'delivers an apply_confirmed email to the user' do
      expect { described_class.new.perform(apply.id) }.to change {
        ActionMailer::Base.deliveries.count
      }.by(1)
    end
  end
end
