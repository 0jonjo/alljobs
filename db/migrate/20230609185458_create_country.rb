# frozen_string_literal: true

class CreateCountry < ActiveRecord::Migration[6.1]
  def change
    create_table :countries do |t|
      t.text :acronym
      t.text :name
      t.timestamps
    end
  end
end
