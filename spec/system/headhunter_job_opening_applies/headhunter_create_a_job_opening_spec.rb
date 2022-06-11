require 'rails_helper'

describe 'Headhunter create a job opening' do
    it 'with sucess' do
      headhunter = Headhunter.create!(:email => 'admin@test.com', :password => 'test123')
      login_as(headhunter, :scope => :headhunter)
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
      fill_in 'Date', with: '21/11/2022'
      click_on 'Create Job'
      
      #adjust expects, testes unitários, validates no model 
      #- possivelmente ajuste com db:migrate em salary 
      #mexer também em show, index, etc. dos jobs
      expect(current_path).to eq job_path(1)
      expect(page).to have_content("You successfully registered a Job Opening.")
      expect(page).to have_content("Job Opening Test")
      expect(page).to have_content("Test")
      expect(page).to have_content("Junior")
    end
end
