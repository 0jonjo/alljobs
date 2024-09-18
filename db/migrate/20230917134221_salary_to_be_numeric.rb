# frozen_string_literal: true

class SalaryToBeNumeric < ActiveRecord::Migration[6.1]
  def change
    change_column :jobs, :salary,
                  'numeric USING CAST(salary AS numeric)'
  end
end
