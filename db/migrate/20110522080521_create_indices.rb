# -*- encoding : utf-8 -*-
class CreateIndices < ActiveRecord::Migration
  def self.up
    create_table :indices do |t|
      t.string :prefix
      t.string :description
      t.integer :last_number
      t.references :relation
      t.timestamps
    end
    add_index :indices, :prefix
  end

  def self.down
    drop_table :indices
  end
end
