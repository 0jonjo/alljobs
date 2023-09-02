# frozen_string_literal: true

class SalaryToBeInteger < ActiveRecord::Migration[6.1]
  def change
    change_column :jobs, :salary, :integer
  end
end
