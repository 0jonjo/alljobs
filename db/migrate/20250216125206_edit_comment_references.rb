# frozen_string_literal: true

class EditCommentReferences < ActiveRecord::Migration[7.2]
  def change
    remove_reference :comments, :profile, foreign_key: true
    remove_reference :comments, :headhunter, foreign_key: true

    add_reference :comments, :author, polymorphic: true, index: true
  end
end
