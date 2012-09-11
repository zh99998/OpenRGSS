class Sprite
  attr_accessor :bitmap, :src_rect, :viewport, :visible, :x, :y, :z, :ox, :oy, :zoom_x, :zoom_y, :angle, :wave_amp, :wave_length, :wave_speed, :wave_phase, :mirror, :bush_depth, :bush_opacity, :opacity, :blend_type, :color, :tone
  @@all = []

  def initialize(viewport=nil)
    @src_rect = Rect.new(0, 0, 0, 0)
    @x = 0
    @y = 0
    @ox = 0
    @oy = 0
    @zoom_x = 1
    @zoom_y = 1
    @angle = 0
    @src_rect = Rect.new
    self.z = 0
  end

  def dispose
    @disposed = true
    @@all.delete self
  end

  def z=(z)
    @z = z
    return if @disposed
    @@all.delete self
    @@all.each_with_index do |sprite, index|
      @@all.insert(index, sprite) if sprite.z > @z or (sprite.z == @z and sprite.y > @y)
      return @z
    end
    @@all << self
    @z
  end

  def disposed?
    @disposed
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

  def self.all
    @@all
  end
end