#Window试写
#by kissye http://bbs.66rpg.com/thread-100857-1-1.html

class Window
  #常量,self.contents距离上下左右的距离
  Contentsx4864636 = 16
  Contentsy1687869 = 16
  #---------------------------------------------------------------------------
  #
  #---------------------------------------------------------------------------
  def initialize(viewport = nil)
    @spritewindow5486154 = Sprite.new(viewport) #窗口背景块
    @spritewindow156486156 = Sprite.new(viewport) #窗口背景边框
    @spritecontents5486413 = Contents.new(32, 32, 32, 32, viewport) #self.contents图块
    @spritecurse4856946 = Sprite.new(viewport) #光标图块
    @spritecurse4856946.opacity = 200
    @spritemove18516315 = Sprite.new(viewport) #当contents内容大于一页时显示箭头的图块
    @spritepause486483 = Sprite.new(viewport) #显示停顿标志的图块
    @spritewindow5486154.bitmap = Bitmap.new(32, 32)
    @spritewindow156486156.bitmap = Bitmap.new(32, 32)
    @spritecurse4856946.bitmap = Bitmap.new(32, 32)
    @spritepause486483.bitmap = Bitmap.new(16, 16)
    @spritemove18516315.bitmap = Bitmap.new(32, 32)
    @width4863163 = 32 #宽度
    @height156468546 = 32 #高度
    x = 0
    y = 0
    @openness486163 = 255
    @cursor_rect486864131 = Rect.new(0, 0, 0, 0) #光标矩形
    @active468463453 = true
    @pause1684683 = false
    @visible679068 = true
    @pausecount468416 = 1 #显示第n张停顿图行,顺便用来一起决定光标透明度
    @count48564163 = 0 #每桢刷新会很卡,一定桢数才刷新一次光标和停顿图,count计数
    @oxl49861635 = false #contents左边内容是否超出
    @oxr48641651 = false #contents右边内容是否超出
    @oyl156489651 = false #contents上边内容是否超出
    @oyr4864164648 = false #contents下边内容是否超出
  end

  #--------------------------------------------------------------------------
  #viewport
  #--------------------------------------------------------------------------
  def viewport
    return @spritewindow5486154.viewport
  end

  #--------------------------------------------------------------------------
  def viewport=(value)
    @spritewindow5486154.viewport = value
    @spritewindow156486156.viewport = value
    @spritecontents5486413.viewport = value
    @spritecurse4856946.viewport = value
    @spritepause486483.viewport = value
    @spritemove18516315.viewport = value
  end

  #--------------------------------------------------------------------------
  #x
  #--------------------------------------------------------------------------
  def x
    return @spritewindow5486154.x
  end

  #--------------------------------------------------------------------------
  def x=(value)
    @spritecurse4856946.x = value + @cursor_rect486864131.x
    @spritewindow5486154.x = value
    @spritewindow156486156.x = value
    @spritecontents5486413.x = value + Contentsx4864636
    @spritemove18516315.x = value
    setpause7452435 #改变停顿图的位置,因为和x y width height都有关系,所以写成方法了
  end

  #---------------------------------------------------------------------------
  #y
  #---------------------------------------------------------------------------
  def y
    return @spritewindow5486154.y
  end

  #---------------------------------------------------------------------------
  def y=(value)
    @spritecurse4856946.y = value + @cursor_rect486864131.y
    @orgy48648616 = value #@orgy48648616在计算openness需要用到
    @spritewindow5486154.y = value
    @spritewindow156486156.y = value
    @spritecontents5486413.y = value + Contentsy1687869
    @spritemove18516315.y = value
    setpause7452435 #改变停顿图的位置,因为和x y width height都有关系,所以写成方法了
  end

  #---------------------------------------------------------------------------
  #z
  #--------------------------------------------------------------------------
  def z
    return @spritewindow5486154.z
  end

  #-------------------------------------------------------------------------
  def z=(value)
    @spritewindow5486154.z = value
    @spritewindow156486156.z = value
    @spritecontents5486413.z = value
    @spritecurse4856946.z = value
    @spritepause486483.z = value
    @spritemove18516315.z = value
  end

  #---------------------------------------------------------------------------
  #width
  #--------------------------------------------------------------------------
  def width
    return @width4863163
  end

  #---------------------------------------------------------------------------
  def width=(value)
    value = [value, 32].max #最小32,不然描绘边框会出错
    @width4863163 = value
    drawback458641563 #重新描绘背景
                            #清除原箭头图,然后重新判断contents内容是否大于一页
    @spritemove18516315.bitmap.dispose
    @spritemove18516315.bitmap = Bitmap.new(width, height)
    checkox486486
    checkoy4894616
    @spritecontents5486413.width = value - Contentsx4864636 * 2
    setpause7452435 #改变停顿图的位置,因为和x y width height都有关系,所以写成方法了
  end

  #---------------------------------------------------------------------------
  #height
  #-------------------------------------------------------------------------
  def height
    return @height156468546
  end

  #-------------------------------------------------------------------------
  def height=(value)
    value = [value, 32].max #最小32,不然描绘边框会出错
    @height156468546 = value
    drawback458641563 #重新描绘背景
                            #清除原箭头图,然后重新判断contents内容是否大于一页
    @spritemove18516315.bitmap.dispose
    @spritemove18516315.bitmap = Bitmap.new(width, height)
    checkox486486
    checkoy4894616
    @spritecontents5486413.height = value - Contentsy1687869 * 2
    setpause7452435 #改变停顿图的位置,因为和x y width height都有关系,所以写成方法了
  end

  #--------------------------------------------------------------------------
  #windowskin
  #--------------------------------------------------------------------------
  def windowskin
    return @skin1869473165
  end

  #--------------------------------------------------------------------------
  def windowskin=(value)
    @skin1869473165 = value
    drawback458641563
  end

  #---------------------------------------------------------------------------
  #描绘窗口背景
  def drawback458641563
    if @skin1869473165 != nil
      @spritewindow5486154.bitmap = Bitmap.new(width, height)
      @spritewindow156486156.bitmap = Bitmap.new(width, height)
      #背景1,拉伸背景
      rectbitmap = Rect.new(0, 0, 64, 64)
      rectself = Rect.new(2, 2, width - 4, height - 4)
      @spritewindow5486154.bitmap.stretch_blt(rectself, @skin1869473165,
                                              rectbitmap)
      #背景2,平铺背景
      rectbitmap = Rect.new(0, 64, 64, 64)
      rectself = Rect.new(0, 0, 64, 64)
      while rectself.x + 64 <= x + width
        while rectself.y + 64 <= y + height
          @spritewindow5486154.bitmap.stretch_blt(rectself, @skin1869473165,
                                                  rectbitmap)
          rectself.y += 64
        end
        rectbitmap.height = rectself.height = y + height - rectself.y
        @spritewindow5486154.bitmap.stretch_blt(rectself, @skin1869473165,
                                                rectbitmap)
        rectself.y = 0
        rectbitmap.height = rectself.height = 64
        rectself.x += 64
      end
      rectself.width = rectself.width = x + width - rectself.x
      while rectself.y + 64 <= y + height
        @spritewindow5486154.bitmap.stretch_blt(rectself, @skin1869473165,
                                                rectbitmap)
        rectself.y += 64
      end
      rectbitmap.height = rectself.height = y + height - rectself.y
      @spritewindow5486154.bitmap.stretch_blt(rectself, @skin1869473165,
                                              rectbitmap)
      #上边框
      rectbitmap = Rect.new(80, 0, 32, 16)
      rectself = Rect.new(16, 0, 32, 16)
      while rectself.x + 32 <= x + width - 16
        @spritewindow156486156.bitmap.stretch_blt(rectself, @skin1869473165,
                                                  rectbitmap)
        rectself.x += 32
      end
      rectbitmap.width = rectself.width = x + width - 16 - rectself.x
      @spritewindow156486156.bitmap.stretch_blt(rectself, @skin1869473165,
                                                rectbitmap)
      #下边框
      rectbitmap = Rect.new(80, 48, 32, 16)
      rectself = Rect.new(16, height - 16, 32, 16)
      while rectself.x + 32 <= x + width - 16
        @spritewindow156486156.bitmap.stretch_blt(rectself, @skin1869473165,
                                                  rectbitmap)
        rectself.x += 32
      end
      rectbitmap.width = rectself.width = x + width - 16 - rectself.x
      @spritewindow156486156.bitmap.stretch_blt(rectself, @skin1869473165,
                                                rectbitmap)
      #左边框
      rectbitmap = Rect.new(64, 16, 16, 32)
      rectself = Rect.new(0, 16, 16, 32)
      while rectself.y + 32 <= y + height - 16
        @spritewindow156486156.bitmap.stretch_blt(rectself, @skin1869473165,
                                                  rectbitmap)
        rectself.y += 32
      end
      rectbitmap.height = rectself.height = y + height - 16 - rectself.y
      @spritewindow156486156.bitmap.stretch_blt(rectself, @skin1869473165,
                                                rectbitmap, @spritewindow156486156.opacity)
      #右边框
      rectbitmap = Rect.new(112, 16, 16, 32)
      rectself = Rect.new(width - 16, 16, 16, 32)
      while rectself.y + 32 <= y + height - 16
        @spritewindow156486156.bitmap.stretch_blt(rectself, @skin1869473165,
                                                  rectbitmap)
        rectself.y += 32
      end
      rectbitmap.height = rectself.height = y + height - 16 - rectself.y
      @spritewindow156486156.bitmap.stretch_blt(rectself, @skin1869473165,
                                                rectbitmap, @spritewindow156486156.opacity)
      #左上角边框
      rectbitmap = Rect.new(64, 0, 16, 16)
      rectself = Rect.new(0, 0, 16, 16)
      @spritewindow156486156.bitmap.stretch_blt(rectself, @skin1869473165,
                                                rectbitmap)
      #右上角边框
      rectbitmap = Rect.new(112, 0, 16, 16)
      rectself = Rect.new(width - 16, 0, 16, 16)
      @spritewindow156486156.bitmap.stretch_blt(rectself, @skin1869473165,
                                                rectbitmap)
      #左下角边框
      rectbitmap = Rect.new(64, 48, 16, 16)
      rectself = Rect.new(0, height - 16, 16, 16)
      @spritewindow156486156.bitmap.stretch_blt(rectself, @skin1869473165,
                                                rectbitmap)
      #右下角边框
      rectbitmap = Rect.new(112, 48, 16, 16)
      rectself = Rect.new(width - 16, height - 16, 16, 16)
      @spritewindow156486156.bitmap.stretch_blt(rectself, @skin1869473165,
                                                rectbitmap)
    end
  end

  #-------------------------------------------------------------------------
  #contents
  #-------------------------------------------------------------------------
  def contents
    return @spritecontents5486413
  end

  #--------------------------------------------------------------------------
  def contents=(bitmap)
    oxx = self.ox
    oyy = self.oy
    xx = contents.x
    yy = contents.y
    zz = contents.z
    visible = contents.visible
    view = contents.viewport
    @spritecontents5486413 = Contents.new(bitmap.width, bitmap.height,
                                          self.width - Contentsx4864636 * 2, self.height - Contentsy1687869 * 2, view, false)
    @spritecontents5486413.refresh(oxx, oyy, xx, yy, zz, visible, view)
    bitmap.dispose
    checkox486486
    checkoy4894616
  end

  #--------------------------------------------------------------------------
  #cursor
  #-------------------------------------------------------------------------
  def cursor_rect
    return @cursor_rect486864131
  end

  #-------------------------------------------------------------------------
  def @cursor_rect486864131.empty
    @cursor_rect486864131.set(0, 0, 0, 0)
  end

  #-------------------------------------------------------------------------
  def cursor_rect=(rect)
    drawrect486486(rect)
  end

  #------------------------------------------------------------------------
  #描绘光标
  def drawrect486486(rect)
    rect.x += @spritecontents5486413.x
    rect.y += @spritecontents5486413.y
    @spritecurse4856946.x = rect.x
    @spritecurse4856946.y = rect.y
    if @spritecurse4856946.bitmap.width != rect.width or @spritecurse4856946.bitmap.height != rect.height
      @spritecurse4856946.bitmap = Bitmap.new(rect.width, rect.height)
      #中间部分
      rectbitmap = Rect.new(66, 66, 28, 28)
      rectself = Rect.new(2, 2, rect.width - 4, rect.height - 4)
      @spritecurse4856946.bitmap.stretch_blt(rectself, @skin1869473165, rectbitmap)
      #左边部分
      rectbitmap = Rect.new(64, 66, 2, 28)
      rectself = Rect.new(0, 2, 2, rect.height - 4)
      @spritecurse4856946.bitmap.stretch_blt(rectself, @skin1869473165, rectbitmap)
      #右边部分
      rectbitmap = Rect.new(94, 66, 2, 28)
      rectself = Rect.new(rect.width - 2, 2, 2, rect.height - 4)
      @spritecurse4856946.bitmap.stretch_blt(rectself, @skin1869473165, rectbitmap)
      #上边部分
      rectbitmap = Rect.new(66, 64, 28, 2)
      rectself = Rect.new(2, 0, rect.width - 4, 2)
      @spritecurse4856946.bitmap.stretch_blt(rectself, @skin1869473165, rectbitmap)
      #下边部分
      rectbitmap = Rect.new(66, 94, 28, 2)
      rectself = Rect.new(2, rect.height - 2, rect.width - 4, 2)
      @spritecurse4856946.bitmap.stretch_blt(rectself, @skin1869473165, rectbitmap)
      @cursor_rect486864131 = rect
      #左上角
      rectbitmap = Rect.new(64, 64, 2, 2)
      rectself = Rect.new(0, 0, 2, 2)
      @spritecurse4856946.bitmap.stretch_blt(rectself, @skin1869473165, rectbitmap)
      #右上角
      rectbitmap = Rect.new(94, 64, 2, 2)
      rectself = Rect.new(rect.width - 2, 0, 2, 2)
      @spritecurse4856946.bitmap.stretch_blt(rectself, @skin1869473165, rectbitmap)
      #左下角
      rectbitmap = Rect.new(64, 94, 2, 2)
      rectself = Rect.new(0, rect.height - 2, 2, 2)
      @spritecurse4856946.bitmap.stretch_blt(rectself, @skin1869473165, rectbitmap)
      #右下角
      rectbitmap = Rect.new(94, 94, 2, 2)
      rectself = Rect.new(rect.width - 2, rect.height - 2, 2, 2)
      @spritecurse4856946.bitmap.stretch_blt(rectself, @skin1869473165, rectbitmap)
    end
  end

  #--------------------------------------------------------------------------
  #active
  #-------------------------------------------------------------------------
  def active
    return @active468463453
  end

  #-------------------------------------------------------------------------
  def active=(value)
    @active468463453 = value
  end

  #--------------------------------------------------------------------------
  #visible
  #-------------------------------------------------------------------------
  def visible
    return @spritewindow5486154.visible
  end

  #-------------------------------------------------------------------------
  def visible=(value)
    @spritewindow5486154.visible = value
    @spritewindow156486156.visible = value
    @spritecontents5486413.visible = value
    @spritecurse4856946.visible = value
    @spritepause486483.visible = value
    @spritemove18516315.visible = value
  end

  #--------------------------------------------------------------------------
  #pause
  #---------------------------------------------------------------------------
  def pause
    return @pause1684683
  end

  #--------------------------------------------------------------------------
  def pause=(value)
    @pause1684683 = value
    unless value
      @spritepause486483.bitmap.clear_rect(@spritepause486483.bitmap.rect)
    end
  end

  #---------------------------------------------------------------------------
  def setpause7452435
    @spritepause486483.x = (width - 16)/ 2 + x
    @spritepause486483.y = height - 16 + y
  end

  #--------------------------------------------------------------------------
  #opacity
  #--------------------------------------------------------------------------
  def opacity
    return @spritewindow156486156.opacity
  end

  #--------------------------------------------------------------------------
  def opacity=(value)
    @spritewindow156486156.opacity = value
  end

  #--------------------------------------------------------------------------
  #back_opacity
  #--------------------------------------------------------------------------
  def back_opacity
    return @spritewindow5486154.opacity
  end

  #--------------------------------------------------------------------------
  def back_opacity=(value)
    @spritewindow5486154.opacity = value
  end

  #--------------------------------------------------------------------------
  #contents_opacity
  #--------------------------------------------------------------------------
  def contents_opacity
    return @spritecontents5486413.opacity
  end

  #--------------------------------------------------------------------------
  def contents_opacity=(value)
    @spritecontents5486413.opacity = value
  end

  #--------------------------------------------------------------------------
  #openness
  #--------------------------------------------------------------------------
  def openness
    return @openness486163
  end

  #--------------------------------------------------------------------------
  def openness=(value)
    value = [[value, 255].min, 0].max
    zoom_y = (value / 255.0) ** 0.8
    @openness486163 = value
    @spritewindow5486154.zoom_y = zoom_y
    @spritewindow5486154.y = (1.0 - zoom_y) * height / 2 + @orgy48648616
    @spritewindow156486156.zoom_y = zoom_y
    @spritewindow156486156.y = (1.0 - zoom_y) * height / 2 + @orgy48648616
    if value != 255
      @spritecontents5486413.visible = false
      @spritecurse4856946.visible = false
      @spritepause486483.visible = false
      @spritemove18516315.visible = false
    else
      @spritecontents5486413.visible = self.visible
      @spritecurse4856946.visible = self.visible
      @spritepause486483.visible = self.visible
      @spritemove18516315.visible = self.visible
    end
  end

  #--------------------------------------------------------------------------
  #dispose
  #----------------------------------------------------------------------------
  def dispose
    @spritemove18516315.bitmap.dispose
    @spritemove18516315.dispose
    @spritecurse4856946.bitmap.dispose
    @spritecurse4856946.dispose
    @spritepause486483.bitmap.dispose
    @spritepause486483.dispose
    @spritewindow5486154.bitmap.dispose
    @spritewindow5486154.dispose
    @spritewindow156486156.bitmap.dispose
    @spritewindow156486156.dispose
    @spritecontents5486413.dispose
  end

  #--------------------------------------------------------------------------
  def disposed?
    return @spritewindow5486154.disposed?
  end

  #--------------------------------------------------------------------------
  #ox
  #-------------------------------------------------------------------------
  def ox
    return @spritecontents5486413.ox
  end

  #-------------------------------------------------------------------------
  def ox=(value)
    @spritecontents5486413.ox = value
    checkox486486 #判断是否显示箭头
  end

  #--------------------------------------------------------------------------
  #检查是否显示ox方向的箭头
  def checkox486486
    if ox > 0
      unless @oxl49861635
        @oxl49861635 = true
        rectself = Rect.new(4, (height - 16)/ 2, 8, 16)
        rectbitmap = Rect.new(80, 24, 8, 16)
        @spritemove18516315.bitmap.stretch_blt(rectself, @skin1869473165, rectbitmap)
      end
    elsif @oxl49861635
      @oxl49861635 = false
      @spritemove18516315.bitmap.clear_rect(4, (height - 16)/ 2, 8, 16)
    end
    if contents.width - ox > [@width4863163 - Contentsx4864636 * 2, 32].max
      unless @oxr48641651
        @oxr48641651 = true
        rectself = Rect.new(width - 12, (height - 16)/ 2, 8, 16)
        rectbitmap = Rect.new(104, 24, 8, 16)
        @spritemove18516315.bitmap.stretch_blt(rectself, @skin1869473165, rectbitmap)
      end
    elsif @oxr48641651
      @oxr48641651 = false
      @spritemove18516315.bitmap.clear_rect(width - 12, (height - 16)/ 2, 8, 16)
    end
  end

  #--------------------------------------------------------------------------
  #oy
  #--------------------------------------------------------------------------
  def oy
    return @spritecontents5486413.oy
  end

  #-------------------------------------------------------------------------
  def oy=(value)
    @spritecontents5486413.oy = value
    checkoy4894616 #判断是否显示箭头
  end

  #--------------------------------------------------------------------------
  #检查是否显示oy方向的箭头
  def checkoy4894616
    if oy > 0
      unless @oyl156489651
        @oyl156489651 = true
        rectself = Rect.new((width - 16)/ 2, 4, 16, 8)
        rectbitmap = Rect.new(88, 16, 16, 8)
        @spritemove18516315.bitmap.stretch_blt(rectself, @skin1869473165, rectbitmap)
      end
    elsif @oyl156489651
      @oyl156489651 = false
      @spritemove18516315.bitmap.clear_rect((width - 16)/ 2, 4, 16, 8)
    end
    if contents.height - oy > [@height156468546 - Contentsy1687869 * 2, 32].max
      unless @oyr4864164648
        @oyr4864164648 = true
        rectself = Rect.new((width - 16)/ 2, height - 12, 16, 8)
        rectbitmap = Rect.new(88, 40, 16, 8)
        @spritemove18516315.bitmap.stretch_blt(rectself, @skin1869473165, rectbitmap)
      end
    elsif @oyr4864164648
      @oyr4864164648 = false
      @spritemove18516315.bitmap.clear_rect((width - 16)/ 2, height - 12, 16, 8)
    end
  end

  #-----------------------------------------------------------------------
  def update
    #当windowskin不为nil时
    if @skin1869473165 != nil and visible and openness > 0
      #刷新光标图形和位置
      rect = Rect.new(@spritecurse4856946.x, @spritecurse4856946.y, @spritecurse4856946.bitmap.width, @spritecurse4856946.bitmap.height)
      if @cursor_rect486864131.width == 0 or @cursor_rect486864131.height == 0
        unless @spritecurse4856946.bitmap.width == 2 and @spritecurse4856946.bitmap.height == 2
          @spritecurse4856946.bitmap = Bitmap.new(2, 2)
        end
      elsif @cursor_rect486864131 != rect
        drawrect486486(@cursor_rect486864131)
      end
      #@count48564163为刷新一定桢数后改变停顿箭头和光标透明度
      if @count48564163 == 12
        @count48564163 = 0
        #@pausecount468416决定当前显示的停顿图形,我顺带用来一起决定光标透明度了
        case @pausecount468416
          when 1
            rectbitmap = Rect.new(96, 64, 16, 16)
            opa = 120
          when 2
            rectbitmap = Rect.new(112, 64, 16, 16)
            opa = 200
          when 3
            rectbitmap = Rect.new(96, 80, 16, 16)
            opa = 255
          when 4
            rectbitmap = Rect.new(112, 80, 16, 16)
            opa = 200
        end
        #刷新光标透明度
        if active
          @spritecurse4856946.opacity = opa
        end
        #刷新停顿箭头
        if pause
          rectself = Rect.new(0, 0, 16, 16)
          @spritepause486483.bitmap.clear_rect(rectself)
          @spritepause486483.bitmap.stretch_blt(rectself, @skin1869473165, rectbitmap)
        end
        @pausecount468416 += 1
        if @pausecount468416 == 5
          @pausecount468416 = 1
        end
      else
        #每桢@count48564163加1
        @count48564163 += 1
      end
    end
  end
