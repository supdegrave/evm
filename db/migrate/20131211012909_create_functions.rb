class CreateFunctions < ActiveRecord::Migration
  def change
    create_table :functions do |t|
      t.string :name, :null => false, :default => ""
      t.string :email, :null => false, :default => ""

      t.timestamps
    end
    
    add_index :functions, :name, :unique => true
    add_index :functions, :email, :unique => true
  end
end
