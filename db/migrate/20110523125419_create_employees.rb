class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.references :department
      t.string :name
      t.string :name_ru
      t.boolean :print
      t.integer :order_by

      t.timestamps
    end
    add_index :employees, :order_by
  end

  def self.down
    drop_table :employees
  end
end
