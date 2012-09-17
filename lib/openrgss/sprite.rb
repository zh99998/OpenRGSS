# The sprite class. Sprites are the basic concept used to display characters and other objects on the game screen.

class Sprite
  # Refers to the bitmap (Bitmap) used for the sprite's starting point.
  attr_accessor :bitmap

  # The box (Rect) taken from a bitmap.
  attr_accessor :src_rect


  # Refers to the viewport (Viewport) associated with the sprite.
  attr_accessor :viewport

  # The x-coordinate of the sprite's starting point.
  attr_accessor :ox

  # The y-coordinate of the sprite's starting point.
  attr_accessor :oy

  # The sprite's x-axis zoom level. 1.0 denotes actual pixel size.
  attr_accessor :zoom_x

  # The sprite's y-axis zoom level. 1.0 denotes actual pixel size.
  attr_accessor :zoom_y

  # The sprite's angle of rotation. Specifies up to 360 degrees of counterclockwise rotation. However, drawing a rotated sprite is time-consuming, so avoid overuse.
  attr_accessor :angle

  # Defines the amplitude, frequency, speed, and phase of the wave effect. A raster scroll effect is achieved by using a sinusoidal function to draw the sprite with each line's horizontal position slightly different from the last.
  #
  # wave_amp is the wave amplitude and wave_length is the wave frequency, and each is specified by a number of pixels.
  #
  # wave_speed specifies the speed of the wave animation. The default is 360, and the larger the value, the faster the effect.
  #
  # wave_phase specifies the phase of the top line of the sprite using an angle of up to 360 degrees. This is updated each time the update method is called. It is not necessary to use this property unless it is required for two sprites to have their wave effects synchronized.
  attr_accessor :wave_amp
  attr_accessor :wave_length
  attr_accessor :wave_speed
  attr_accessor :wave_phase

  # A flag denoting the sprite has been flipped horizontally. If TRUE, the sprite will be drawn flipped. The default is false.
  attr_accessor :mirror

  # The bush depth and opacity of a sprite. This can be used to represent a situation such as the character's legs being hidden by bushes.
  #
  # For bush_depth, the number of pixels for the bush section is specified. The default value is 0.
  #
  # For bush_opacity, the opacity of the bush section from 0 to 255 is specified. Out-of-range values will be corrected automatically. The default value is 128.
  #
  # The bush_opacity value will be multiplied by opacity. For example, if both opacity and bush_opacity are set to 128, it will be handled as a transparency on # top of a transparency, for an actual opacity of 64.
  attr_accessor :bush_depth
  attr_accessor :bush_opacity

  # The sprite's opacity (0-255). Out-of-range values are automatically corrected.
  attr_accessor :opacity

  # The sprite's blending mode (0: normal, 1: addition, 2: subtraction).
  attr_accessor :blend_type

  # The color (Color) to be blended with the sprite. Alpha values are used in the blending ratio.
  #
  # Handled separately from the color blended into a flash effect. However, the color with the higher alpha value when displayed will have the higher priority when blended.
  attr_accessor :color

  # The sprite's color tone (Tone).
  attr_accessor :tone

  include RGSS::Drawable

  # Creates a new sprite object. Specifies a viewport (Viewport) when necessary.

  def initialize(viewport=nil)
    @src_rect = Rect.new(0, 0, 0, 0)
    @x        = 0
    @y        = 0
    @z        = 0
    @ox       = 0
    @oy       = 0
    @zoom_x   = 1
    @zoom_y   = 1
    @angle    = 0
    @src_rect = Rect.new
    @color    = Color.new
    @tone     = Tone.new
    @opacity  = 255
    @visible  = true
    super(viewport)
  end

  def bitmap=(bitmap)
    @src_rect.set(0, 0, bitmap.width, bitmap.height) if bitmap
    @bitmap = bitmap
  end

  # Begins flashing the sprite. duration specifies the number of frames flashing will last.
  #
  # If color is set to nil, the sprite will disappear while flashing.

  def flash(color, duration)

  end

  # Advances the sprite flash or wave phase. As a general rule, this method is called once per frame.
  #
  # It is not necessary to call this if a flash or wave is not needed.

  def update

  end

  # Gets the width of the sprite. Equivalent to src_rect.width.
  def width
    bitmap.width
  end

  # Gets the height of the sprite. Equivalent to src_rect.height.
  def height
    bitmap.height
  end

  def draw(destination=Graphics)
    return unless bitmap and opacity > 0

    base_x = @x-@ox
    base_y = @y-@oy
    if viewport
      destination.entity.set_clip_rect(viewport.rect.x, viewport.rect.y, viewport.rect.width, viewport.rect.height)
      base_x += viewport.rect.x - viewport.ox
      base_y += viewport.rect.y - viewport.oy
    end

    SDL::Surface.blit(@bitmap.entity, @src_rect.x, @src_rect.y, @src_rect.width, @src_rect.height, destination.entity, base_x, base_y)
    destination.entity.set_clip_rect(0, 0, destination.width, destination.height) if viewport
  end
end