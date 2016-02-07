class AddTranslationIdToOriginals < ActiveRecord::Migration
  def change
    add_reference :originals, :original, index: true
  end
end
