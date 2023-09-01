# frozen_string_literal: true

class CreateApplies < ActiveRecord::Migration[6.1]
  def change
    create_table :applies do |t|
      t.references :job, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :application_user
      t.boolean :accepted_headhunter
      t.text :feedback_headhunter

      t.timestamps
    end
  end
end
