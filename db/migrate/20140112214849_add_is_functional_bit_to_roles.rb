class AddIsFunctionalBitToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :is_functional, :boolean, default: true
  end
end
