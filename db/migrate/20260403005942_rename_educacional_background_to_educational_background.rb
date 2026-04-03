class RenameEducacionalBackgroundToEducationalBackground < ActiveRecord::Migration[8.1]
  def change
    rename_column :profiles, :educacional_background, :educational_background
  end
end
