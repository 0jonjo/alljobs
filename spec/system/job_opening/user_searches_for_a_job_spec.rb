require 'rails_helper'

describe 'User searches for a job' do
  it 'have to signin to see the search' do
  visit root_path
  within('nav') do
    expect(page).not_to have_field(I18n.t('search_job'))
    expect(page).not_to have_button(I18n.t('search'))
  end   

  end
  it 'acess form on menu' do
    user = User.create!(email: 'user@test.com', password: 'test123')
    login_as(user)
    
    visit root_path
    within('nav') do
      expect(page).to have_field(I18n.t('search_job'))
      expect(page).to have_button(I18n.t('search'))
    end   
  end

  it 'with sucess, only a result'do
    job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                    skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                    company: 'Acme', level: 'Junior', place: 'Remote Job',
                    date: 1.month.from_now)
    user = User.create!(email: 'user@test.com', password: 'test123')
    login_as(user)
    
    visit root_path
    fill_in I18n.t('search_job'), with: job.code
    click_on I18n.t('search')

    expect(page).to have_content("#{job.code}")
    expect(page).to have_content("1 #{I18n.t('jobs_found')}")
    expect(page).to have_content("#{job.code}")
    expect(page).to have_content('Job Opening Test')
    #depois mudar para have_link e acessar qual o job por ai também.
  end

  it "with sucess, many results" do
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')
    job1 = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                        skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                        company: 'Acme', level: 'Junior', place: 'Remote Job',
                        date: 1.month.from_now)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC54321')
    job2 = Job.create!(title: 'Another test', description: 'Lorem ipsum dolor sit amet', 
                        skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                        company: 'Acme', level: 'Junior', place: 'Remote Job',
                        date: 1.month.from_now)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ZZZZZZZZ')
    job3 = Job.create!(title: 'Last test', description: 'Lorem ipsum dolor sit amet', 
                        skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                        company: 'Acme', level: 'Junior', place: 'Remote Job',
                        date: 1.month.from_now)                      
    user = User.create!(email: 'user@test.com', password: 'test123')
    login_as(user)

    visit root_path
    fill_in I18n.t('search_job'), with: 'ABC'
    click_on I18n.t('search')

    expect(page).to have_content("ABC")
    expect(page).to have_content("Abc12345")
    expect(page).to have_link('Job Opening Test')
    expect(page).to have_content("Abc54321")
    expect(page).to have_link('Another test')
    expect(page).not_to have_content('ZZZZZZZZ')
    expect(page).not_to have_content('Last test')
  end

  it "without any result" do
    job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
    skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
    company: 'Acme', level: 'Junior', place: 'Remote Job',
    date: 1.month.from_now)
    user = User.create!(email: 'user@test.com', password: 'test123')
    login_as(user)

    visit root_path
    fill_in I18n.t('search_job'), with: "ZZZZZZZ"
    click_on I18n.t('search')

    expect(page).to have_content(I18n.t('no_jobs'))
    expect(page).not_to have_content(I18n.t('jobs_found'))
  end

end      