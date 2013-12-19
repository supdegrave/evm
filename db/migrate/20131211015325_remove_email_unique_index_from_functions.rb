class RemoveEmailUniqueIndexFromFunctions < ActiveRecord::Migration
  def change
    remove_index :functions, :email
  end
end
