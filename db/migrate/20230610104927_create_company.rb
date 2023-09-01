# frozen_string_literal: true

class CreateCompany < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :description
      t.string :website
      t.string :email
      t.string :phone
      t.timestamps
    end
  end
end
