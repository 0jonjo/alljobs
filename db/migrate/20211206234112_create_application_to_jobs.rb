class CreateApplicationToJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :application_to_jobs do |t|
      t.jobs :reference, index: true, foreign_key: true
      t.users :reference, index: true, foreign_key: true
      t.boolean :application-user
      t.boolean :accepted-headhunter
      t.text :feedback-headhunter

      t.timestamps
    end
  end
end
