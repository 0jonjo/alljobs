class RemoveApplicationUserAcceptedHeadHunter < ActiveRecord::Migration[6.1]
  def change
    remove_column :applies, :application_user
    remove_column :applies, :accepted_headhunter
    add_column :proposals, :user_accepted, :boolean
  end
end
