# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendMailSuccessUserJob, type: :job do
  describe 'Send email of success action to user with success' do
    let(:profile) { create(:profile) }

    it {
      expect { SendMailSuccessUserJob.perform_now(profile, '', '') }.to change {
                                                                          ActionMailer::Base.deliveries.count
                                                                        }.by(1)
    }
  end
end
