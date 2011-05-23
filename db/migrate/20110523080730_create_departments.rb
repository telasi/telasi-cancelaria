class CreateDepartments < ActiveRecord::Migration
  def self.up
    create_table :departments do |t|
      t.string :name
      t.string :name_ru
      t.string :boss
      t.string :boss_ru
      t.string :salutation
      t.string :salutation_ru
      t.integer :order_by
      t.boolean :print

      t.timestamps
    end
    add_index :departments, :order_by
  end

  def self.down
    drop_table :departments
  end
end
