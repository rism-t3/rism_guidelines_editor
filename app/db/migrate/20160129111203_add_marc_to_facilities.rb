class AddMarcToFacilities < ActiveRecord::Migration
  def change
    add_reference :facilities, :marc_field, index: true
  end
end
