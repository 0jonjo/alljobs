class AddCountryToJobAndProfile < ActiveRecord::Migration[6.1]
  def change
    add_reference :jobs, :country, null: true, foreign_key: true
    add_reference :profiles, :country, null: true, foreign_key: true
  end
end
