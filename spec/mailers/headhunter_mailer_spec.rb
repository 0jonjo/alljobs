# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HeadhunterMailer, type: :mailer do
  describe '#welcome' do
    let(:headhunter) { create(:headhunter) }
    let(:mail) { described_class.welcome(headhunter.id) }

    it 'renders the subject' do
      expect(mail.subject).to eq(I18n.t('mailers.headhunter.welcome.subject'))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([headhunter.email])
    end

    it 'includes the headhunter email in the body' do
      expect(mail.body.encoded).to match(headhunter.email)
    end
  end
end
