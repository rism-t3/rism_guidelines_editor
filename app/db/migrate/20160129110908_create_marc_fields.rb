class CreateMarcFields < ActiveRecord::Migration
  def change
    create_table :marc_fields do |t|
      t.string :tag

      t.timestamps
    end
  end
end
