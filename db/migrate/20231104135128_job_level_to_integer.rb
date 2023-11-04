class JobLevelToInteger < ActiveRecord::Migration[7.1]
  def change
    change_column :jobs, :level,
    'integer USING CAST(level AS integer)'
  end
end
