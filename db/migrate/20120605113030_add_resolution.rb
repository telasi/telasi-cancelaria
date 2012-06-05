class AddResolution < ActiveRecord::Migration
  def change
    add_column :letters, :resolution, :text
  end
end