end

class Contents < Bitmap
  attr_reader :ox
  attr_reader :oy
  #---------------------------------------------------------------------------
  def initialize(width, height, width123, height123, viewport = nil, re = true)
    @sprite = Sprite.new(viewport)
    super(width, height)
    @bitmap = Bitmap.new(width123, height123)
    @sprite.bitmap = @bitmap
    if re
      refresh
    end
  end

  #-------------------------------------------------------------------------
  def refresh(ox = 0, oy = 0, x = 0, y = 0, z = 0, visible = true, viewport = nil)
    @ox = ox
    @oy = oy
    self.x = x
    self.y = y
    self.z = z
    self.visible = visible
    self.viewport = viewport
  end

  #--------------------------------------------------------------------------
  def blt(x, y, src_bitmap, src_rect, opacity = 255)
    super(x, y, src_bitmap, src_rect, opacity)
    @bitmap.blt(x - @ox, y - @oy, src_bitmap, src_rect, opacity)
  end

  #--------------------------------------------------------------------------
  def stretch_blt(dest_rect, src_bitmap, src_rect, opacity = 255)
    super(dest_rect, src_bitmap, src_rect, opacity)
    dest_rect.x -= @ox
    dest_rect.y -= @oy
    @bitmap.stretch_blt(dest_rect, src_bitmap, src_rect, opacity)
  end

  #--------------------------------------------------------------------------
  def fill_rect(x, y, width = nil, height = nil, color = nil)
    if color.nil?
      super(x, y)
      x.x -= @ox
      x.y -= @oy
      @bitmap.fill_rect(x, y)
    else
      super(x, y, width, height, color)
      @bitmap.fill_rect(x - @ox, y - @oy, width, height, color)
    end
  end

  #-------------------------------------------------------------------------
  def gradient_fill_rect(x, y, width, height = false, color1 = nil,
      color2 = nil, vertical = false)
    if color2.nil?
      super(x, y, width, height)
      x.x -= @ox
      x.y -= @oy
      @bitmap.gradient_fill_rect(x, y, width, height)
    else
      super(x, y, width, height, color1, color2, vertical)
      @bitmap.gradient_fill_rect(x - @ox, y - @oy, width, height, color1, color2, vertical)
    end
  end

  #---------------------------------------------------------------------------
  def draw_text(x, y, width = 0, height = nil, str = nil, align = 0)
    @bitmap.font.size = self.font.size
    @bitmap.font.color = self.font.color
    @bitmap.font.shadow = self.font.shadow
    @bitmap.font.name = self.font.name
    @bitmap.font.bold = self.font.bold
    @bitmap.font.italic = self.font.italic
    if str.nil?
      super(x, y, width)
      x.x -= @ox
      x.y -= @oy
      @bitmap.draw_text(x, y, width)
    else
      super(x, y, width, height, str, align)
      @bitmap.draw_text(x - @ox, y - @oy, width, height, str, align)
    end
  end

  #---------------------------------------------------------------------------
  def set_pixel(x, y, color)
    super(x, y, color)
    @bitmap.draw_text(x - @ox, y - @oy, color)
  end

  #--------------------------------------------------------------------------
  def set_bitmap
    @bitmap.clear_rect(@bitmap.rect)
    rect = Rect.new(@ox, @oy, @bitmap.width, @bitmap.height)
    @bitmap.blt(0, 0, self, rect)
  end

  #--------------------------------------------------------------------------
  def width=(w)
    h = @bitmap.height
    @bitmap.dispose
    @bitmap = Bitmap.new(w, h)
    @sprite.bitmap = @bitmap
    set_bitmap
  end

  #--------------------------------------------------------------------------
  def height=(h)
    w = @bitmap.width
    @bitmap.dispose
    @bitmap = Bitmap.new(w, h)
    @sprite.bitmap = @bitmap
    set_bitmap
  end

  #---------------------------------------------------------------------------
  def ox=(value)
    @ox = value
    set_bitmap
  end

  #---------------------------------------------------------------------------
  def oy=(value)
    @oy = value
    set_bitmap
  end

  #--------------------------------------------------------------------------
  def dispose
    @bitmap.dispose
    super
    @sprite.dispose
  end

  #--------------------------------------------------------------------------
  def clear
    @bitmap.clear
    super
  end

  #-------------------------------------------------------------------------
  def clear_rect(x, y = nil, width = nil, height = nil)
    if height.nil?
      super(x)
      x.x -= @ox
      x.y -= @oy
      @bitmap.clear_rect(x)
    else
      super(x, y, width, height)
      @bitmap.clear_rect(x - @ox, y - @oy, width, height)
    end
  end

  #-----------------------------------------------------------------------
  def hue_change(hue)
    super(hue)
    set_bitmap
  end

  #--------------------------------------------------------------------------
  def blur
    super
    set_bitmap
  end

  #--------------------------------------------------------------------------
  def radial_blur(angle, division)
    super(angle, division)
    set_bitmap
  end

  #------------------------------------------------------------------------
  def x
    return @x
  end

  #------------------------------------------------------------------------
  def x=(value)
    @sprite.x = @x = value
  end

  #------------------------------------------------------------------------
  def y
    return @y
  end

  #------------------------------------------------------------------------
  def y=(value)
    @sprite.y = @y = value
  end

  #------------------------------------------------------------------------
  def z
    return @z
  end

  #------------------------------------------------------------------------
  def z=(value)
    @sprite.z = @z = value
  end

  #-----------------------------------------------------------------------
  def visible
    return @visible
  end

  #-----------------------------------------------------------------------
  def visible=(value)
    @sprite.visible = @visible = value
  end

  #------------------------------------------------------------------------
  def zoom_y=(value)
    @sprite.zoom_y = value
  end

  #------------------------------------------------------------------------
  def opacity=(value)
    @sprite.opacity = value
  end

  #------------------------------------------------------------------------
  def viewport
    return @viewport
  end

  #------------------------------------------------------------------------
  def viewport=(value)
    @sprite.viewport = @viewport = value
  end

  #-----------------------------------------------------------------------
  def opacity
    return @sprite.opacity
  end
end