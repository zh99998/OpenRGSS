class Bitmap
  attr_accessor :font, :entity

  def initialize(width, height=nil)
    @entity = if width.is_a? String
      filename = width
      filepath = RGSS.get_file(filename)
      Log.debug('load bitmap') { filepath }
      SDL::Surface.load(filepath).display_format_alpha
    else
      SDL::Surface.new(SDL::SWSURFACE|SDL::SRCALPHA, width, height, 32, 0xff000000, 0x00ff0000, 0x0000ff00, 0x000000ff)
    end
    @font   = Font.new
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
    if x.is_a? Rect
      rect   = x
      color  = y
      x      = rect.x
      y      = rect.y
      width  = rect.width
      height = rect.height
    end
    @entity.fill_rect(x, y, width, height, color.alpha<<24|color.red<<16|color.green<<8|color.blue)
  end

  def defgradient_fill_rect(x, y, width, height=false, color1=nil, color2=nil, vertical=false)

  end

  def clear

  end

  def clear_rect(x, y=nil, width=nil, height=nil)

  end

  def get_pixel(x, y)
    Color.new(255, 255, 255)
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
    if x.is_a? Rect
      rect  = x
      str   = y
      align = width

      x      = rect.x
      y      = rect.y
      width  = rect.width
      height = rect.height
    end
    @font.entity.draw_solid_utf8(@entity, str, x, y, @font.color.red, @font.color.green, @font.color.blue)
  end

  def text_size(str)

  end
end