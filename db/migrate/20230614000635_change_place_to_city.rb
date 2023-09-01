# frozen_string_literal: true

class ChangePlaceToCity < ActiveRecord::Migration[6.1]
  def change
    remove_column :jobs, :place
    add_column :jobs, :city, :string
    add_column :profiles, :city, :string
  end
end
