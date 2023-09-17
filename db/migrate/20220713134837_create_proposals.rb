# frozen_string_literal: true

class CreateProposals < ActiveRecord::Migration[6.1]
  def change
    create_table :proposals do |t|
      t.references :apply, null: false, foreign_key: true
      t.numeric :salary
      t.text :benefits
      t.text :expectations
      t.date :expected_start

      t.timestamps
    end
  end
end
