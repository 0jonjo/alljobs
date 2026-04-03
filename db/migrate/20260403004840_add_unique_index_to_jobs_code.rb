class AddUniqueIndexToJobsCode < ActiveRecord::Migration[8.1]
  def change
    add_index :jobs, :code, unique: true
  end
end
