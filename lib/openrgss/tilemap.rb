#==============================================================================
# ** Tilemap
#------------------------------------------------------------------------------
#  This class draws the map according to the data given.
#------------------------------------------------------------------------------
# Version 1.05
# Author  Ramiro
#------------------------------------------------------------------------------
# Changelog:
# 11/28/11 (1.00): First Version.
# 11/29/11 (1.03): Waterfall Tiles, A3, A4 Fixed.
# 11/29/11 (1.05): Added Shadows, default configurations.
# http://www.rpgmakervx.net/index.php?showtopic=51646
#==============================================================================
class Tilemap
  #--------------------------------------------------------------------------
  # * Default Configurations
  #--------------------------------------------------------------------------  
  DEFAULT_FRAME_INTERVAL = 20   # Sets the interval of the animated tiles
  DEFAULT_FLASH_INTERVAL = 15   # Sets the interval of flash data
  DEFAULT_SHADOW_VISIBLE = true # Sets the visibility by default of shadows
  
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  # The parts of the autotiles
  AUTOTILE_PARTS = [[18,17,14,13], [ 2,14,17,18], [13, 3,17,18], [ 2, 3,17,18],
                    [13,14,17, 7], [ 2,14,17, 7], [13, 3,17, 7], [ 2, 3,17, 7],
                    [13,14, 6,18], [ 2,14, 6,18], [13, 3, 6,18], [ 2, 3, 6,18],
                    [13,14, 6, 7], [ 2,14, 6, 7], [13, 3, 6, 7], [ 2, 3, 6, 7],
                    [16,17,12,13], [16, 3,12,13], [16,17,12, 7], [12, 3,16, 7], 
                    [10, 9,14,13], [10, 9,14, 7], [10, 9, 6,13], [10, 9, 6, 7],
                    [18,19,14,15], [18,19, 6,15], [ 2,19,14,15], [ 2,19, 6,15],
                    [18,17,22,21], [ 2,17,22,21], [18, 3,22,21], [ 2, 3,21,22],
                    [16,19,12,15], [10, 9,22,21], [ 8, 9,12,13], [ 8, 9,12, 7],
                    [10,11,14,15], [10,11, 6,15], [18,19,22,23], [ 2,19,22,23],
                    [16,17,20,21], [16, 3,20,21], [ 8,11,12,15], [ 8, 9,20,21],
                    [16,19,20,23], [10,11,22,23], [ 8,11,20,23], [ 0, 1, 4, 5]]
  WATERFALL_PIECES = [[ 2, 1, 5, 6], [ 0, 1, 4, 5], [ 2, 3, 6, 7]]
  WALL_PIECES =  [[10, 9, 6, 5], [ 8, 9, 4, 5], [ 2, 1, 6, 5], [ 0, 1, 4, 5],
                  [10,11, 6, 7], [ 8,11, 4, 7], [ 2, 3, 6, 7], [ 0, 3, 4, 7],
                  [10, 9,14,13], [ 8, 9,12,13], [ 2, 1,14,13], [ 0, 1,12,13],
                  [10,11,14,15], [10,11, 6, 7], [ 2, 3,14,15], [ 0, 3,12,15]]
                     
                     
                     
  
  
  # Passabilityes of the passages data                 
  PASSABLE_TILE   = 0x00   
  IMPASSABLE_TILE = 0x01
  OVER_TILE       = 0x10                    
  #--------------------------------------------------------------------------
  # * Class Variables
  #--------------------------------------------------------------------------                
  @@autotile_list = [{}, {}, {}]                  
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------  
  attr_reader :viewport         # The viewport of the map
  attr_reader :visible          # The visibility of the map
  attr_reader :map_data         # The data of the map
  attr_accessor :bitmaps        # The bitmap array of the tileset
  attr_accessor :ox             # The ox of the tilemap
  attr_accessor :oy             # The oy of the tilemap
  attr_accessor :passages       # The passability of the map
  attr_accessor :frame_interval # The frame interval of water animation
  attr_accessor :flash_interval # The flash interval of flash_data
  attr_accessor :shadow_visible # determines if the auto shadows are visible
  attr_accessor :flags
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     viewport : the viewport of the tilemap
  #--------------------------------------------------------------------------
  def initialize(viewport=nil)
    @bitmaps = []
    @layers = [Plane.new(viewport), Plane.new(viewport), Plane.new(viewport),
               Plane.new(viewport), Plane.new(viewport), Plane.new(viewport)]
    @viewport = viewport
    @ox = 0
    @oy = 0
    @layers[0].z = 0   # soil
    @layers[1].z = 50  # soil objects
    @layers[2].z = 100 # upper layer
    @layers[3].z = 250 # upper layer 2   
    @layers[4].z = 300 # flash layer
    @layers[5].z = 75  # shadow layer
    @need_refresh = false
    @map_data = nil
    @passages = nil
    @flash_data = nil
    @visible = true
    @disposed = false
    @layer_bitmaps = []
    @frame = 0
    @frame_count = 0
    @frame_interval = DEFAULT_FRAME_INTERVAL
    @flash_count = 0
    @flash_interval = DEFAULT_FLASH_INTERVAL
    @flash_goal = 0
    @shadow_visible = DEFAULT_SHADOW_VISIBLE
    self.visible = true
  end   
  #--------------------------------------------------------------------------
  # * Checks if a tile is a wall
  #--------------------------------------------------------------------------
   def is_wall?(data)
     return true if data.between?(2288, 2335)
     return true if data.between?(2384, 2431)
     return true if data.between?(2480, 2527)
     return true if data.between?(2576, 2623)
     return true if data.between?(2672, 2719)
     return true if data.between?(2768, 2815)
     return true if data.between?(4736, 5119)
     return true if data.between?(5504, 5887)
     return true if data.between?(6272, 6655)
     return true if data.between?(7040, 7423)
     return true if data > 7807
     false
   end
  #--------------------------------------------------------------------------
  # * Checks if a tile is roof
  #--------------------------------------------------------------------------
   def is_roof?(data)
     return true if data.between?(4352, 4735)
     return true if data.between?(5120, 5503)
     return true if data.between?(5888, 6271)
     return true if data.between?(6656, 7039)
     return true if data.between?(7424, 7807)
     false
   end  
  #--------------------------------------------------------------------------
  # * Checks if a tile is soil
  #--------------------------------------------------------------------------
   def is_soil?(data)
     return true if data.between?(2816, 4351) && !is_table?(data)
     return true if data > 1663 && !is_stair?(data)
     false
   end    
  #--------------------------------------------------------------------------
  # * Checks if a tile is a stair
  #--------------------------------------------------------------------------
   def is_stair?(data)
     return true if data.between?(1541, 1542)
     return true if data.between?(1549, 1550)
     return true if data.between?(1600, 1615)
     false
   end
  #--------------------------------------------------------------------------
  # * Checks if a tile is a table
  #--------------------------------------------------------------------------
   def is_table?(data)
     return true if data.between?(3152, 3199)
     return true if data.between?(3536, 3583)
     return true if data.between?(3920, 3967)
     return true if data.between?(4304, 4351)
     false
   end
   
  def projects_shadow?(data) 
    return true if is_wall?(data)
    return true if is_roof?(data)
    false
  end
  
  #--------------------------------------------------------------------------
  # * Gets the tile by the id
  #--------------------------------------------------------------------------
  def get_bitmap(id, frame=0)
   return @@autotile_list[frame][id] if @@autotile_list[frame][id]
   bmp = Bitmap.new(32, 32)
   if    id < 1024 # B-E
     sub_id = id % 256
     case id / 256
     when 0 # B
       tilemap = @bitmaps[5]
     when 1 # C
       tilemap = @bitmaps[6]
     when 2 # D
       tilemap = @bitmaps[7]
     else   # E
       tilemap = @bitmaps[8]
     end  
     if sub_id < 128
        bmp.blt(0,0, tilemap, Rect.new((sub_id % 8) * 32, (sub_id / 8) * 32, 32, 32))
     else
        sub_id -= 128
        bmp.blt(0,0, tilemap, Rect.new((sub_id % 8) * 32 + 256, (sub_id / 8) * 32, 32, 32))
     end 
   elsif id < 1664 # A5  
     tilemap = @bitmaps[4]
     sub_id = id - 1536
     bmp.blt(0,0, tilemap, Rect.new((sub_id % 8) * 32, (sub_id / 8) * 32, 32, 32))
   elsif id < 2816 # A1
     sub_id = id - 2048
     autotile = sub_id / 48
     auto_id = sub_id % 48
     tilemap = @bitmaps[0]
     case autotile
     when  0 # sea water
       case frame
       when 0
        sx = 0
        sy = 0       
       when 1
        sx = 64
        sy = 0         
       else
        sx = 128
        sy = 0        
       end  
     when  1 # sea deep water
       case frame
       when 0
        sx = 0
        sy = 96   
       when 1
        sx = 64
        sy = 96       
       else
        sx = 128
        sy = 96      
      end        
           
     when  2 # sea rocks
        sx = 192
        sy = 0    
     when  3 # ice rocks
        sx = 192
        sy = 96   
     when  4 # shallow water
       case frame
       when 0
        sx = 256
        sy = 0       
       when 1
        sx = 320
        sy = 0         
       else
        sx = 384
        sy = 0        
       end          
     when  5 # shallow waterfall
       case frame
       when 0
        sx = 448
        sy = 0    
       when 1
        sx = 448
        sy = 32      
       else
        sx = 448
        sy = 64     
       end                     
     when  6 # town water
       case frame
       when 0
        sx = 256
        sy = 96       
       when 1
        sx = 320
        sy = 96         
       else
        sx = 384
        sy = 96       
       end         
     when  7 # town waterfall
       case frame
       when 0
        sx = 448
        sy = 96    
       when 1
        sx = 448
        sy = 128      
       else
        sx = 448
        sy = 160     
       end        
     when  8 # cave water
       case frame
       when 0
        sx = 0
        sy = 192      
       when 1
        sx = 64
        sy = 192        
       else
        sx = 128
        sy = 192        
       end         
     when  9 # cave waterfall
       case frame
       when 0
        sx = 192
        sy = 192      
       when 1
        sx = 192
        sy = 224       
       else
        sx = 192
        sy = 256      
       end         
     when 10 # temple water
       case frame
       when 0
        sx = 0
        sy = 288     
       when 1
        sx = 64
        sy = 288      
       else
        sx = 128
        sy = 288     
       end         
       
     when 11 # temple waterfall
       case frame
       when 0
        sx = 192
        sy = 288   
       when 1
        sx = 192
        sy = 320     
       else
        sx = 192
        sy = 352  
       end        
     when 12 # deep water
       case frame
       when 0
        sx = 256
        sy = 192      
       when 1 
        sx = 320
        sy = 192         
       else
        sx = 384
        sy = 192       
       end         
     when 13 # deep waterfall
       case frame
       when 0
        sx = 448
        sy = 192      
       when 1
        sx = 448
        sy = 224       
       else
        sx = 448
        sy = 256      
       end          
     when 14 # magma water
      case frame
       when 0
        sx = 256
        sy = 288   
       when 1
        sx = 320
        sy = 288       
       else
        sx = 384
        sy = 288      
      end                 
        
     else # magma waterfall
       case frame
       when 0
        sx = 448
        sy = 288     
       when 1
        sx = 448
        sy = 320    
       else
        sx = 448
        sy = 352  
       end          
     end  
     
     if is_wall?(id)
       rects = WATERFALL_PIECES[auto_id]
     else  
      rects = AUTOTILE_PARTS[auto_id]  
     end
     rect = Rect.new(0,0,16,16)
     for i in 0...4
       rect.x = (rects[i] % 4) * 16 + sx
       rect.y = (rects[i] / 4) * 16 + sy
       bmp.blt((i % 2) * 16,(i / 2) * 16,tilemap,rect)
     end      
   elsif id < 4352 # A2
     sub_id = id - 2816
     autotile = sub_id / 48
     auto_id = sub_id % 48
     tilemap = @bitmaps[1]
     sx = (autotile % 8) * 64
     sy = (autotile / 8) * 96
     rects = AUTOTILE_PARTS[auto_id]
     rect = Rect.new(0,0,16,16)
     for i in 0...4
       rect.x = (rects[i] % 4) * 16 + sx
       rect.y = (rects[i] / 4) * 16 + sy
       bmp.blt((i % 2) * 16,(i / 2) * 16,tilemap,rect)
     end
     
   elsif id < 5888 # A3
     sub_id = id - 4352
     autotile = sub_id / 48
     auto_id = sub_id % 48
     tilemap = @bitmaps[2]
     sx = (autotile % 8) * 64
     sy = (autotile / 8) * 64
     rects = WALL_PIECES[auto_id]
     rect = Rect.new(0,0,16,16)
     for i in 0...4
       rect.x = (rects[i] % 4) * 16 + sx
       rect.y = (rects[i] / 4) * 16 + sy
       bmp.blt((i % 2) * 16,(i / 2) * 16,tilemap,rect)
     end     
   else # A4
     sub_id = id - 5888
     autotile = sub_id / 48
     auto_id = sub_id % 48
     tilemap = @bitmaps[3]
     sx = (autotile % 8) * 64
     case autotile / 8
     when 0
       sy = 0
     when 1
       sy = 96
     when 2
       sy = 160
     when 3
       sy = 256
     when 4
       sy = 320
     else  
       sy = 416
     end  
     if is_wall?(id)
       rects = WALL_PIECES[auto_id]
     else  
      rects = AUTOTILE_PARTS[auto_id]
     end 
   
     rect = Rect.new(0,0,16,16)
     for i in 0...rects.size
       rect.x = (rects[i] % 4) * 16 + sx
       rect.y = (rects[i] / 4) * 16 + sy
       bmp.blt((i % 2) * 16,(i / 2) * 16,tilemap,rect)
     end      
     
   end  
   @@autotile_list[frame][id] = bmp
   @@autotile_list[frame][id]   
  end 
  #--------------------------------------------------------------------------
  # * Checks if the tilemap is disposed
  #--------------------------------------------------------------------------
  def disposed?
    @disposed
  end
  #--------------------------------------------------------------------------
  # * Sets the viewport of the object
  #--------------------------------------------------------------------------
  def viewport=(value)
    @layers.each do |i|
      i.viewport = value
    end
    @viewport = value
  end
  #--------------------------------------------------------------------------
  # * Sets if a map is visible
  #--------------------------------------------------------------------------
  def visible=(value)
    @layers.each do |i|
      i.visible = value
    end     
  end
  #--------------------------------------------------------------------------
  # * Gets the flash data
  #--------------------------------------------------------------------------
  def flash_data
    @need_flash_refresh = true
    @flash_data
  end
  #--------------------------------------------------------------------------
  # * Sets the flash data
  #--------------------------------------------------------------------------
  def flash_data=(value)
    @flash_data = value
    @need_flash_refresh = true
  end
  #--------------------------------------------------------------------------
  # * Frame update
  #--------------------------------------------------------------------------
  def update
    if @need_refresh
      refresh 
      @need_refresh=false
    end
    update_animation
    correct_position
    @layers[5].visible = @shadow_visible
    update_flash
  end
  #--------------------------------------------------------------------------
  # * Correct the position of the map
  #--------------------------------------------------------------------------
  def correct_position
    @layers.each do |i|
      i.ox = @ox
      i.oy = @oy
    end    
  end
  #--------------------------------------------------------------------------
  # * Updates the animation of animated tiles
  #--------------------------------------------------------------------------
  def update_animation
    @frame_count = (@frame_count + 1) % @frame_interval
    if @frame_count == 0
      @frame = (@frame + 1) % 3
      if @frame > 2
        @layers[0].bitmap = @layer_bitmaps[1]#.clone
      else
        @layers[0].bitmap = @layer_bitmaps[@frame]#.clone
      end  
    end       
  end
  #--------------------------------------------------------------------------
  # * Updates the flash of the map
  #--------------------------------------------------------------------------
  def update_flash
    if @need_flash_refresh
      @need_flash_refresh = false
      refresh_flash
    end  
    if @flash_count > 0
      @layers[4].opacity = (@layers[4].opacity * (@flash_count - 1) + @flash_goal ) / @flash_count
      @flash_count -= 1
    else
      @flash_count = @flash_interval
      @flash_goal = @flash_goal == 128 ? 0 : 128
    end    
  end
  #--------------------------------------------------------------------------
  # * Sets the map data
  #--------------------------------------------------------------------------
  def map_data=(value)
    return if @map_data == value
    @map_data = value
    if @map_data
      @flash_data = Table.new(@map_data.xsize, @map_data.ysize)
      @need_refresh=true
    end  
  end
  #--------------------------------------------------------------------------
  # * Sets the passages
  #--------------------------------------------------------------------------
  def passages=(value)
    @passages = value
    refresh if @passages
  end
  #--------------------------------------------------------------------------
  # * Dispose the Tilemap
  #--------------------------------------------------------------------------
  def dispose
    @layers.each do |i|
      i.bitmap.dispose if i.bitmap
      i.dispose
    end  
    @layer_bitmaps.each do |i|
      i.dispose if i
    end    
    @disposed = true
  end
  #--------------------------------------------------------------------------
  # * Refresh the Tilemap
  #--------------------------------------------------------------------------
  def refresh
    @frame_count = 0
    return if !@map_data
    # return if !@passages
    @need_refresh = false
    @layer_bitmaps.each do |i|
      i.dispose
    end
    # !!!DEBUG
    print "Refresh the Tilemap\n"
    @layer_bitmaps.clear
    rect = Rect.new(0,0,32,32)
    for l in 0...3
      bitmap = Bitmap.new(@map_data.xsize * 32, @map_data.ysize * 32)
      for i in 0...@map_data.xsize
        for j in 0...@map_data.ysize
          x = i * 32
          y = j * 32
          bitmap.blt(x, y, get_bitmap(@map_data[i, j, 0], l), rect)
        end
      end
      @layer_bitmaps.push(bitmap)
    end  
    
    bitmap = Bitmap.new(@map_data.xsize * 32, @map_data.ysize * 32)
    for i in 0...@map_data.xsize
      for j in 0...@map_data.ysize
        x = i * 32
        y = j * 32
        bitmap.blt(x, y, get_bitmap(@map_data[i, j, 1]), rect)
      end
    end
    @layer_bitmaps.push(bitmap)
    
    bitmap = Bitmap.new(@map_data.xsize * 32, @map_data.ysize * 32)
    for i in 0...@map_data.xsize
      for j in 0...@map_data.ysize
        x = i * 32
        y = j * 32
        #if OVER_TILE #& @passages[@map_data[i, j, 2]] != OVER_TILE
          bitmap.blt(x, y, get_bitmap(@map_data[i, j, 2]), rect)
        #end
      end
    end    
    @layer_bitmaps.push(bitmap)
    bitmap = Bitmap.new(@map_data.xsize * 32, @map_data.ysize * 32)
    for i in 0...@map_data.xsize
      for j in 0...@map_data.ysize
        x = i * 32
        y = j * 32
        #if OVER_TILE #& @passages[@map_data[i, j, 2]] == OVER_TILE
          bitmap.blt(x, y, get_bitmap(@map_data[i, j, 2]), rect)
        #end
      end
    end      

    @layer_bitmaps.push(bitmap)
    @layers[0].bitmap = @layer_bitmaps[@frame]
    @layers[1].bitmap = @layer_bitmaps[3]
    @layers[2].bitmap = @layer_bitmaps[4]
    @layers[3].bitmap = @layer_bitmaps[5]
    create_shadow_bitmap
    
  end
  #--------------------------------------------------------------------------
  # * Creates the shadow bitmap
  #--------------------------------------------------------------------------
  def create_shadow_bitmap
    @layers[5].bitmap.dispose if @layers[5].bitmap
    bmp = Bitmap.new(@map_data.xsize * 32, @map_data.ysize * 32)
    @layers[5].bitmap = bmp
    for i in 1...@map_data.xsize
      for j in 0...@map_data.ysize
        if !projects_shadow?(@map_data[i,j,0])
          if projects_shadow?(@map_data[i-1,j,0]) && (j == 0 || projects_shadow?(@map_data[i-1,j-1,0]))
            bmp.fill_rect(i * 32, j * 32, 16, 32, Color.new(0,0,0,128))
          end
        end  
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Refresh the Flash
  #--------------------------------------------------------------------------
  def refresh_flash
    @flash_count = 0
    @layers[4].bitmap.dispose if @layers[4].bitmap
    return if !@flash_data
    bmp = Bitmap.new(@flash_data.xsize * 32, @flash_data.ysize * 32)
    @layers[4].bitmap = bmp
    for i in 0...@flash_data.xsize
      for j in 0...@flash_data.ysize
        next if @flash_data[i, j] == 0
        x = i * 32
        y = j * 32
        r = ((@flash_data[i, j] / 256) % 16) * 255 / 15
        g = ((@flash_data[i, j] / 16) % 16)  * 255 / 15
        b = (@flash_data[i, j] % 16)         * 255 / 15
        c = Color.new(r, g, b)
        c2 = Color.new(r - 32, g - 32, b - 32)
        bmp.fill_rect(x,y,32,32,c)
        
      end
    end  
  end
  
end