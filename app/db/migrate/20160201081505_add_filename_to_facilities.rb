class AddFilenameToFacilities < ActiveRecord::Migration
  def change
    add_column :facilities, :filename, :string
  end
end
