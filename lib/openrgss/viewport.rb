class Viewport
  attr_accessor :rect, :visible, :z, :ox, :oy, :color, :tone

  def initialize(*args)
    @tone  = Tone.new
    @color = Color.new
    args = [0, 0, Graphics.width, Graphics.height] if args.empty?
    @rect = Rect.new *args
  end

  def x
    @rect.x
  end

  def x=(x)
    @rect.x = x
  end

  def y
    @rect.y
  end

  def y=(y)
    @rect.y = y
  end

  def width
    @rect.width
  end

  def width=(width)
    @rect.width = width
  end

  def height
    @rect.height
  end

  def height=(height)
    @rect.height = height
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