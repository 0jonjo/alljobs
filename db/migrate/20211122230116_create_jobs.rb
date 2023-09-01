# frozen_string_literal: true

class CreateJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :jobs do |t|
      t.string :title
      t.text :description
      t.text :skills
      t.string :salary
      t.string :company
      t.string :level
      t.string :place
      t.date :date

      t.timestamps
    end
  end
end
