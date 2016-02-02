class RenameMarcfields < ActiveRecord::Migration
  def change
    rename_table :marc_fields, :originals
  end
end
