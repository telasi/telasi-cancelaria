# -*- encoding : utf-8 -*-
class LetterDepartment < ActiveRecord::Base
  belongs_to :letter
  belongs_to :department
end
