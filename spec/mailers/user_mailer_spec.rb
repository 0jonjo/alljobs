# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe '#welcome' do
    let(:user) { create(:user) }
    let(:mail) { described_class.welcome(user.id) }

    it 'renders the subject' do
      expect(mail.subject).to eq(I18n.t('mailers.user.welcome.subject'))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'includes the user email in the body' do
      expect(mail.body.encoded).to match(user.email)
    end
  end

  describe '#apply_confirmed' do
    let(:apply) { create(:apply) }
    let(:mail) { described_class.apply_confirmed(apply.id) }

    it 'renders the subject' do
      expect(mail.subject).to include(apply.job.title).and include('Alljobs')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([apply.user.email])
    end

    it 'includes the job title in the body' do
      expect(mail.text_part.decoded).to include(apply.job.title)
    end
  end
end
