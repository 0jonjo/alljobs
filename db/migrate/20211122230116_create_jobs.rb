# frozen_string_literal: true

class CreateJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :jobs do |t|
      t.text :title
      t.text :description
      t.text :skills
      t.text :salary
      t.text :company
      t.text :level
      t.text :place
      t.date :date

      t.timestamps
    end
  end
end
