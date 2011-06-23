class Letter < ActiveRecord::Base
  belongs_to :index
  belongs_to :status
  has_many :letter_departments, :dependent => :destroy
  has_many :letter_employees, :dependent => :destroy
  has_many :departments, :through => :letter_departments
  has_many :employees, :through => :letter_employees
  validates_presence_of :number, :description, :name
  
  def self.years
    [2010, 2011]
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

end
