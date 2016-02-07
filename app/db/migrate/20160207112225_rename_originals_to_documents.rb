class RenameOriginalsToDocuments < ActiveRecord::Migration
  def change
    rename_table :originals, :documents
  end
end
