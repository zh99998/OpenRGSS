class Bitmap
  attr_accessor :font, :entity

  def initialize(width, height=nil)
    @entity = if width.is_a? String
      filename = width
      filepath = RGSS.get_file(filename)
      Log.debug('load bitmap') { filepath }
      SDL::Surface.load(filepath).display_format_alpha
    else
      big_endian = ([1].pack("N") == [1].pack("L"))
      if big_endian
        rmask = 0xff000000
        gmask = 0x00ff0000
        bmask = 0x0000ff00
        amask = 0x000000ff
      else
        rmask = 0x000000ff
        gmask = 0x0000ff00
        bmask = 0x00ff0000
        amask = 0xff000000
      end
      SDL::Surface.new(SDL::SWSURFACE|SDL::SRCALPHA, width, height, 32, rmask, gmask, bmask, amask)
    end
    @font   = Font.new
  end

  def dispose
    @entity.destroy
  end

  def disposed?
    @entity.destroyed?
  end

  def width
    @entity.w
  end

  def height
    @entity.h
  end

  def rect
    Rect.new(0, 0, width, height)
  end

  def blt(x, y, src_bitmap, src_rect, opacity=255)
    src_bitmap.entity.set_alpha(SDL::RLEACCEL, opacity)
    SDL::Surface.blit(src_bitmap.entity, src_rect.x, src_rect.y, src_rect.width, src_rect.height, @entity, x, y)
    src_bitmap.entity.set_alpha(SDL::SRCALPHA|SDL::RLEACCEL, 255)
  end

  def stretch_blt(dest_rect, src_bitmap, src_rect, opacity=255)
    src_bitmap.entity.set_alpha(SDL::RLEACCEL, opacity)
    SDL::Surface.transform_blit(src_bitmap.entity, @entity, 0, src_rect.width.to_f / dest_rect.width, src_rect.height.to_f / dest_rect.height, src_rect.x, src_rect.y, dest_rect.x, dest_rect.y, SDL::Surface::TRANSFORM_AA)
    src_bitmap.entity.set_alpha(SDL::SRCALPHA|SDL::RLEACCEL, 255)
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
    @entity.fill_rect(x, y, width, height, @entity.map_rgba(color.red, color.green, color.blue, color.alpha))
  end

  def gradient_fill_rect(x, y, width, height=false, color1=nil, color2=nil, vertical=false)
    if x.is_a? Rect
      rect     = x
      color1   = y
      color2   = width
      vertical = height
      x        = rect.x
      y        = rect.y
      width    = rect.width
      height   = rect.height
    end
    if vertical
      height.times do |i|
        @entity.fill_rect(x, y+i, width, 1, @entity.map_rgba(
            color1.red + (color2.red - color1.red) * i / height,
            color1.green + (color2.green - color1.green) * i / height,
            color1.blue + (color2.blue - color1.blue) * i / height,
            color1.alpha + (color2.alpha - color1.alpha) * i / height
        ))
      end
    else
      width.times do |i|
        @entity.fill_rect(x+i, y, 1, height, @entity.map_rgba(
            color1.red + (color2.red - color1.red) * i / width,
            color1.green + (color2.green - color1.green) * i / width,
            color1.blue + (color2.blue - color1.blue) * i / width,
            color1.alpha + (color2.alpha - color1.alpha) * i / width
        ))
      end
    end
  end

  def clear
    @entity.fill_rect(0, 0, width, height, 0x00000000)
  end

  def clear_rect(x, y=nil, width=nil, height=nil)
    @entity.fill_rect(x, y, width, height, 0x00000000)
  end

  def get_pixel(x, y)
    color = @entity.get_pixel(x, y)
    Color.new((color & @entity.Rmask) >> @entity.Rshift, (color & @entity.Gmask) >> @entity.Gshift, (color & @entity.Bmask) >> @entity.Bshift, (color & @entity.Amask) >> @entity.Ashift)
  end

  def set_pixel(x, y, color)
    @entity.put_pixel(x, y, @entity.map_rgba(color.red, color.green, color.blue, color.alpha))
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

    str = str.to_s
    if align == 2
      x += width - @font.entity.text_size(str)[0]
    elsif align == 1
      x += (width - @font.entity.text_size(str)[0]) / 2
    end
    @font.entity.draw_solid_utf8(@entity, str, x, y, @font.color.red, @font.color.green, @font.color.blue)
  end

  def text_size(str)
    Rect.new 0, 0, *@font.entity.text_size(str)
  end
end