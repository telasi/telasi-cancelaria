# -*- encoding : utf-8 -*-
class Status < ActiveRecord::Base
  validates_presence_of :name, :image
  validates_numericality_of :order_by

  def image_path
    "16x16/#{image}.png"
  end

  def to_s
    self.name
  end

end
