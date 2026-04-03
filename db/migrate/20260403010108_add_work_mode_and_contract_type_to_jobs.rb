class AddWorkModeAndContractTypeToJobs < ActiveRecord::Migration[8.1]
  def change
    add_column :jobs, :work_mode, :integer, default: 0
    add_column :jobs, :contract_type, :integer, default: 0
  end
end
