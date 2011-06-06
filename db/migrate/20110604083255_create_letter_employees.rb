class CreateLetterEmployees < ActiveRecord::Migration
  def self.up
    create_table :letter_employees do |t|
      t.references :letter
      t.references :employee

      t.timestamps
    end
    add_index :letter_employees, [:letter_id, :employee_id]
  end

  def self.down
    drop_table :letter_employees
  end
end
