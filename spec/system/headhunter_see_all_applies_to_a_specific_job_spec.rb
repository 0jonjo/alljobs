require 'rails_helper'

describe 'Visit the homepage as Headhunter' do

  it 'see applies to a specific job' do
  
    Job.new(title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet', 
    skills: 'Nam mattis, felis ut adipiscing.', salary: '$99/m', company: 'Acme', level: 'Junior', 
    place: 'Remote Job').save 

    user = User.create!(:email => 'usuario@disco1995.com.br', :password => 'd2blackalien')
    login_as(user, :scope => :user)
    visit root_path

    visit root_path
    click_on 'Openings'
    click_on 'Job Opening Test 123'
    click_on 'Apply for this Job'
    logout(:user)

    headhunter = Headhunter.create!(:email => 'usuario@disco1995.com.br', :password => 'd2blackalien')
    login_as(headhunter, :scope => :headhunter)
    visit root_path

    click_on 'Openings'
    expect(page).to have_content('Job Opening Test 123')
    click_on 'Job Opening Test 123'
    expect(page).to have_content('All applies to this job')
    expect(page).to have_content('ID: 1') 
    expect(page).to have_content('User E-mail: usuario@disco1995.com.br ')
  end
end
