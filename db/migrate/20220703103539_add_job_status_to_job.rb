# frozen_string_literal: true

class AddJobStatusToJob < ActiveRecord::Migration[6.1]
  def change
    add_column :jobs, :job_status, :integer, default: 1
  end
end
