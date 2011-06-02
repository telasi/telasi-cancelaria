class Employee < ActiveRecord::Base
  validates_presence_of :department, :name
  belongs_to :department
end