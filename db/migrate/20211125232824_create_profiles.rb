# frozen_string_literal: true

class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.text :name
      t.text :social_name
      t.date :birthdate
      t.text :description
      t.text :educacional_background
      t.text :experience
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
