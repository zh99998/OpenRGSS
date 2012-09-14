class Viewport
  attr_accessor :rect, :visible, :z, :ox, :oy, :color, :tone, :created_at

  def initialize(*args)
    @tone       = Tone.new
    @color      = Color.new
    @rect       = args.empty? ? Rect.new(0, 0, Graphics.width, Graphics.height) : Rect.new(*args)
    @created_at = Time.now
    @z          = 0
    @ox         = 0
    @oy         = 0
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
    RGSS.resources.select { |resource| resource.viewport == self }.each { |resource| resource.visible = resource.visible }
  end

  def z=(z)
    @z = z
    RGSS.resources.select { |resource| resource.viewport == self }.each { |resource| resource.visible = resource.visible }
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