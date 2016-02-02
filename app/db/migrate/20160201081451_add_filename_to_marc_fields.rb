class AddFilenameToMarcFields < ActiveRecord::Migration
  def change
    add_column :marc_fields, :filename, :string
  end
end
