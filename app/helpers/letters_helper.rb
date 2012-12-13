# -*- encoding : utf-8 -*-
module LettersHelper

  def decorate_description(description)
    if description
      new_description = h(description)
      new_description = new_description.gsub(/\{\{/, '<span style="color: red; font-weight: bold;">').gsub(/\}\}/, '</span>')
      new_description.html_safe
    end
  end

end
