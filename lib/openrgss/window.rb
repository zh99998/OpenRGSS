class Window
  include RGSS::Drawable
  attr_accessor :windowskin, :contents, :cursor_rect, :active, :arrows_visible, :pause, :width, :height, :ox, :oy, :padding, :padding_bottom, :opacity, :back_opacity, :contents_opacity, :tone
  attr_reader :openness
  @@background = {}
  @@border     = {}
  @@tone       = {}

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
    @back_opacity     = 200
    @opacity          = 255
    @contents_opacity = 255
    @active           = true
    @openness         = 255
    @padding          = 12
    @padding_bottom   = 12
    @cursor_status    = 0
    @visible          = true
    @curcos_flash     = 0
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
    if @openness < 255
      base_y += @height*(255-@openness)/255 / 2
    end
    destination.entity.put(background, base_x+4, base_y+4) if opacity > 0 and back_opacity > 0 and @height * @openness / 255 - 8 > 0
    destination.entity.put(border, base_x, base_y) if opacity > 0


    if open?
      SDL::Surface.blit(@contents.entity, 0, 0, @width-padding*2, @height-padding-padding_bottom, destination.entity, base_x+padding, base_y+padding) if contents_opacity > 0
      #cursor
      if cursor_rect.width > 0 and cursor_rect.height > 0
        destination.entity.put cursor, base_x + cursor_rect.x + padding, base_y + cursor_rect.y + padding
        #cursor_color = (255 - @cursor_status).abs
        #destination.entity.draw_rect(base_x+padding+cursor_rect.x, base_y+padding+cursor_rect.y, cursor_rect.width, cursor_rect.height, destination.entity.map_rgba(cursor_color, cursor_color, 255, 255))
      end
    end


    destination.entity.set_clip_rect(0, 0, destination.width, destination.height) if viewport
  end


  def applyTone
    tone = @tone
    rst  = @@tone[[@windowskin.entity, tone.red, tone.green, tone.blue, tone.gray]]
    return rst if rst
    rst = @windowskin.entity.copyRect(0, 0, 64, 64)
    pf  =rst.format
    gg  =tone.gray/256
    rst.lock
    for x in 0...64
      for y in 0...64
        c   =pf.getRGB(rst.getPixel(x, y))
        g   =((c[0]*38+c[1]*75+c[2]*15)/128)%256
        c[0]=[[tone.red+c[0]+(g-c[0])*gg, 0].max, 255].min
        c[1]=[[tone.green+c[1]+(g-c[1])*gg, 0].max, 255].min
        c[2]=[[tone.blue+c[2]+(g-c[2])*gg, 0].max, 255].min
        rst.putPixel(x, y, pf.map_rgb(c[0], c[1], c[2]))
      end
    end
    rst.unlock
    @@tone[[@windowskin.entity, tone.red, tone.green, tone.blue, tone.gray]]=rst
    return rst
  end


  def background
    width  = @width - 8
    height = @height*@openness/255-8
    result = @@background[[@windowskin.entity, width, height, @tone]]
    if result.nil?
      tonedbg = applyTone
      result  = SDL::Surface.new(SDL::SWSURFACE|SDL::SRCALPHA, width, height, Graphics.entity)

      @windowskin.entity.set_clip_rect(0, 0, 64, 64)
      SDL::Surface.transform_draw(tonedbg, result, 0, (width).to_f/64 * 1.2, height.to_f/64*1.2, 0, 0, 0, 0, 0) #*1.2 to fix SDL bu

      @windowskin.entity.set_alpha(SDL::SRCALPHA, 255)
      tiled(result, 0, 0, result.w, result.h, @windowskin.entity, 0, 64, 64, 64)
      result.set_alpha(SDL::SRCALPHA|SDL::RLEACCEL, opacity * back_opacity / 255)
      @@background[[@windowskin.entity, width, height, @tone]] = result
    end
    result.set_alpha(SDL::SRCALPHA|SDL::RLEACCEL, opacity * back_opacity / 255)
    result
  end


  def border
    width  = @width
    height = @height*@openness/255
    result = @@border[[@windowskin.entity, width, height]]
    return result if result
    puts 'drawing a window border'


    big_endian = ([1].pack("N") == [1].pack("L"))
    if big_endian
      rmask = 0xff000000
      gmask = 0x00ff0000
      bmask = 0x0000ff00
      amask = 0x000000ff
    else
      rmask = 0x000000ff
      gmask = 0x0000ff00
      bmask = 0x00ff0000
      amask = 0xff000000
    end


    result = SDL::Surface.new(SDL::SWSURFACE|SDL::SRCALPHA, width, height, 32, rmask, gmask, bmask, amask)
    @windowskin.entity.set_alpha(0, 255)
    SDL::Surface.blit(@windowskin.entity, 64, 0, 16, 16, result, 0, 0)
    SDL::Surface.blit(@windowskin.entity, 128-16, 0, 16, 16, result, result.w-16, 0)
    SDL::Surface.blit(@windowskin.entity, 64, 64-16, 16, 16, result, 0, result.h-16)
    SDL::Surface.blit(@windowskin.entity, 128-16, 64-16, 16, 16, result, result.w-16, result.h-16)
    tiled(result, 0, 16, 16, result.h-32, @windowskin.entity, 64, 16, 32, 32)
    tiled(result, result.w-16, 16, 16, result.h-32, @windowskin.entity, 128-16, 16, 32, 32)
    tiled(result, 16, 0, result.w-32, 16, @windowskin.entity, 64+16, 0, 32, 32)
    tiled(result, 16, result.h-16, result.w-32, 16, @windowskin.entity, 64+16, 64-16, 32, 32)
    @@border[[@windowskin.entity, width, height]] = result
  end


  def cursor
    width  = cursor_rect.width
    height = cursor_rect.height
    result = @@background[[@windowskin.entity, width, height]]

    return result if result
    puts "drawing a new cursor"
    big_endian = ([1].pack("N") == [1].pack("L"))
    if big_endian
      rmask = 0xff000000
      gmask = 0x00ff0000
      bmask = 0x0000ff00
      amask = 0x000000ff
    else
      rmask = 0x000000ff
      gmask = 0x0000ff00
      bmask = 0x00ff0000
      amask = 0xff000000
    end
    result = SDL::Surface.new(SDL::SWSURFACE|SDL::SRCALPHA, width, height, 32, rmask, gmask, bmask, amask)


    @windowskin.entity.set_alpha(0, 255)
    SDL::Surface.blit(@windowskin.entity, 64, 64, 8, 8, result, 0, 0)
    SDL::Surface.blit(@windowskin.entity, 96-8, 64, 8, 8, result, width-8, 0)
    SDL::Surface.blit(@windowskin.entity, 64, 96-8, 8, 8, result, 0, height-8)
    SDL::Surface.blit(@windowskin.entity, 96-8, 96-8, 8, 8, result, width-8, height-8)
    tiled(result, 0, 8, 8, height-16, @windowskin.entity, 64, 64+8, 8, 8)
    tiled(result, width-8, 8, 8, height-16, @windowskin.entity, 96-8, 64+8, 8, 8)
    tiled(result, 8, 0, width-16, 8, @windowskin.entity, 64+8, 64, 8, 8)
    tiled(result, 8, height-8, width-16, 8, @windowskin.entity, 64+8, 96-8, 8, 8)
    tiled(result, 8, 8, width-16, height-16, @windowskin.entity, 64+8, 64+8, 16, 16)
    @@background[[@windowskin.entity, width, height]] = result
  end


  def tiled(g, x, y, w, h, skin, x1, y1, w1, h1)
    g.set_clip_rect(x, y, w, h)
    xnow=x
    while (xnow<=x+w)
      ynow=y
      while (ynow<=y+h)
        SDL::Surface.blit(skin, x1, y1, w1, h1, g, xnow, ynow)
        ynow+=h1
      end
      xnow+=w1
    end
  end
  #SDL::Surface.blit(cache([skin, :bg, w, h]), 0, 0, w, h, g, x, y)
end