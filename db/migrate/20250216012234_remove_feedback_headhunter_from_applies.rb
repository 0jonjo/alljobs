# frozen_string_literal: true

class RemoveFeedbackHeadhunterFromApplies < ActiveRecord::Migration[7.2]
  def change
    remove_column :applies, :feedback_headhunter
  end
end
