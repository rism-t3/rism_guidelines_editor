class ChangeColumnHelptextOfOriginalsToContent < ActiveRecord::Migration
  def change
    rename_column :originals, :helptext, :content
  end
end
