class Bitmap
  attr_accessor :font

  def initialize(width, height=nil)

  end

  def dispose

  end

  def disposed?

  end

  def width

  end

  def height

  end

  def rect

  end

  def blt(x, y, src_bitmap, src_rect, opacity=255)

  end

  def stretch_blt(dest_rect, src_bitmap, src_rect, opacity=255)

  end

  def fill_rect(x, y, width=nil, height=nil, color=nil)

  end

  def defgradient_fill_rect(x, y, width, height=false, color1=nil, color2=nil, vertical=false)

  end

  def clear

  end

  def clear_rect(x, y=nil, width=nil, height=nil)

  end

  def get_pixel(x, y)

  end

  def set_pixel(x, y, color)

  end

  def hue_change(hue)

  end

  def blur

  end

  def radial_blur(angle, division)

  end

  def draw_text(x, y, width=0, height=nil, str=nil, align=0)

  end

  def text_size(str)

  end
end