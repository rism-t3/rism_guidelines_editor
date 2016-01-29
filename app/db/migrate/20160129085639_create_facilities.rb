class CreateFacilities < ActiveRecord::Migration
  def change
    create_table :facilities do |t|
      t.string :language
      t.string :name
      t.string :marc_field
      t.string :entity
      t.text :help_text

      t.timestamps
    end
  end
end
