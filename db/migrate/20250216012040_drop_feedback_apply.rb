# frozen_string_literal: true

class DropFeedbackApply < ActiveRecord::Migration[7.2]
  def change
    drop_table :feedback_applies
  end
end
