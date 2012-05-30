# -*- encoding : utf-8 -*-
class Report < Prawn::Document
  def initialize(map = {:page_size => 'A4', :bottom_margin => 50})
    super map
  end
end
