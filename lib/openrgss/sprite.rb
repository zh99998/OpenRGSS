class Sprite
  attr_accessor :bitmap, :src_rect, :ox, :oy, :zoom_x, :zoom_y, :angle, :wave_amp, :wave_length, :wave_speed, :wave_phase, :mirror, :bush_depth, :bush_opacity, :opacity, :blend_type, :color, :tone
  include RGSS::Drawable

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
    super()
  end

  def bitmap=(bitmap)
    @src_rect.set(0, 0, bitmap.width, bitmap.height) if bitmap
    @bitmap = bitmap
  end

  def flash(color, duration)

  end

  def update

  end

  def width
    bitmap.width
  end

  def height
    bitmap.height
  end

  def draw(destination=Graphics)
    return unless bitmap and opacity > 0

    base_x = @x-@ox
    base_y = @y-@oy
    if viewport
      destination.entity.set_clip_rect(viewport.x, viewport.y, viewport.width, viewport.height)
      base_x += viewport.x
      base_y += viewport.y
    end

    SDL::Surface.blit(@bitmap.entity, @src_rect.x, @src_rect.y, @src_rect.width, @src_rect.height, destination.entity, base_x, base_y)
    destination.entity.set_clip_rect(0, 0, destination.width, destination.height) if viewport
  end
end