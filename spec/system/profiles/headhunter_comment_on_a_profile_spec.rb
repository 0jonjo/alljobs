# frozen_string_literal: true

require 'rails_helper'

describe 'Headhunter' do
  let(:headhunter) { create(:headhunter) }
  let!(:profile) { create(:profile) }

  before do
    login_as(headhunter, scope: :headhunter)
  end

  context 'comment on a profile' do
    it 'with sucesss' do
      visit profile_path(profile)
      fill_in Comment.human_attribute_name(:body), with: 'Just a test comment'
      click_on 'Criar Comentário'
      expect(page).to have_content('Just a test comment')
      expect(page).to have_content('Comment created.')
    end

    it 'without sucesss' do
      visit profile_path(profile)
      fill_in Comment.human_attribute_name(:body), with: ''
      click_on 'Criar Comentário'
      expect(page).to have_content("Comment can't be created.")
    end
  end

  context 'edit a comment on a profile' do
    let(:headhunter) { create(:headhunter) }
    let!(:profile) { create(:profile) }
    let!(:comment) { create(:comment, profile: profile, headhunter: headhunter) }

    before do
      login_as(headhunter, scope: :headhunter)
    end

    it 'with sucesss' do
      visit profile_path(profile.id)
      click_on 'Editar'
      fill_in Comment.human_attribute_name(:body), with: 'Just another test comment'
      click_on 'Atualizar Comentário'
      expect(page).to have_content('Just another test comment')
      expect(page).to have_content('Comment updated.')
    end
  end

  context 'delete a comment on a profile' do
    let(:headhunter) { create(:headhunter) }
    let!(:profile) { create(:profile) }
    let!(:comment) { create(:comment, profile: profile, headhunter: headhunter) }

    before do
      login_as(headhunter, scope: :headhunter)
    end

    it 'with sucesss' do
      visit profile_path(profile.id)
      click_on 'Apagar'
      expect(page).not_to have_content(comment.body)
      expect(page).to have_content('Comment deleted.')
    end
  end
end
