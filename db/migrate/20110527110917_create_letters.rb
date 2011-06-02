class CreateLetters < ActiveRecord::Migration
  def self.up
    create_table :letters do |t|
      t.string :own_number
      t.string :number
      t.references :index
      t.references :status
      t.date :received
      t.date :sent
      t.string :description
      t.string :name
      t.string :phone
      t.string :address
      t.string :custnumb

      t.timestamps
    end
    add_index :letters, :index_id
    add_index :letters, :status_id
  end

  def self.down
    drop_table :letters
  end
end
