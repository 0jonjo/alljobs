require 'rails_helper'

describe 'Visit the homepage' do

    it 'create The Headhunter, login and create a job opening' do
    
        Headhunter.create(email: 'herbiehancock@ndtheheadhunters.com',
            password: 'watermelonman')

        visit root_path
        click_on 'Login Headhunter'
        fill_in 'Email', with: 'herbiehancock@ndtheheadhunters.com'
        fill_in 'Password', with: 'watermelonman'
        click_on 'Log in'
    
        
        expect(current_path).to eq root_path
        expect(page).to have_content 'All Jobs'
    
      click_on 'New Job Opening'
      fill_in 'Title', with: 'Job Opening Test 123'
      fill_in 'Description', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in 'Skills', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget ligula eu lectus lobortis condimentum. Aliquam nonummy auctor massa. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at risus. Quisque purus magna, auctor et, sagittis ac, posuere eu, lectus. Nam mattis, felis ut adipiscing.'
      fill_in 'Salary', with: '$9999'
      fill_in 'Level', with: 'Junior'
      fill_in 'Place', with: 'Remote Job'
      fill_in 'Date', with: '21/11/2022'
      click_on 'Create Job'
    
      expect(page).to have_content 'Job Opening Test 123'
    end
end
