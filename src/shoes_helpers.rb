class JSH
  
  def self.color_it(heat)
    r = 0
    g = 0
    b = 0
    if heat < 50
      h = 255.to_f/50.to_f
      r = h * heat
      b = 255 - r
    elsif heat == 100
      g = r = 255
    else
      g = (255.to_f/50.to_f) * (heat - 50)
      r = 255
    end
      
    return r.to_i, g.to_i, b.to_i
  end
end