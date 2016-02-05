class ChangeColumnHelptextOfTranslationsToContent < ActiveRecord::Migration
  def change
    rename_column :translations, :help_text, :content
  end
end
