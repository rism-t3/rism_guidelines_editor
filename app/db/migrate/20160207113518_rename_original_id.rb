class RenameOriginalId < ActiveRecord::Migration
  def change
    rename_column :documents, :original_id, :template_id
  end
end
