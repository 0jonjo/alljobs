require 'rails_helper'

describe 'Admin acess admin page and edit an admin' do
  it 'with sucess' do
    admin = Admin.create!(:email => 'admin@test.com', :password => 'test123')
    admin2 = Admin.create!(:email => 'admin2@test.com', :password => 'test123')
    login_as(admin, :scope => :admin)
    
    visit rails_admin.delete_path(model_name: 'admin', id: admin2.id)

    
    click_on I18n.t('admin.form.confirmation')

    expect(current_path).to eq(rails_admin.index_path(model_name: 'admin'))
    expect(page.find('.alert')).to have_content("#{Admin.model_name.human} #{I18n.t('admin.actions.delete.done')} com sucesso")
    # In future can be usefull test with complete successful Rails_Admin message
    # adapted to use Model and action. 
  end

  it 'with sucess - delete yourself' do
    admin = Admin.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(admin, :scope => :admin)
    
    visit rails_admin.delete_path(model_name: 'admin', id: admin.id)

    
    click_on I18n.t('admin.form.confirmation')

    expect(current_path).to eq(admin_session_path)
    expect(page.find('.alert')).to have_content(I18n.t('devise.failure.unauthenticated'))
  end
end  