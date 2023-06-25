require 'rails_helper'

describe 'Headhunter see his stars' do

  let(:headhunter) { create(:headhunter) }
  let(:apply1) { create(:apply) }
  let(:apply2) { create(:apply) }

  before do
    login_as(headhunter, :scope => :headhunter)
  end

  it 'with sucess' do
    star1 = Star.create(headhunter: headhunter, apply: apply1)
    star1 = Star.create(headhunter: headhunter, apply: apply2)

    visit root_path
    click_on I18n.t('stars')

    expect(page).to have_content(I18n.t('stars'))
    expect(page).to have_content(apply1.id)
    expect(page).to have_content(apply1.profile_social_name)
    expect(page).not_to have_content(apply2.id)
    expect(page).to have_content(apply2.profile_social_name)
  end

  it 'without sucess because there arent any star profile' do
    visit root_path
    click_on I18n.t('stars')
    expect(page).to have_content(I18n.t('no_stars'))
  end

  it 'without sucess because there arent any star profile to this headhunter' do
    user = User.create!(:email => 'user@test.com', :password => 'test123')
    profile = Profile.create!(name: "Tester", birthdate: "1991-12-12", description: "Tester 3", educacional_background: "Tester 3", experience: "Tester 3", user_id: user.id)
    headhunter1 = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
    headhunter2 = Headhunter.create!(:email => 'admin2@test.com', :password => 'test123')
    job =  Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                        skills: 'Nam mattis, felis ut adipiscing.', salary: '99',
                        company: 'Acme', level: 'Junior', place: 'Remote',
                        date: '24/12/2099')
    apply = Apply.create!(:job => job, :user => user)
    Star.create!(profile_id: profile.id, headhunter_id: headhunter2.id, apply_id: apply.id)
    login_as(headhunter1, :scope => :headhunter)
  
    visit root_path
    click_on I18n.t('stars')

    expect(page).to have_content(I18n.t('no_stars'))
    expect(page).not_to have_content('Tester') 
  end
end
