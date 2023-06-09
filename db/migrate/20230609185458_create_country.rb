class CreateCountry < ActiveRecord::Migration[6.1]
  def change
    create_table :countries do |t|
      t.string :acronym
      t.string :name
      t.timestamps
    end
  end
end
