require 'rails_helper'

describe 'Visit the homepage ' do

  it 'apllies to a job opening' do

    Job.new(title: 'Job Opening Test 123', description: 'Lorem ipsum dolor sit amet', 
    skills: 'Nam mattis, felis ut adipiscing.', salary: '$99/m', company: 'Acme', level: 'Junior', 
    place: 'Remote Job').save 
        
    user = User.create!(:email => 'usuario@disco1995.com.br', :password => 'd2blackalien')
    login_as(user, :scope => :user)
    
    visit root_path
    expect(page).to have_content('Job Opening Test 123')
    click_on 'Job Opening Test 123'
    
    click_on 'Apply for this Job'
    expect(page).to have_content('Applied User Email: usuario@disco1995.com.br')
    expect(page).to have_content('Job Opening Test 123')
  end

end