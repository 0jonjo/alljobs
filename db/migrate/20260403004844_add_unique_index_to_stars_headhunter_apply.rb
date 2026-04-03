class AddUniqueIndexToStarsHeadhunterApply < ActiveRecord::Migration[8.1]
  def change
    add_index :stars, %i[headhunter_id apply_id], unique: true
  end
end
