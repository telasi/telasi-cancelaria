# -*- encoding : utf-8 -*-
class CreateUserIndices < ActiveRecord::Migration
  def change
    create_table :user_indices do |t|
      t.references :user
      t.references :index

      t.timestamps
    end
    add_index :user_indices, :user_id
    add_index :user_indices, :index_id
  end
end
