# frozen_string_literal: true

class DropProposalComments < ActiveRecord::Migration[7.2]
  def change
    drop_table :proposal_comments
  end
end
