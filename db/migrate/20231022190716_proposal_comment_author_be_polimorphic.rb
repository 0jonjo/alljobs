# frozen_string_literal: true

class ProposalCommentAuthorBePolimorphic < ActiveRecord::Migration[7.1]
  def change
    remove_column :proposal_comments, :author
    add_reference :proposal_comments, :author, polymorphic: true, index: true
  end
end
