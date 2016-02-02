class AddOriginalToTranslations < ActiveRecord::Migration
  def change
    add_reference :translations, :original, index: true
  end
end
