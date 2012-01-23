# encoding: utf-8
class Letter < ActiveRecord::Base
  belongs_to :index
  belongs_to :status
  has_many :letter_departments, :dependent => :destroy
  has_many :letter_employees, :dependent => :destroy
  has_many :departments, :through => :letter_departments
  has_many :employees, :through => :letter_employees
  validates_presence_of :number, :description, :name
  before_save :derive_year

  def self.years
    years = []
    (2010..Time.now.year).each do |i|
    	years.push(i)
    end
    years
  end

  def received2
    self.received.strftime("%d-%b-%Y") if self.received
  end

  def received2=(dt)
    self.received = dt
  end

  def sent2
    self.sent.strftime("%d-%b-%Y") if self.sent
  end

  def sent2=(dt)
    self.sent = dt
  end

  def review_assignments!
    self.is_empl_assigned = ! self.employees.empty?
    self.is_dept_assigned = ! self.departments.empty?
  end

  private

  def derive_year
    self.year = self.received.year
  end
end
