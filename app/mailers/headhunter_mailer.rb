# frozen_string_literal: true

class HeadhunterMailer < ApplicationMailer
  def welcome(headhunter_id)
    @headhunter = Headhunter.find(headhunter_id)
    mail(to: @headhunter.email, subject: t('mailers.headhunter.welcome.subject'))
  end
end
