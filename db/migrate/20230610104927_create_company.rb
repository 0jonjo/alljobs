# frozen_string_literal: true

class CreateCompany < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.text :name, null: false
      t.text :description
      t.text :website
      t.text :email
      t.text :phone
      t.timestamps
    end
  end
end
