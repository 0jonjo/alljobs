require 'rails_helper'

describe 'Visit the homepage as Headhunter' do

  it 'see all job opening applies' do
  
    Job.new(title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet', 
    skills: 'Nam mattis, felis ut adipiscing.', salary: '$99/m', company: 'Acme', level: 'Junior', 
    place: 'Remote Job').save 

    headhunter = Headhunter.create!(:email => 'usuario@disco1995.com.br', :password => 'd2blackalien')
    login_as(headhunter, :scope => :headhunter)
    visit root_path

    click_on ""All Job Applies""
    expect(page).to have_content('Applies to All Jobs')
    expect(page).to have_content('Job ID: 1')
    expect(page).to have_content('User E-mail: usuario@disco1995.com.br ')
  end
end
