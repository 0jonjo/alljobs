require 'rails_helper'

describe 'Headhunter create a job opening' do
    it 'with sucess - status published' do
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      allow(SecureRandom).to receive(:alphanumeric).and_return('12345678')
      visit root_path
      
      within('nav') do
        click_on 'New Job Opening'
      end
      fill_in 'Title', with: 'Job Opening Test'
      fill_in 'Description', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in 'Skills', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in 'Salary', with: '9999'
      fill_in 'Company', with: 'Test'
      fill_in 'Level', with: 'Junior'
      fill_in 'Place', with: 'Remote Job'
      fill_in 'Date', with: '21/11/2099'
      select 'published', from: 'Job status'
      click_on 'Create Job'
  
      expect(current_path).to eq job_path(1)
      expect(page).to have_content("You successfully registered a Job Opening.")
      expect(page).to have_content("Job Opening Test")
      expect(page).to have_content("12345678")
      expect(page).to have_content("Test")
      expect(page).to have_content("Junior")
      expect(page).to have_content("Published")
    end

    it 'with sucess - status archived' do
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit new_job_path
     
      fill_in 'Title', with: 'Job Opening Test'
      fill_in 'Description', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in 'Skills', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in 'Salary', with: '9999'
      fill_in 'Company', with: 'Test'
      fill_in 'Level', with: 'Junior'
      fill_in 'Place', with: 'Remote Job'
      fill_in 'Date', with: '21/11/2099'
      select 'archived', from: 'Job status'
      click_on 'Create Job'
  
      expect(current_path).to eq job_path(1)
      expect(page).to have_content("Archived")
    end

    it 'with sucess - status archived' do
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      visit new_job_path
     
      fill_in 'Title', with: 'Job Opening Test'
      fill_in 'Description', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in 'Skills', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in 'Salary', with: '9999'
      fill_in 'Company', with: 'Test'
      fill_in 'Level', with: 'Junior'
      fill_in 'Place', with: 'Remote Job'
      fill_in 'Date', with: '21/11/2099'
      select 'draft', from: 'Job status'
      click_on 'Create Job'
  
      expect(current_path).to eq job_path(1)
      expect(page).to have_content("Draft")
    end

    it 'without sucess' do
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
      allow(SecureRandom).to receive(:alphanumeric).and_return('12345678')
      visit root_path
      
      within('nav') do
        click_on 'New Job Opening'
      end
      fill_in 'Title', with: ''
      fill_in 'Description', with: ''
      fill_in 'Skills', with: ''
      fill_in 'Salary', with: ''
      fill_in 'Company', with: 't'
      fill_in 'Level', with: ''
      fill_in 'Place', with: ''
      fill_in 'Date', with: ''
      click_on 'Create Job'
  
      expect(page).to have_content("Job Opening was not registered.")
    end
end
