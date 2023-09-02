# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.datetime :datetime
      t.text :body
      t.references :profile, null: false, foreign_key: true
      t.references :headhunter, null: false, foreign_key: true

      t.timestamps
    end
  end
end
