require 'rails_helper'

describe 'Headhunter view applies to a specific job' do

  let(:headhunter) { create(:headhunter) }
  let(:job) { create(:job) }

  before do
    login_as(headhunter, :scope => :headhunter)
  end

  it 'with sucess' do
    apply1 = create(:apply, job: job)
    apply2 = create(:apply, job: job)

    visit root_path
    within('nav') do
      click_on I18n.t('openings')
    end

    click_on job.title.to_s

    expect(page).to have_content(I18n.t('all_applies'))
    expect(page).to have_content(apply1.id.to_s)
    expect(page).to have_content(apply2.id.to_s)
    expect(page).to have_content(apply1.user_email)
    expect(page).to have_content(apply2.user_email)
  end

  it 'without sucess - no applies to this job' do
    visit job_path(job.id.to_s)
    expect(page).not_to have_content(I18n.t('all_applies'))
  end
end
