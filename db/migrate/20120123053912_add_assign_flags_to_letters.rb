class AddAssignFlagsToLetters < ActiveRecord::Migration
  def change
    add_column :letters, :is_empl_assigned, :boolean
    add_column :letters, :is_dept_assigned, :boolean
  end
end
