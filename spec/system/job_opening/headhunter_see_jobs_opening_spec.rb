require 'rails_helper'

describe 'Headhunter see job openings' do
  context "job opening published" do  
    it 'with sucess' do
      2.times do |n|
        Job.create!(title: "Test #{n}", description: 'Lorem ipsum dolor sit amet', 
                            skills: 'Nam mattis, felis ut adipiscing.', 
                            salary: '99', company: 'Acme', 
                            level: 'Junior', place: 'Remote Job',
                            date: 1.month.from_now)
      end
      job2 = Job.create!(title: 'Test 2', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: 1.month.from_now, job_status: :archived) 
      job2 = Job.create!(title: 'Test 3', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: 1.month.from_now, job_status: :draft)                                                           
      headhunter = Headhunter.create!(:email => 'headhunter@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit jobs_path
    
      expect(page).to have_content('Test 0')
      expect(page).to have_content('Test 1')
      expect(page).not_to have_content('Test 2')
      expect(page).not_to have_content('Test 3')

      expect(page).to have_link(I18n.t('archived'))
      expect(page).to have_link(I18n.t('draft'))
    end

    it 'without sucess - no one job' do                                                           
      headhunter = Headhunter.create!(:email => 'headhunter@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit jobs_path
        
      expect(page).to have_content(I18n.t('no_jobs'))
    end  
  end 
  
  context "job opening drafted" do  
    it 'with sucess' do
      job1 = Job.create!(title: 'Test 0', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: 1.month.from_now)
      job2 = Job.create!(title: 'Test 1', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: 1.month.from_now, job_status: :archived)
      job3 = Job.create!(title: 'Test 2', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: 1.month.from_now, job_status: :draft) 
      job4 = Job.create!(title: 'Test 3', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: 1.month.from_now, job_status: :draft)                                                           
      headhunter = Headhunter.create!(:email => 'headhunter@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit jobs_path
      click_on I18n.t('draft')
    
      expect(page).not_to have_content('Test 0')
      expect(page).not_to have_content('Test 1')
      expect(page).to have_content('Test 2')
      expect(page).to have_content('Test 3')
    end

    it 'without sucess - no one job' do                                                           
      headhunter = Headhunter.create!(:email => 'headhunter@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit jobs_path
      click_on I18n.t('draft')
        
      expect(page).to have_content(I18n.t('no_jobs'))
    end  
  end

  context "job opening drafted" do  
    it 'with sucess' do
      job1 = Job.create!(title: 'Test 0', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: 1.month.from_now)
      job2 = Job.create!(title: 'Test 1', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: 1.month.from_now, job_status: :archived)
      job3 = Job.create!(title: 'Test 2', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: 1.month.from_now, job_status: :draft) 
      job4 = Job.create!(title: 'Test 3', description: 'Lorem ipsum dolor sit amet', 
                          skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                          company: 'Acme', level: 'Junior', place: 'Remote Job',
                          date: 1.month.from_now, job_status: :draft)                                                           
      headhunter = Headhunter.create!(:email => 'headhunter@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit jobs_path
      click_on I18n.t('draft')
    
      expect(page).not_to have_content('Test 0')
      expect(page).not_to have_content('Test 1')
      expect(page).to have_content('Test 2')
      expect(page).to have_content('Test 3')

      expect(page).to have_link(I18n.t('archived'))
      expect(page).to have_link(I18n.t('published'))
    end

    it 'without sucess - no one job' do                                                           
      headhunter = Headhunter.create!(:email => 'headhunter@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit jobs_path
      click_on I18n.t('all_archived')
      
      expect(page).to have_content(I18n.t('no_jobs'))
      expect(page).to have_link(I18n.t('all_drafted'))
      expect(page).to have_link(I18n.t('all_published'))
    end  
  end
end