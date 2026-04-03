class AddStatusToApplies < ActiveRecord::Migration[8.1]
  def change
    add_column :applies, :status, :integer, default: 0, null: false
  end
end
