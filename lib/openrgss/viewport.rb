class Viewport
  attr_accessor :rect, :visible, :z, :ox, :oy, :color, :tone

  def initialize(*args)
    @tone  = Tone.new
    @color = Color.new
    @rect  = Rect.new *args
  end

  def dispose

  end

  def disposed?

  end

  def flash(color, duration)

  end

  def update

  end

end