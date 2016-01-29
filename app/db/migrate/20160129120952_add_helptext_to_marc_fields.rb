class AddHelptextToMarcFields < ActiveRecord::Migration
  def change
    add_column :marc_fields, :helptext, :text
  end
end
