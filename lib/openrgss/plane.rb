# The Plane class. Planes are special sprites that tile bitmap patterns across the entire screen and are used to display parallax backgrounds and so on.
class Plane

  # Refers to the bitmap (Bitmap) used in the plane.
  #attr_accessor :bitmap

  # Refers to the viewport (Viewport) associated with the plane.
  #attr_accessor :viewport

  # The plane's visibility. If TRUE, the plane is visible. The default value is TRUE.
  #attr_accessor :visible

  # The plane's z-coordinate. The larger the value, the closer to the player the plane will be displayed.
  #
  # If multiple objects share the same z-coordinate, the more recently created object will be displayed closest to the player.
  #attr_accessor :z

  # The x-coordinate of the plane's starting point. Change this value to scroll the plane.
  attr_accessor :ox

  # The y-coordinate of the plane's starting point. Change this value to scroll the plane.
  attr_accessor :oy

  # The plane's x-axis zoom level. 1.0 denotes actual pixel size.
  #attr_accessor :zoom_x

  # The plane's y-axis zoom level. 1.0 denotes actual pixel size.
  #attr_accessor :zoom_y

  # The plane's opacity (0-255). Out-of-range values are automatically corrected.
  #attr_accessor :opacity

  # The plane's blending mode (0: normal, 1: addition, 2: subtraction).
  #attr_accessor :blend_type

  # The color (Color) to be blended with the plane. Alpha values are used in the blending ratio.
  #attr_accessor :color

  # The plane's color tone (Tone).
  #attr_accessor :tone

  # Creates a Plane object. Specifies a viewport (Viewport) when necessary.
  def initialize(arg_viewport=nil)
    @sprite = Sprite.new(arg_viewport)
    @src_bitmap = nil
  end

  # Frees the plane. If the plane has already been freed, does nothing.

  def dispose
    @sprite.bitmap.dispose unless @sprite.bitmap.nil? or @sprite.bitmap.disposed?
    @sprite.dispose unless @sprite.nil? or @sprite.disposed?
  end

  # Returns TRUE if the plane has been freed.

  def disposed?
    @sprite.nil? or @sprite.disposed?
  end

  #------------------------------------------------------------------------
  # * Auslenkung auf der X Achse setzen
  #------------------------------------------------------------------------
  def ox=(val)
    @sprite.ox= (val % (@src_bitmap.nil? ? 1 : @src_bitmap.width))
  end

  #------------------------------------------------------------------------
  # * Auslenkung auf der Y Achse setzen
  #------------------------------------------------------------------------
  def oy=(val)
    @sprite.oy= (val % (@src_bitmap.nil? ? 1 : @src_bitmap.height))
  end

  #------------------------------------------------------------------------
  # * Mach das Bitmap öffentlich
  #------------------------------------------------------------------------
  def bitmap
    @src_bitmap
  end

  #------------------------------------------------------------------------
  # * Lege ein Bitmap fest
  #------------------------------------------------------------------------
  def bitmap=(arg_bmp)
    vp_width = @sprite.viewport.nil? ? \
                            Graphics.width : @sprite.viewport.rect.width
    vp_height = @sprite.viewport.nil? ? \
                            Graphics.height : @sprite.viewport.rect.height
    x_steps = [(vp_width / arg_bmp.width).ceil, 1].max * 2
    y_steps = [(vp_height / arg_bmp.height).ceil, 1].max * 2

    bmp_width = x_steps * arg_bmp.width
    bmp_height = y_steps * arg_bmp.height

    @src_bitmap = arg_bmp
    @sprite.bitmap.dispose unless @sprite.bitmap.nil? or @sprite.bitmap.disposed?
    @sprite.bitmap = Bitmap.new(bmp_width, bmp_height)

    x_steps.times { |ix| y_steps.times { |iy|
      @sprite.bitmap.blt(ix * arg_bmp.width, iy * arg_bmp.height,
                         @src_bitmap, @src_bitmap.rect)
    } }
  end

  def method_missing(symbol, *args)
    @sprite.method(symbol).call(*args)
  end

end