# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendWelcomeEmailJob, type: :job do
  describe '#perform' do
    context 'when requester_type is User' do
      let(:user) { create(:user) }

      it 'delivers a welcome email to the user' do
        expect { described_class.new.perform('User', user.id) }.to change {
          ActionMailer::Base.deliveries.count
        }.by(1)
      end
    end

    context 'when requester_type is Headhunter' do
      let(:headhunter) { create(:headhunter) }

      it 'delivers a welcome email to the headhunter' do
        expect { described_class.new.perform('Headhunter', headhunter.id) }.to change {
          ActionMailer::Base.deliveries.count
        }.by(1)
      end
    end

    context 'when requester_type is unknown' do
      it 'raises ArgumentError' do
        expect { described_class.new.perform('Unknown', 1) }.to raise_error(ArgumentError, /Unknown requester_type/)
      end
    end
  end
end
