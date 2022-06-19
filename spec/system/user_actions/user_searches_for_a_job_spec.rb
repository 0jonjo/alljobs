require 'rails_helper'

describe 'User searches for a job' do
  it 'have to signin to see the search' do
  visit root_path
  within('nav') do
    expect(page).not_to have_field('Search Job')
    expect(page).not_to have_button('Search')
  end   

  end
  it 'acess form on menu' do
    user = User.create!(email: 'user@test.com', password: 'test123')
    login_as(user)
    
    visit root_path
    within('nav') do
      expect(page).to have_field('Search Job')
      expect(page).to have_button('Search')
    end   
  end

  it 'with sucess'do
    job = Job.create!(title: 'Job Opening Test', description: 'Lorem ipsum dolor sit amet', 
                    skills: 'Nam mattis, felis ut adipiscing.', salary: '99', 
                    company: 'Acme', level: 'Junior', place: 'Remote Job',
                    date: 1.month.from_now)
    user = User.create!(email: 'user@test.com', password: 'test123')
    login_as(user)
    
    visit root_path
    fill_in 'Search Job', with: job.code
    click_on 'Search'

    expect(page).to have_content("All results for #{job.code}")
    expect(page).to have_content('1 job found.')
    expect(page).to have_content("#{job.code}")
    expect(page).to have_content('Job Opening Test')
    #depois mudar para have_link e acessar qual o job por ai também.
  end
end      