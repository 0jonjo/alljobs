require 'rails_helper'

describe 'Admin acess admin page and create admin' do
  it 'with sucess' do
    admin = Admin.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(admin, :scope => :admin)
    
    visit rails_admin.new_path(model_name: 'admin')

    fill_in 'Email', with: 'admin2@test.com'
    fill_in 'Password', with: 'test123'
    fill_in 'Password confirmation', with: 'test123'
    click_on 'Salvar'

    expect(current_path).to eq(rails_admin.index_path(model_name: 'admin'))
    expect(page.find('.alert')).to have_content("#{Admin.model_name.human} #{I18n.t('admin.actions.new.done')} com sucesso")
    # In future can be usefull test with complete successful Rails_Admin message
    # adapted to use Model and action. 
  end

  it 'without sucess - repeated email' do
    admin = Admin.create!(:email => 'admin@test.com', :password => 'test123')
    admin2 = Admin.create!(:email => 'admin2@test.com', :password => 'test123')
    login_as(admin, :scope => :admin)
    
    visit rails_admin.new_path(model_name: 'admin')

    fill_in 'Email', with: 'admin2@test.com'
    fill_in 'Password', with: 'test123'
    fill_in 'Password confirmation', with: 'test123'
    click_on 'Salvar'

    expect(current_path).to eq(rails_admin.new_path(model_name: 'admin'))
    expect(page.find('.alert')).to have_content("#{Admin.model_name.human} falhou em ser #{I18n.t('admin.actions.new.done')}")
  end

  it 'without sucess - incomplete' do
    admin = Admin.create!(:email => 'admin@test.com', :password => 'test123')
    login_as(admin, :scope => :admin)
    
    visit rails_admin.new_path(model_name: 'admin')

    fill_in 'Email', with: ''
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: ''
    click_on 'Salvar'

    expect(current_path).to eq(rails_admin.new_path(model_name: 'admin'))
    expect(page.find('.alert')).to have_content("#{Admin.model_name.human} falhou em ser #{I18n.t('admin.actions.new.done')}")
  end
end  