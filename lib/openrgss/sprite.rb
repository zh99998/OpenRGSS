class Sprite
  attr_accessor :bitmap, :src_rect, :viewport, :ox, :oy, :zoom_x, :zoom_y, :angle, :wave_amp, :wave_length, :wave_speed, :wave_phase, :mirror, :bush_depth, :bush_opacity, :opacity, :blend_type, :color, :tone
  include RGSS::Drawable

  def initialize(viewport=nil)
    @src_rect    = Rect.new(0, 0, 0, 0)
    @x           = 0
    @y           = 0
    @z           = 0
    @ox          = 0
    @oy          = 0
    @zoom_x      = 1
    @zoom_y      = 1
    @angle       = 0
    @src_rect    = Rect.new
    self.visible = true

  end

  def bitmap=(bitmap)
    @src_rect.set(0, 0, bitmap.width, bitmap.height)
    @bitmap = bitmap
  end

  def flash(color, duration)

  end

  def update

  end

  def width

  end

  def height

  end

  def draw(destination=Graphics)
    SDL::Surface.blit(@bitmap.entity, @src_rect.x, @src_rect.y, @src_rect.width, @src_rect.height, destination.entity, @x-@ox, @y-@oy)
  end
end