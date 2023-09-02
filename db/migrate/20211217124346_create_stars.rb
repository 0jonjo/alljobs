# frozen_string_literal: true

class CreateStars < ActiveRecord::Migration[6.1]
  def change
    create_table :stars do |t|
      t.references :headhunter, null: false, foreign_key: true
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
