# -*- encoding : utf-8 -*-
class UserIndex < ActiveRecord::Base
  belongs_to :user
  belongs_to :index
end
