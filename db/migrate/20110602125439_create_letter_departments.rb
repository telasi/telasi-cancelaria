class CreateLetterDepartments < ActiveRecord::Migration
  def self.up
    create_table :letter_departments do |t|
      t.references :letter
      t.references :department

      t.timestamps
    end
    add_index :letter_departments, [:letter_id, :department_id]
  end

  def self.down
    drop_table :letter_departments
  end
end
