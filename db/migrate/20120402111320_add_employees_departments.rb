# -*- encoding : utf-8 -*-
class AddEmployeesDepartments < ActiveRecord::Migration
  def change
    add_column :employees, :department_ka, :string
    add_column :employees, :department_ru, :string
  end
end
