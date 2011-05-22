class Index < ActiveRecord::Base
  has_one :relation, :class_name => 'Index', :foreign_key => 'relation_id'
end