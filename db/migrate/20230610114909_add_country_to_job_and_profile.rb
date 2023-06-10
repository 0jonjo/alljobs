class AddCountryToJobAndProfile < ActiveRecord::Migration[6.1]
  def change
    add_reference :jobs, :countries, null: true, foreign_key: true
    add_reference :profiles, :countries, null: true, foreign_key: true
  end
end
