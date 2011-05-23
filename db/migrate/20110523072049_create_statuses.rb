class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.string :name
      t.string :image
      t.integer :order_by
      t.boolean :update_sent_date

      t.timestamps
    end
    add_index :statuses, :order_by
  end

  def self.down
    drop_table :statuses
  end
end
