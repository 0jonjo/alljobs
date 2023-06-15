class CreateFeedbackApply < ActiveRecord::Migration[6.1]
  def change
    create_table :feedback_applies do |t|
      t.text :body
      t.references :headhunter, null: false, foreign_key: true
      t.references :apply, null: false, foreign_key: true
      t.timestamps
    end
  end
end
