class Bitmap
  attr_accessor :font, :entity

  def initialize(width, height=nil)
    @entity = if width.is_a? String
      filename = width
      SDL::Surface.load(RGSS.get_file(filename)).display_format_alpha
    else
      SDL::Surface.new(SDL::SWSURFACE, width, height, 32, 0xff000000, 0x00ff0000, 0x0000ff00, 0x000000ff)
    end
  end

  def dispose

  end

  def disposed?

  end

  def width
    @entity.w
  end

  def height
    @entity.h
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