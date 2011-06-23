class AddYearToLetters < ActiveRecord::Migration
  def self.up
    add_column :letters, :year, :int
    add_index :letters, :year
    Letter.all.each do |l|
      l.year = l.received.year
      l.save!
    end
  end

  def self.down
    remove_column :letters, :year
  end
end
