# The bitmap class. Bitmaps represent images.
#
# Sprites (Sprite) and other objects must be used to display bitmaps onscreen.

class Bitmap
  attr_accessor :font, :entity, :text

  # :call-seq:
  #  Bitmap.new(filename)
  #  Bitmap.new(width, height)
  #
  # Loads the graphic file specified in filename or size and creates a bitmap object.
  #
  # Also automatically searches files included in RGSS-RTP and encrypted archives. File extensions may be omitted.

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
    # @text = [] ~
  end

  # Frees the bitmap. If the bitmap has already been freed, does nothing.

  def dispose
    @entity.destroy
  end

  # Returns true if the bitmap has been freed.

  def disposed?
    @entity.destroyed?
  end

  # Gets the bitmap width.

  def width
    @entity.w
  end

  # Gets the bitmap height.

  def height
    @entity.h
  end

  # Gets the bitmap rectangle (Rect).

  def rect
    Rect.new(0, 0, width, height)
  end

  def clone
    b        =Bitmap.new(width, height)
    b.entity = @entity.copyRect(0, 0, width, height)
    b.font   =Font.clone
    return b
  end

  # Performs a block transfer from the src_bitmap box src_rect (Rect) to the specified bitmap coordinates (x, y).
  #
  # opacity can be set from 0 to 255.

  def blt(x, y, src_bitmap, src_rect, opacity=255)
    src_bitmap.entity.set_alpha(SDL::RLEACCEL, opacity)
    SDL::Surface.blit(src_bitmap.entity, src_rect.x, src_rect.y, src_rect.width, src_rect.height, @entity, x, y)
    src_bitmap.entity.set_alpha(SDL::SRCALPHA|SDL::RLEACCEL, 255)
  end

  # Performs a block transfer from the src_bitmap box src_rect (Rect) to the specified bitmap box dest_rect (Rect).
  #
  # opacity can be set from 0 to 255.

  def stretch_blt(dest_rect, src_bitmap, src_rect, opacity=255)
    src_bitmap.entity.set_alpha(SDL::RLEACCEL, opacity)
    SDL::Surface.transform_blit(src_bitmap.entity, @entity, 0, src_rect.width.to_f / dest_rect.width, src_rect.height.to_f / dest_rect.height, src_rect.x, src_rect.y, dest_rect.x, dest_rect.y, SDL::Surface::TRANSFORM_AA)
    src_bitmap.entity.set_alpha(SDL::SRCALPHA|SDL::RLEACCEL, 255)
  end

  # :call-seq:
  # fill_rect(x, y, width, height, color)
  # fill_rect(rect, color)
  #
  # Fills the bitmap box (x, y, width, height) or rect (Rect) with color (Color).

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

  # :call-seq:
  # gradient_fill_rect(x, y, width, height, color1, color2[, vertical])
  # gradient_fill_rect(rect, color1, color2[, vertical])
  #
  # Fills in this bitmap box (x, y, width, height) or rect (Rect) with a gradient from color1 (Color) to color2 (Color).
  #
  # Set vertical to true to create a vertical gradient. Horizontal gradient is the default.

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

  # Clears the entire bitmap.

  def clear
    @entity.fill_rect(0, 0, width, height, 0x00000000)
  end

  # Clears this bitmap box or (x, y, width, height) or rect (Rect).

  def clear_rect(x, y=nil, width=nil, height=nil)
    if x.is_a? Rect
      rect   = x
      x      = rect.x
      y      = rect.y
      width  = rect.width
      height = rect.height
    end
    @entity.fill_rect(x, y, width, height, 0x00000000)
  end

  # Gets the color (Color) at the specified pixel (x, y).

  def get_pixel(x, y)

    color = @entity.format.getRGBA(@entity.get_pixel(x, y))
    return Color.new(color[0], color[1], color[2], color[3])
    #Color.new((color & @entity.Rmask) >> @entity.Rshift, (color & @entity.Gmask) >> @entity.Gshift, (color & @entity.Bmask) >> @entity.Bshift, (color & @entity.Amask) >> @entity.Ashift)
  end

  # Sets the specified pixel (x, y) to color (Color).

  def set_pixel(x, y, color)
    @entity.put_pixel(x, y, @entity.map_rgba(color.red, color.green, color.blue, color.alpha))
  end

  # Changes the bitmap's hue within 360 degrees of displacement.
  #
  # This process is time-consuming. Furthermore, due to conversion errors, repeated hue changes may result in color loss.

  def hue_change(hue)

  end

  # Applies a blur effect to the bitmap. This process is time consuming.

  def blur

  end

  # Applies a radial blur to the bitmap. angle is used to specify an angle from 0 to 360. The larger the number, the greater the roundness.
  #
  # division is the division number (from 2 to 100). The larger the number, the smoother it will be. This process is very time consuming.

  def radial_blur(angle, division)

  end

  # Draws the string str in the bitmap box (x, y, width, height) or rect (Rect).
  #
  # If str is not a character string object, it will be converted to a character string using the to_s method before processing is performed.
  #
  # If the text length exceeds the box's width, the text width will automatically be reduced by up to 60 percent.
  #
  # Horizontal text is left-aligned by default. Set align to 1 to center the text and to 2 to right-align it. Vertical text is always centered.
  #
  # As this process is time-consuming, redrawing the text with every frame is not recommended.

  def draw_text(x, y, width=0, height=nil, str=nil, align=0 )
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

    # @text << [str, x, y, @font.color.red, @font.color.green, @font.color.blue] See you ~
    tmp = @font.entity.render_blended_utf8(str,  @font.color.red, @font.color.green, @font.color.blue)
    tmp.set_alpha(SDL::RLEACCEL ,0)
    @entity.put tmp,x,y
    #SDL::Surface.transformBlit tmp,@entity,0,1,1,0,0,x, y,SDL::Surface::TRANSFORM_AA|SDL::Surface::TRANSFORM_SAFE|SDL::Surface::TRANSFORM_SAFE
  end

  # Gets the box (Rect) used when drawing the string str with the draw_text method. Does not include the outline portion (RGSS3) and the angled portions of italicized text.
  #
  # If str is not a character string object, it will be converted to a character string using the to_s method before processing is performed.

  def text_size(str)
    Rect.new 0, 0, *@font.entity.text_size(str)
  end
end