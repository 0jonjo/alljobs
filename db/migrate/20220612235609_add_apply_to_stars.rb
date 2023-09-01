# frozen_string_literal: true

class AddApplyToStars < ActiveRecord::Migration[6.1]
  def change
    add_reference :stars, :apply, null: false, foreign_key: true
  end
end
