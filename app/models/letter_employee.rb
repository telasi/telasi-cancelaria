class LetterEmployee < ActiveRecord::Base
  belongs_to :letter
  belongs_to :employee
end
