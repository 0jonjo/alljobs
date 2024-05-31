# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "alljobs@test.com"
  layout "mailer"
end
