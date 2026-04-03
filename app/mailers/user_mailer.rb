# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def welcome(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: t('mailers.user.welcome.subject'))
  end

  def apply_confirmed(apply_id)
    @apply = Apply.includes(:job, :user).find(apply_id)
    @user  = @apply.user
    @job   = @apply.job
    mail(to: @user.email, subject: t('mailers.user.apply_confirmed.subject', job_title: @job.title))
  end
end
