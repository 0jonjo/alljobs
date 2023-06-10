class CreateProposalComments < ActiveRecord::Migration[6.1]
  def change
    create_table :proposal_comments do |t|
      t.text :body
      t.integer :author
      t.references :proposal, null: false, foreign_key: true
      t.timestamps
    end
  end
end
