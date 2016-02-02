class RemoveMarcFieldIdFromFacilities < ActiveRecord::Migration
  def change
    remove_column :translations, :marc_field_id, :number
  end
end
