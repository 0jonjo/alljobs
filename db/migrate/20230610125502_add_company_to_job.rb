# frozen_string_literal: true

class AddCompanyToJob < ActiveRecord::Migration[6.1]
  def change
    remove_column :jobs, :company
    add_reference :jobs, :company, null: true, foreign_key: true
  end
end
