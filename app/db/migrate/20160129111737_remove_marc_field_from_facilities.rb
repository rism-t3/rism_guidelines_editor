class RemoveMarcFieldFromFacilities < ActiveRecord::Migration
  def change
    remove_column :facilities, :marc_field, :string
  end
end
