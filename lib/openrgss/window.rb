class Window
  include RGSS::Drawable
  attr_accessor :windowskin, :contents, :cursor_rect, :active, :arrows_visible, :pause, :width, :height, :ox, :oy, :padding, :padding_bottom, :opacity, :back_opacity, :contents_opacity, :tone
  attr_reader :openness

  def initialize(x=0, y=0, width=0, height=0)
    @x                = x
    @y                = y
    @z                = 0
    @ox               = 0
    @oy               = 0
    @width            = width
    @height           = height
    @tone             = Tone.new
    @contents         = Bitmap.new(32, 32)
    @cursor_rect      = Rect.new
    @back_opacity     = 255
    @opacity          = 255
    @contents_opacity = 255
    @active           = true
    @openness         = 255
    @padding          = 12
    @padding_bottom   = 12
    @cursor_status    = 0
    @visible          = true
    super()
  end

  def update
    if active
      @cursor_status = (@cursor_status + 4) % 511
    else
      @cursor_status = 0
    end

  end

  def move(x, y, width, height)
    @x      = x
    @y      = y
    @width  = width
    @height = height
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
    return if close?
    base_x = @x-@ox
    base_y = @y-@oy
    if viewport
      destination.entity.set_clip_rect(viewport.x, viewport.y, viewport.width, viewport.height)
      base_x += viewport.x - viewport.ox
      base_y += viewport.y - viewport.oy
    end

    #background
    destination.entity.fill_rect(base_x, base_y+@height*(255-openness)/255/2, @width, @height*openness/255, destination.entity.map_rgba(0, 0, 255, back_opacity)) if back_opacity > 0 and opacity > 0

    #border
    destination.entity.draw_rect(base_x, base_y+@height*(255-openness)/255/2, @width, @height*openness/255, destination.entity.map_rgba(255, 255, 255, opacity)) if opacity > 0

    if open?
      destination.entity.draw_rect(base_x+padding-1, base_y+padding-1, @width-padding*2+2, @height-padding-padding_bottom+2, destination.entity.map_rgba(255, 255, 255, opacity)) if opacity > 0

      #contents
      SDL::Surface.blit(@contents.entity, 0, 0, @width-padding*2, @height-padding-padding_bottom, destination.entity, base_x+padding, base_y+padding) if contents_opacity > 0

      #cursor
      if cursor_rect.width > 0 and cursor_rect.height > 0
        cursor_color = (255 - @cursor_status).abs
        destination.entity.draw_rect(base_x+padding+cursor_rect.x, base_y+padding+cursor_rect.y, cursor_rect.width, cursor_rect.height, destination.entity.map_rgba(cursor_color, cursor_color, 255, 255))
      end
    end

    destination.entity.set_clip_rect(0, 0, destination.width, destination.height) if viewport
  end
end