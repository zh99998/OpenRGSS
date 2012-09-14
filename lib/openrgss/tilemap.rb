#偷偷丢Tilemap试写(感谢胃君的地图讲解)10.2更新
#by kissye http://bbs.66rpg.com/thread-104661-1-1.html

class Tilemap
  include RGSS::Drawable

  attr_accessor :bitmaps, :map_data, :flash_data, :flags, :viewport, :ox, :oy

  def initialize(viewport=nil)
    @viewport = viewport
    @bitmaps  = []
    super()
  end

  def update
  end
end