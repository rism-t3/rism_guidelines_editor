class AddLanguageIdToOriginals < ActiveRecord::Migration
  def change
    add_reference :originals, :language, index: true
  end
end
