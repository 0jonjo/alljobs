require 'rails_helper'

describe 'User' do

  let(:profile) { create(:profile) }
  let!(:job) { create(:job) }

  context 'applies to a job opening' do

    before do
      login_as(profile.user, :scope => :user)
    end

    it 'with sucess' do
      visit root_path
      within('nav') do
        click_on I18n.t('openings')
      end

      click_on job.title
      click_on I18n.t('to_apply')

      expect(page).to have_content(I18n.t('apply_to'))
      expect(page).to have_content(job.title)
    end

    it 'without sucess - already applied' do
      apply = Apply.create!(:job => job, :user => profile.user)

      visit job_path(job)

      expect(page).to have_content(I18n.t('your_apply'))
      expect(page).not_to have_content(I18n.t('to_apply'))
    end

    it "and remove his apply with sucess" do
      apply = Apply.create!(:job => job, :user => profile.user)

      visit apply_path(apply)
      click_on I18n.t('delete')

      expect(current_path).to eq(job_path(job))
    end
  end
end