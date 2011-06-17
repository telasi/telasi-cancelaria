class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :hashed_password
      t.string :salt
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.boolean :admin
      t.boolean :canc_empl
      t.references :department

      t.timestamps
    end
    add_index :users, :name
    add_index :users, :department_id
  end

  def self.down
    drop_table :users
  end
end
