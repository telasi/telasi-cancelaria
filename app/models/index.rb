# encoding: utf-8
class Index < ActiveRecord::Base
  has_one :relation, :class_name => 'Index', :foreign_key => 'relation_id'
  validates_presence_of :prefix, :description
  validates_numericality_of :last_number

  def to_s
    prefix
  end
end
