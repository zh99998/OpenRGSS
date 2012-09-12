#偷偷丢Tilemap试写(感谢胃君的地图讲解)10.2更新
# by kissye http://bbs.66rpg.com/thread-104661-1-1.html

class Tilemap

  attr_accessor :flags
  FBLX  = 544 #x方向分辨率
  FBLY  = 416 #y方向分辨率
  SIZEX = 32
  SIZEY = 32
  ANI   = 25  #动画等待桢数
              #以下画元件用
  RECT1 = [Rect.new(0, 32, 16, 16), Rect.new(16, 32, 16, 16),
           Rect.new(32, 32, 16, 16), Rect.new(48, 32, 16, 16),
           Rect.new(0, 48, 16, 16), Rect.new(16, 48, 16, 16),
           Rect.new(32, 48, 16, 16), Rect.new(48, 48, 16, 16),
           Rect.new(0, 64, 16, 16), Rect.new(16, 64, 16, 16),
           Rect.new(32, 64, 16, 16), Rect.new(48, 64, 16, 16),
           Rect.new(0, 80, 16, 16), Rect.new(16, 80, 16, 16),
           Rect.new(32, 80, 16, 16), Rect.new(48, 80, 16, 16),
           Rect.new(32, 0, 16, 16), Rect.new(48, 0, 16, 16),
           Rect.new(32, 16, 16, 16), Rect.new(48, 16, 16, 16)]
  LIST1 = [[10, 9, 6, 5], [16, 9, 6, 5], [10, 17, 6, 5], [16, 17, 6, 5],
           [10, 9, 6, 19], [16, 9, 6, 19], [10, 17, 6, 19], [16, 17, 6, 19],
           [10, 9, 18, 5], [16, 9, 18, 5], [10, 17, 18, 5], [16, 17, 18, 5],
           [10, 9, 18, 19], [16, 9, 18, 19], [10, 17, 18, 19], [16, 17, 18, 19],
           [8, 9, 4, 5], [8, 17, 4, 5], [8, 9, 4, 19], [8, 17, 4, 19],
           [2, 1, 6, 5], [2, 1, 6, 19], [2, 1, 18, 5], [2, 1, 18, 19],
           [10, 11, 6, 7], [10, 11, 18, 7], [16, 11, 6, 7], [16, 11, 18, 7],
           [10, 9, 14, 13], [16, 9, 14, 13], [10, 17, 14, 13], [16, 17, 14, 13],
           [8, 11, 4, 7], [2, 1, 14, 13], [0, 1, 4, 5], [0, 1, 4, 19],
           [2, 3, 6, 7], [2, 3, 18, 7], [10, 11, 14, 15], [16, 11, 14, 15],
           [8, 9, 12, 13], [8, 17, 12, 13], [0, 3, 8, 11], [0, 1, 12, 13],
           [4, 7, 12, 15], [2, 3, 14, 15], [0, 3, 12, 15]]
  RECT2 = [Rect.new(0, 0, 16, 16), Rect.new(16, 0, 16, 16),
           Rect.new(32, 0, 16, 16), Rect.new(48, 0, 16, 16),
           Rect.new(0, 16, 16, 16), Rect.new(16, 16, 16, 16),
           Rect.new(32, 16, 16, 16), Rect.new(48, 16, 16, 16),
           Rect.new(0, 32, 16, 16), Rect.new(16, 32, 16, 16),
           Rect.new(32, 32, 16, 16), Rect.new(48, 32, 16, 16),
           Rect.new(0, 48, 16, 16), Rect.new(16, 48, 16, 16),
           Rect.new(32, 48, 16, 16), Rect.new(48, 48, 16, 16)]
  LIST2 = [[10, 9, 6, 5], [8, 9, 4, 5], [2, 1, 6, 5], [0, 1, 4, 5],
           [10, 11, 6, 7], [8, 11, 4, 7], [2, 3, 6, 7], [0, 3, 8, 11],
           [10, 9, 14, 13], [8, 9, 12, 13], [2, 1, 14, 13], [0, 1, 12, 13],
           [10, 11, 14, 15], [4, 7, 12, 15], [2, 3, 14, 15], [0, 3, 12, 15]]
  LIST3 = [[2, 1, 6, 5], [0, 1, 4, 5], [2, 3, 6, 7], [0, 3, 4, 7]]
                          #----------------------------------------------------------------------------
  attr_accessor :bitmaps
  attr_accessor :viewport
  attr_reader :ox
  attr_reader :oy
  attr_reader :visible
  attr_reader :passages
  attr_reader :count
  attr_reader :flash_data #不知道这个做什么用的
                          #----------------------------------------------------------------------------
  def initialize(viewport = nil)
    @shadow = Bitmap.new(SIZEX, SIZEY)
    @shadow.fill_rect(0, 0, 17, SIZEY, Color.new(0, 0, 0, 120)) #阴影
    @viewport   = viewport
    @bitmaps    = []
    @backs      = {}                                            #元件精灵
    @backbitmap = {}                                            #元件图块
    @switches   = {}                                            #动画开关
    @count      = 0                                             #当前显示动画
    @count1     = 0                                             #等待桢数
    @visible    = true
    @ox         = 0
    @oy         = 0
    @lastox     = 0
    @lastoy     = 0
  end

  #----------------------------------------------------------------------------
  def dispose
    for i in @backbitmap.values
      i.dispose
    end
    for i in @backs.values
      i.dispose
    end
    @shadow.dispose
  end

  #---------------------------------------------------------------------------
  def disposed?
    return @shadow.disposed?
  end

  #---------------------------------------------------------------------------
  def map_data=(value)
    @map_data = value
    #如果地图太大,按ESC打开菜单后返回地图太慢,下面这段循环可以不要
    for i in 0...value.xsize
      for j in 0...value.ysize
        for k in 0..2
          cachebitmap(value[i, j, k])
        end
      end
    end
    #如果地图太大,按ESC打开菜单后返回地图太慢,上面这段循环可以不要
    #需要重新描绘的图快
    if @map_data.xsize * SIZEX <= FBLX
      rangei = (@ox / SIZEX - 1)..[((@ox + FBLX) / SIZEX), FBLX / SIZEX - 1].min
    else
      rangei = (@ox / SIZEX - 1)..((@ox + FBLX) / SIZEX)
    end
    if @map_data.xsize * SIZEX <= FBLX
      rangej = (@oy / SIZEY - 1)..[((@oy + FBLY) / SIZEY), FBLY / SIZEY - 1].min
    else
      rangej = (@oy / SIZEY - 1)..((@oy + FBLY) / SIZEY)
    end
    for i in rangei
      for j in rangej
        for k in 0..2
          draw(i, j, k)
        end
      end
    end
  end

  #--------------------------------------------------------------------------
  def refreshox
    #需要释放掉的图块
    rangej = (@lastoy / SIZEY - 1)..((@lastoy + FBLY) / SIZEY)
    if @ox > @lastox
      rangei = ((@lastox / SIZEX - 1)...(@ox / SIZEX - 1))
    elsif @ox < @lastox
      rangei = (((@ox + FBLX) / SIZEX + 1)..((@lastox + FBLX) / SIZEX))
    end
    for i in rangei
      for j in rangej
        for k in 0..3
          next if @backs[[i, j, k]].nil?
          @backs[[i, j, k]].dispose
          @backs.delete([i, j, k])
          @switches.delete([i, j, k])
        end
      end
    end
    #恢复走路时候的偏移
    if @ox >= (@map_data.xsize * SIZEX - FBLX)
      for i in @backs.keys
        @backs[i].ox = 0
        @backs[i].x  = i[0] * SIZEX - @ox
        if i[0] < (@ox / 32 - 1)
          @backs[i].x += @map_data.xsize * SIZEX
        elsif i[0] == -1
          @backs[i].x = 0
        end
      end
    else
      for i in @backs.keys
        @backs[i].ox = 0
        @backs[i].x  = i[0] * SIZEX - @ox
      end
    end
    #需要重新描绘的图快
    rangej = (@oy / SIZEY - 1)..((@oy + FBLY) / SIZEY)
    if @ox > @lastox
      rangei = ([((@lastox + FBLX) / SIZEX + 1), (@ox / SIZEX - 1)].max..((@ox + FBLX) / SIZEX))
    elsif @ox < @lastox
      rangei = ((@ox / SIZEX - 1)...[(@lastox / SIZEX - 1), (@ox + FBLX) / SIZEX + 1].min)
    end
    for i in rangei
      for j in rangej
        for k in 0..2
          draw(i, j, k)
        end
      end
    end
  end

  #--------------------------------------------------------------------------
  def refreshoy
    #需要释放掉的图块
    rangei = (@lastox / SIZEX - 1)..((@lastox + FBLX) / SIZEX)
    if @oy > @lastoy
      rangej = ((@lastoy / SIZEY - 1)...(@oy / SIZEY - 1))
    elsif @oy < @lastoy
      rangej = (((@oy + FBLY) / SIZEY + 1)..((@lastoy + FBLY) / SIZEY))
    end
    for i in rangei
      for j in rangej
        for k in 0..3
          next if @backs[[i, j, k]].nil?
          @backs[[i, j, k]].dispose
          @backs.delete([i, j, k])
          @switches.delete([i, j, k])
        end
      end
    end
    #恢复走路时候的偏移
    if @oy >= (@map_data.ysize * SIZEY - FBLY)
      for i in @backs.keys
        @backs[i].oy = 0
        @backs[i].y  = i[1] * SIZEY - @oy
        if i[1] < (@oy / 32 - 1)
          @backs[i].y += @map_data.ysize * SIZEY
        elsif i[1] == -1
          @backs[i].y = 0
        end
      end
    else
      for i in @backs.keys
        @backs[i].oy = 0
        @backs[i].y  = i[1] * SIZEY - @oy
      end
    end
    #需要重新描绘的图快
    rangei = (@ox / SIZEX - 1)..((@ox + FBLX) / SIZEX)
    if @oy > @lastoy
      rangej = ([((@lastoy + FBLY) / SIZEY + 1), @oy / SIZEY - 1].max..((@oy + FBLY) / SIZEY))
    elsif @oy < @lastoy
      rangej = ((@oy / SIZEY - 1)...[(@lastoy / SIZEY - 1), ((@oy + FBLY) / SIZEY + 1)].min)
    end
    for i in rangei
      for j in rangej
        for k in 0..2
          draw(i, j, k)
        end
      end
    end
  end

  #--------------------------------------------------------------------------
  #i为x坐标,j为y坐标,k为图层
  def draw(i, j, k)
    i0 = i
    j0 = j
    i -= @map_data.xsize if i >= @map_data.xsize
    i += @map_data.xsize if i < 0
    j -= @map_data.ysize if j >= @map_data.ysize
    j += @map_data.ysize if j < 0
    id = @map_data[i, j, k]
    return if id == 0
    unless @backs[[i, j, k]].nil?
      unless @backs[[i, j, 3]].nil?
        @backs[[i, j, 3]].x = i0 * SIZEX - @ox
        @backs[[i, j, 3]].y = j0 * SIZEY - @oy
      end
      @backs[[i, j, k]].x = i0 * SIZEX - @ox
      @backs[[i, j, k]].y = j0 * SIZEY - @oy
      return
    end
    @backs[[i, j, k]]        = Sprite.new(@viewport)
    @backs[[i, j, k]].x      = i0 * SIZEX - @ox
    @backs[[i, j, k]].y      = j0 * SIZEY - @oy
    @backs[[i, j, k]].z      = k * 2
    @backs[[i, j, k]].bitmap = cachebitmap(id)
    if id < 1024
    elsif id < 1664
      draw_shadow(i, j, k) if id >= 1552 #阴影
    elsif id < 2816
      id1 = (id - 2048) / 48
      unless [2, 3].include?(id1) #动画
        @switches[[i, j, k]]     = true
        @backs[[i, j, k]].bitmap = @backbitmap[id + @count * 10000]
      end
    elsif id < 4352
      id0 = (id - 2816) / 48 % 8
      draw_shadow(i, j, k) #unless id0 == 6#阴影
                           #帮助手册中写A2每行第七个是不会被绘上阴影的,但实际有阴影,这里按照实际
      @backs[[i, j, k]].z += 1 if id0 == 7 #柜台
    end
    return if @passages.nil?
    return unless @passages[id] == 22
    @backs[[i, j, k]].z = 200
  end

  #---------------------------------------------------------------------------
  def cachebitmap(id)
    if @backbitmap[id].nil?
      if id < 1024 #B/C/D/E的情况
        @backbitmap[id] = Bitmap.new(SIZEX, SIZEY)
        bitmapid        = id / 256 + 5
        x               = id % 256 / 128 * 8 * SIZEX + id % 256 % 128 % 8 * SIZEX
        y               = id % 256 % 128 / 8 * SIZEY
        rect            = Rect.new(x, y, SIZEX, SIZEY)
        @backbitmap[id].blt(0, 0, @bitmaps[bitmapid], rect)
      elsif id < 1664 #A5的情况
        @backbitmap[id] = Bitmap.new(SIZEX, SIZEY)
        id0             = id - 1536
        bitmapid        = 4
        x               = id0 % 8 * SIZEX
        y               = id0 / 8 * SIZEY
        rect            = Rect.new(x, y, SIZEX, SIZEY)
        @backbitmap[id].blt(0, 0, @bitmaps[bitmapid], rect)
      elsif id < 2816 #A1的情况
        id0      = id - 2048
        id1      = id0 / 48 #编号,含义见附录
        id2      = id0 % 48 #含义见附录
        bitmapid = 0
        if id1 == 0 #前四张排列比较特殊,浅海水域-深海水域-浅海装饰-深海装饰
          x                       = 0
          y                       = 0
          @backbitmap[id]         = drawbitmap1(x, y, id2, bitmapid)
          x                       += 64
          @backbitmap[id + 10000] = drawbitmap1(x, y, id2, bitmapid)
          x                       += 64
          @backbitmap[id + 20000] = drawbitmap1(x, y, id2, bitmapid)
        elsif id1 == 1
          x                       = 0
          y                       = 96
          @backbitmap[id]         = drawbitmap1(x, y, id2, bitmapid)
          x                       += 64
          @backbitmap[id + 10000] = drawbitmap1(x, y, id2, bitmapid)
          x                       += 64
          @backbitmap[id + 20000] = drawbitmap1(x, y, id2, bitmapid)
        elsif id1 == 2
          x               = 192
          y               = 0
          @backbitmap[id] = drawbitmap1(x, y, id2, bitmapid)
        elsif id1 == 3
          x               = 192
          y               = 96
          @backbitmap[id] = drawbitmap1(x, y, id2, bitmapid)
        elsif id1 % 2 == 0 #从第五张开始就是水域-瀑布-水域-瀑布的顺序了
          x                       = id1 / 4 % 2 * 256
          y                       = id1 / 4 / 2 * 192 + id1 / 2 % 2 * 96
          @backbitmap[id]         = drawbitmap1(x, y, id2, bitmapid)
          x                       += 64
          @backbitmap[id + 10000] = drawbitmap1(x, y, id2, bitmapid)
          x                       += 64
          @backbitmap[id + 20000] = drawbitmap1(x, y, id2, bitmapid)
        else
          x                       = id1 / 4 % 2 * 256 + 192
          y                       = id1 / 4 / 2 * 192 + id1 / 2 % 2 * 96
          @backbitmap[id]         = drawbitmap3(x, y, id2, bitmapid)
          y                       += 32
          @backbitmap[id + 10000] = drawbitmap3(x, y, id2, bitmapid)
          y                       += 32
          @backbitmap[id + 20000] = drawbitmap3(x, y, id2, bitmapid)
        end
      elsif id < 4352 #A2的情况
        id0      = id - 2816
        id1      = id0 / 48 #编号,含义见附录
        id2      = id0 % 48 #含义见附录
        bitmapid = 1
        x        = id1 % 8 * 64
        y        = id1 / 8 * 96
        if id1 % 8 == 7
          @backbitmap[id] = drawbitmap4(x, y, id2, bitmapid)
        else
          @backbitmap[id] = drawbitmap1(x, y, id2, bitmapid)
        end
      elsif id < 5888 #A3的情况
        id0             = id - 4352
        id1             = id0 / 48 #编号,含义见附录
        id2             = id0 % 48 #含义见附录
        bitmapid        = 2
        x               = id1 % 8 * 64
        y               = id1 / 8 * 64
        @backbitmap[id] = drawbitmap2(x, y, id2, bitmapid)
      else #A4的情况
        id0      = id - 5888
        id1      = id0 / 48 #编号,含义见附录
        id2      = id0 % 48 #含义见附录
        bitmapid = 3
        x        = id1 % 8 * 64
        if id1 % 16 < 8
          y               = id1 / 16 * 160
          @backbitmap[id] = drawbitmap1(x, y, id2, bitmapid)
        else
          y               = id1 / 16 * 160 + 96
          @backbitmap[id] = drawbitmap2(x, y, id2, bitmapid)
        end
      end
    end
    return @backbitmap[id]
  end

  #---------------------------------------------------------------------------
  #A1,A2
  #此处的x,y指图片上的xy位置,id范围为0-48,id含义见附录
  #i,j为地图上的xy位置,k为层数,bitmapid为源图片编号
  def drawbitmap1(x, y, id, bitmapid)
    bitmap = Bitmap.new(SIZEX, SIZEY)
    rect   = RECT1[LIST1[id][0]].clone
    rect.x += x
    rect.y += y
    bitmap.blt(0, 0, @bitmaps[bitmapid], rect)
    rect   = RECT1[LIST1[id][1]].clone
    rect.x += x
    rect.y += y
    bitmap.blt(16, 0, @bitmaps[bitmapid], rect)
    rect   = RECT1[LIST1[id][2]].clone
    rect.x += x
    rect.y += y
    bitmap.blt(0, 16, @bitmaps[bitmapid], rect)
    rect   = RECT1[LIST1[id][3]].clone
    rect.x += x
    rect.y += y
    bitmap.blt(16, 16, @bitmaps[bitmapid], rect)
    return bitmap
  end

  #---------------------------------------------------------------------------
  #A3
  #此处的x,y指图片上的xy位置,id范围为0-48,id含义见附录
  #i,j为地图上的xy位置,k为层数,bitmapid为源图片编号
  def drawbitmap2(x, y, id, bitmapid)
    bitmap = Bitmap.new(SIZEX, SIZEY)
    rect   = RECT2[LIST2[id][0]].clone
    rect.x += x
    rect.y += y
    bitmap.blt(0, 0, @bitmaps[bitmapid], rect)
    rect   = RECT2[LIST2[id][1]].clone
    rect.x += x
    rect.y += y
    bitmap.blt(16, 0, @bitmaps[bitmapid], rect)
    rect   = RECT2[LIST2[id][2]].clone
    rect.x += x
    rect.y += y
    bitmap.blt(0, 16, @bitmaps[bitmapid], rect)
    rect   = RECT2[LIST2[id][3]].clone
    rect.x += x
    rect.y += y
    bitmap.blt(16, 16, @bitmaps[bitmapid], rect)
    return bitmap
  end

  #---------------------------------------------------------------------------
  #瀑布
  #此处的x,y指图片上的xy位置,id范围为0-48,id含义见附录
  #i,j为地图上的xy位置,k为层数,bitmapid为源图片编号
  def drawbitmap3(x, y, id, bitmapid)
    bitmap = Bitmap.new(SIZEX, SIZEY)
    rect   = RECT2[LIST3[id][0]].clone
    rect.x += x
    rect.y += y
    bitmap.blt(0, 0, @bitmaps[bitmapid], rect)
    rect   = RECT2[LIST3[id][1]].clone
    rect.x += x
    rect.y += y
    bitmap.blt(16, 0, @bitmaps[bitmapid], rect)
    rect   = RECT2[LIST3[id][2]].clone
    rect.x += x
    rect.y += y
    bitmap.blt(0, 16, @bitmaps[bitmapid], rect)
    rect   = RECT2[LIST3[id][3]].clone
    rect.x += x
    rect.y += y
    bitmap.blt(16, 16, @bitmaps[bitmapid], rect)
    return bitmap
  end

  #---------------------------------------------------------------------------
  #柜台
  #此处的x,y指图片上的xy位置,id范围为0-48,id含义见附录
  #i,j为地图上的xy位置,k为层数,bitmapid为源图片编号
  def drawbitmap4(x, y, id, bitmapid)
    if [28, 29, 30, 31, 33].include?(id) #下
      bitmap = Bitmap.new(SIZEX, 40)
      rect   = Rect.new(32, 48, 16, 16)
      rect.x += x
      rect.y += y
      bitmap.blt(0, 16, @bitmaps[bitmapid], rect)
      rect   = Rect.new(16, 48, 16, 16)
      rect.x += x
      rect.y += y
      bitmap.blt(16, 16, @bitmaps[bitmapid], rect)
    elsif [38, 39, 45].include?(id) #右+下
      bitmap = Bitmap.new(SIZEX, 40)
      rect   = Rect.new(32, 48, 16, 8)
      rect.x += x
      rect.y += y
      bitmap.blt(0, 16, @bitmaps[bitmapid], rect)
      rect   = Rect.new(48, 48, 16, 8)
      rect.x += x
      rect.y += y
      bitmap.blt(16, 16, @bitmaps[bitmapid], rect)
    elsif [40, 41, 43].include?(id) #左+下
      bitmap = Bitmap.new(SIZEX, 40)
      rect   = Rect.new(0, 48, 16, 8)
      rect.x += x
      rect.y += y
      bitmap.blt(0, 16, @bitmaps[bitmapid], rect)
      rect   = Rect.new(16, 48, 16, 8)
      rect.x += x
      rect.y += y
      bitmap.blt(16, 16, @bitmaps[bitmapid], rect)
    elsif [44, 46].include?(id) #左+下+右
      bitmap = Bitmap.new(SIZEX, 40)
      rect   = Rect.new(0, 48, 16, 8)
      rect.x += x
      rect.y += y
      bitmap.blt(0, 16, @bitmaps[bitmapid], rect)
      rect   = Rect.new(48, 48, 16, 8)
      rect.x += x
      rect.y += y
      bitmap.blt(16, 16, @bitmaps[bitmapid], rect)
    else
      bitmap = Bitmap.new(SIZEX, SIZEY)
      rect   = RECT1[LIST1[id][0]].clone
      rect.x += x
      rect.y += y
      bitmap.blt(0, 0, @bitmaps[bitmapid], rect)
      rect   = RECT1[LIST1[id][1]].clone
      rect.x += x
      rect.y += y
      bitmap.blt(16, 0, @bitmaps[bitmapid], rect)
      rect   = RECT1[LIST1[id][2]].clone
      rect.x += x
      rect.y += y
      bitmap.blt(0, 16, @bitmaps[bitmapid], rect)
      rect   = RECT1[LIST1[id][3]].clone
      rect.x += x
      rect.y += y
      bitmap.blt(16, 16, @bitmaps[bitmapid], rect)
      return bitmap
    end
    rect   = RECT1[LIST1[id][0]].clone
    rect.x += x
    rect.y += y
    bitmap.blt(0, 0, @bitmaps[bitmapid], rect)
    rect   = RECT1[LIST1[id][1]].clone
    rect.x += x
    rect.y += y
    bitmap.blt(16, 0, @bitmaps[bitmapid], rect)
    rect   = RECT1[LIST1[id][2]].clone
    rect.x += x
    rect.y += y
    bitmap.blt(0, 24, @bitmaps[bitmapid], rect)
    rect   = RECT1[LIST1[id][3]].clone
    rect.x += x
    rect.y += y
    bitmap.blt(16, 24, @bitmaps[bitmapid], rect)
    return bitmap
  end

  #--------------------------------------------------------------------------
  def draw_shadow(i, j, k)
    return if k != 0
    return if i == 0
    i  -= 1
    id = @map_data[i, j, 0]
    return if id < 4352
    if id < 5888 #A3的情况
      id0 = id - 4352
      id1 = id0 / 48 #编号,含义见附录
      id2 = id0 % 48 #含义见附录
      if [4, 5, 12].include?(id2)
        nexts = true
      elsif j == 0
      elsif @map_data[i, j - 1, 0].between?(4352, 5888)
        nexts = true
      end
    else #A4的情况
      id0 = id - 5888
      id1 = id0 / 48 #编号,含义见附录
      id2 = id0 % 48 #含义见附录
      if id1 % 16 < 8
        if [24, 25, 26, 27, 32, 38, 39].include?(id2)
          nexts = true
        elsif j == 0
        elsif @map_data[i, j - 1, 0] >= 5888
          nexts = true
        end
      else
        if [4, 5, 12].include?(id2)
          nexts = true
        elsif j == 0
        elsif @map_data[i, j - 1, 0] >= 5888
          nexts = true
        end
      end
    end
    return unless nexts
    i                        += 1
    @backs[[i, j, 3]]        = Sprite.new(@viewport)
    @backs[[i, j, 3]].bitmap = @shadow
    @backs[[i, j, 3]].x      = @backs[[i, j, 0]].x
    @backs[[i, j, 3]].y      = @backs[[i, j, 0]].y
    @backs[[i, j, 3]].z      = 0
  end

  #---------------------------------------------------------------------------
  def passages=(value)
    @passages = value
    for i in ([@ox / SIZEX - 1, 0].max)..((@ox + FBLX) / SIZEX)
      for j in ([@oy / SIZEY - 1, 0].max)..((@oy + FBLY) / SIZEY)
        id = @map_data[i, j, 2]
        next if id.nil?
        next unless value[id] == 22
        @backs[[i, j, 2]].z = 200
      end
    end
  end

  #---------------------------------------------------------------------------
  #不知道这个做什么用的
  def flash_data=(value)
    @flash_data = value
  end

  #---------------------------------------------------------------------------
  def update
    if @count1 == ANI
      @count1    = 0
      self.count += 1
    else
      @count1 += 1
    end
  end

  #---------------------------------------------------------------------------
  def count=(value)
    value = 0 if value >= 3
    @count = value
    for i in @switches.keys
      id               = @map_data[i[0], i[1], i[2]]
      @backs[i].bitmap = @backbitmap[id + value * 10000]
    end
  end

  #--------------------------------------------------------------------------
  def visible=(value)
    @visible = value
    for i in @backs.values
      i.visible = value
    end
  end

  #--------------------------------------------------------------------------
  def ox=(value)
    if @ox != value
      @ox = value
      if value >= (@map_data.xsize * SIZEX - FBLX)
        @lastox += @map_data.xsize * SIZEX if @lastox < (@ox - FBLX)
      end
      #人物走路时候
      if @ox % SIZEX != 0
        for i in @backs.values
          i.ox = @ox - @lastox
        end
      else
        refreshox
        @lastox = @ox
      end
    end
  end

  #--------------------------------------------------------------------------
  def oy=(value)
    if @oy != value
      @oy = value
      if value >= (@map_data.ysize * SIZEY - FBLY)
        @lastoy += @map_data.ysize * SIZEY if @lastoy < (@oy - FBLY)
      end
      #人物走路时候
      if @oy % SIZEY != 0
        for i in @backs.values
          i.oy = @oy - @lastoy
        end
      else
        refreshoy
        @lastoy = @oy
      end
    end
  end
