class AddCodeToJobs < ActiveRecord::Migration[6.1]
  def change
    add_column :jobs, :code, :string
  end
end
