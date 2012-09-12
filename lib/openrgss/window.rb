class Window
  include RGSS::Drawable
  attr_accessor :windowskin, :contents, :cursor_rect, :viewport, :active, :arrows_visible, :pause, :width, :height, :ox, :oy, :padding, :padding_bottom, :opacity, :back_opacity, :contents_opacity, :tone
  attr_reader :openness

  def initialize(x=0, y=0, width=0, height=0)
    @x            = x
    @y            = y
    @z            = 0
    @ox           = 0
    @oy           = 0
    @width        = width
    @height       = height
    @tone         = Tone.new
    @contents     = Bitmap.new(32, 32)
    @cursor_rect  = Rect.new
    @back_opacity = 255
    @active       = true
    @openness     = 255

    @cursor_status = 0
    self.visible   = true
  end

  def update
    if active
      @cursor_status = (@cursor_status + 4) % 511
    else
      @cursor_status = 0
    end

  end

  def move(x, y, width, height)

  end

  def open?
    openness == 255
  end

  def close?
    openness == 0
  end

  def openness=(openness)
    @openness = openness < 0 ? 0 : openness > 255 ? 255 : openness
  end

  def draw(destination=Graphics)
    destination.entity.fill_rect(@x-@ox, @y-@oy, @width, @height, 0x0000FF | back_opacity << 24)
    SDL::Surface.blit(@contents.entity, 0, 0, @contents.width, @contents.height, destination.entity, @x-@ox+8, @y-@oy+8)
    cursor_color = (255 - @cursor_status).abs
    destination.entity.draw_rect(@x-@ox+8+cursor_rect.x, @y-@oy+8+cursor_rect.y, cursor_rect.width, cursor_rect.height, 0xFF | cursor_color << 8 | cursor_color << 16)
  end
end