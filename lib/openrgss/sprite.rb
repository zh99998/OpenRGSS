class Sprite
  attr_accessor :bitmap, :src_rect, :viewport, :visible, :x, :y, :z, :ox, :oy, :zoom_x, :zoom_y, :angle, :wave_amp, :wave_length, :wave_speed, :wave_phase, :mirror, :bush_depth, :bush_opacity, :opacity, :blend_type, :color, :tone

  def initialize(viewport=nil)
    @src_rect = Rect.new(0, 0, 0, 0)
    @x = 0
    @y = 0
    @z = 0
    @ox = 0
    @oy = 0
    @zoom_x = 1
    @zoom_y = 1
    @angle = 0


  end

  def dispose

  end

  def disposed?

  end

  def flash(color, duration)

  end

  def update

  end

  def width

  end

  def height

  end
end