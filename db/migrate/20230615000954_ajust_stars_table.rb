class AjustStarsTable < ActiveRecord::Migration[6.1]
  def change
    remove_column :stars, :profile_id
    remove_column :comments, :datetime
  end
end
