# frozen_string_literal: true

class DropProposals < ActiveRecord::Migration[7.2]
  def change
    drop_table :proposals
  end
end
