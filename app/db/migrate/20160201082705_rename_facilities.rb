class RenameFacilities < ActiveRecord::Migration
  def change
    rename_table :facilities, :translations
  end
end