end

__END__
Tile_ID编号规则
0-1024       B/C/D/E,每张256个元件
1536-1664    A5,共128个元件
2048-2816    A1,共16个元件,每个元件占48个编号,不同编号含义见样式一,样式三
2816-4352    A2,共32个元件,每个元件占48个编号,不同编号含义见样式一
4352-5888    A3,共32个元件,每个元件占48个编号,不同编号含义见样式二
5888-        A4,共16个元件,每个元件占48个编号,不同编号含义见样式一,样式二

样式一(64 * 96)
编号 图形说明 (左上,右上,左下,右下)
0 -all  10, 9, 6, 5
1 左上  16, 9, 6, 5
2 右上  10, 17, 6, 5
3 左上+右上 16, 17, 6, 5
4 右下  10, 9, 6, 19
5 左上+右下 16, 9, 6, 19
6 右上+右下 10, 17, 6, 19
7 左上+右上+右下 16, 17, 6, 19
8 左下 10, 9, 18, 5
9 左上+左下 16, 9, 18, 5
10 右上+左下 10, 17, 18, 5
11 左上+右上+左下 16, 17, 18, 5
12 右下+左下 10, 9, 18, 19
13 左上+右下+左下 16, 9, 18, 19
14 右上+右下+左下 10, 17, 18, 19
15 左上+右上+右下+左下 16, 17, 18, 19
16 左 8, 9, 4, 5
17 右上+左 8, 17, 4, 5
18 右下+左 8, 9, 4, 19
19 左+右上+右下 8, 17, 4, 19
20 上 2, 1, 6, 5
21 右下+上 2, 1, 6, 19
22 左下+上 2, 1, 18, 5
23 上+左下+右下 2, 1, 18, 19
24 右 10, 11, 6, 7
25 左下+右 10, 11, 18, 7
26 左上+右 16, 11, 6, 7
27 右+左上+左下 16, 11, 18, 7
28 下 10, 9, 14, 13
29 左上+下 16, 9, 14, 13
30 右上+下 10, 17, 14, 13
31 下+左上+右上 16, 17, 14, 13
32 右+左 8, 11, 4, 7
33 上+下 2, 1, 14, 13
34 上+左 0, 1, 4, 5
35 右下+上+左 0, 1, 4, 19
36 上+右 2, 3, 6, 7
37 左下+上+右 2, 3, 18, 7
38 右+下 10, 11, 14, 15
39 左上+右+下 16, 11, 14, 15
40 下+左 8, 9, 12, 13
41 右上+左+下 8, 17, 12, 13
42 -下 0, 3, 8, 11
43 -右 0, 1, 12, 13
44 -上 4, 7, 12, 15
45 -左 2, 3, 14, 15
46 all 0, 3, 12, 15

样式二(64 * 64,屋顶墙壁)
编号 图形说明 (左上,右上,左下,右下)
0 -all 10, 9, 6, 5
1 左 8, 9, 4, 5
2 上 2, 1, 6, 5
3 左+上 0, 1, 4, 5
4 右 10, 11, 6, 7
5 左+右 8, 11, 4, 7
6 上+右 2, 3, 6, 7
7 左+上+右 0, 3, 8, 11
8 下 10, 9, 14, 13
9 左+下 8, 9, 12, 13
10 上+下 2, 1, 14, 13
11 上+左+下 0, 1, 12, 13
12 右+下 10, 11, 14, 15
13 左+右+下 4, 7, 12, 15
14 上+右+下 2, 3, 14, 15
15 all 0, 3, 12, 15

样式三(瀑布动画)
编号 图形说明 (左上,右上,左下,右下)
0 -all 2, 1, 6, 5
1 左 0, 1, 4, 5
2 右 2, 3, 6, 7
3 all 0, 3, 4, 7