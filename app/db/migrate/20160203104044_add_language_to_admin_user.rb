class AddLanguageToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :language, :string
  end
end
