class String
  def usubstr(a, b)
    i = 0
    buff = ''
    each_char do | c |
      i += 1
      if i >= a: buff += c end
      if i == b: return buff end
    end
  end
end