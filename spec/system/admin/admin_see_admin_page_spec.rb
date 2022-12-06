require 'rails_helper'

describe 'Admin acess admin page' do
  it 'with sucess' do
    admin = Admin.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(admin, :scope => :admin)
    
    visit rails_admin.dashboard_path
    
    expect(current_path).to eq rails_admin.dashboard_path
    expect(page).to have_content(I18n.t('admin.actions.dashboard.title'))
    expect(page).to have_content(I18n.t('admin.misc.navigation'))

    expect(page).to have_link(Comment.model_name.human)
    expect(page).to have_link(Star.model_name.human)
    expect(page).to have_link(Apply.model_name.human)
    expect(page).to have_link(Profile.model_name.human)
    expect(page).to have_link(Proposal.model_name.human)
    expect(page).to have_link(Headhunter.model_name.human)
    expect(page).to have_link(User.model_name.human)
    expect(page).to have_link(Admin.model_name.human)
    expect(page).to have_link(Job.model_name.human)
  end
end  