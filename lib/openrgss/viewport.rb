class Viewport
  #The box (Rect) defining the viewport.
  attr_accessor :rect

  # The viewport's visibility. If TRUE, the viewport is visible. The default is TRUE.
  attr_accessor :visible

  # The viewport's z-coordinate. The larger the value, the closer to the player the plane will be displayed.
  #
  # If multiple objects share the same z-coordinate, the more recently created object will be displayed closest to the player.

  attr_accessor :z

  # The x-coordinate of the viewport's starting point. Change this value to shake the screen, etc.
  attr_accessor :ox

  # The y-coordinate of the viewport's starting point. Change this value to shake the screen, etc.
  attr_accessor :oy

  # The color (Color) to be blended with the viewport. Alpha values are used in the blending ratio.
  #
  # Handled separately from the color blended into a flash effect.
  attr_accessor :color

  # The viewport's color tone (Tone).
  attr_accessor :tone

  attr_accessor :created_at

  # :call-seq:
  # Viewport.new(x, y, width, height)
  # Viewport.new(rect)
  # Viewport.new (RGSS3)
  #
  # Creates a viewport object.
  #
  # Same size as the screen if no argument is specified.

  def initialize(*args)
    @tone       = Tone.new
    @color      = Color.new
    @rect       = args.empty? ? Rect.new(0, 0, Graphics.width, Graphics.height) : Rect.new(*args)
    @created_at = Time.now
    @z          = 0
    @ox         = 0
    @oy         = 0
  end

  # Frees the viewport. If the viewport has already been freed, does nothing.
  #
  # This operation will not result in a separate associated object being automatically freed.

  def dispose
    @disposed = true
  end

  # Returns TRUE if the viewport has been freed.

  def disposed?
    @disposed
  end

  # Begins flashing the viewport. duration specifies the number of frames the flash will last.
  #
  # If color is set to nil, the viewport will disappear while flashing.

  def flash(color, duration)

  end
  # Refreshes the viewport flash. As a rule, this method is called once per frame.
  #
  # It is not necessary to call this method if no flash effect is needed.

  def update

  end

  def z=(z)
    @z = z
    RGSS.resources.select { |resource| resource.viewport == self }.each { |resource| resource.visible = resource.visible }
  end
end