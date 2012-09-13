class Viewport
  attr_accessor :rect, :visible, :x, :y, :z, :ox, :oy, :color, :tone

  def initialize(*args)
    @tone  = Tone.new
    @color = Color.new
    @rect  = Rect.new *args
  end

  def dispose
    @disposed = true
  end

  def disposed?
    @disposed
  end

  def flash(color, duration)

  end

  def update

  end

end