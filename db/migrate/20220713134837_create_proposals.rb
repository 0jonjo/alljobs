# frozen_string_literal: true

class CreateProposals < ActiveRecord::Migration[6.1]
  def change
    create_table :proposals do |t|
      t.references :apply, null: false, foreign_key: true
      t.decimal :salary
      t.string :benefits
      t.string :expectations
      t.date :expected_start

      t.timestamps
    end
  end
end
