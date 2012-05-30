# -*- encoding : utf-8 -*-
class LetterEmployee < ActiveRecord::Base
  belongs_to :letter
  belongs_to :employee
end
