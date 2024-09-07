# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfileMailer, type: :mailer do
  let(:profile) { create(:profile, name: 'Test Name') }
  let(:created_profile) { 'created your profile' }

  describe '#successful_action' do
    before do
      ActiveJob::Base.queue_adapter = :test
    end
    context 'have enqueued a job using the correct data' do
      let(:successful_action) { described_class.successful_action(profile.id, created_profile, 'http://localhost:3000/users/sign_in') }
      let(:mail_body) { successful_action.body.encoded }

      it { expect { successful_action.deliver_later }.to have_enqueued_job }
      it { expect(successful_action.subject).to match("Alljobs: You #{created_profile}") }
      it { expect(mail_body).to match('Test Name') }
      it { expect(mail_body).to match('http://localhost:3000/users/sign_in') }
      it { expect(mail_body).to match(created_profile) }
    end
  end
end
