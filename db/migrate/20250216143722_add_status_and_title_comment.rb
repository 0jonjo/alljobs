# frozen_string_literal: true

class AddStatusAndTitleComment < ActiveRecord::Migration[7.2]
  def change
    add_column :comments, :status, :integer, default: 0
    add_column :comments, :title, :text, null: true
    add_reference :comments, :apply, foreign_key: true
  end
end
