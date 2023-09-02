# frozen_string_literal: true

class ChangeToSalaryDecimalInJob < ActiveRecord::Migration[6.1]
  def change
    change_column :jobs, :salary, :decimal
  end
end
