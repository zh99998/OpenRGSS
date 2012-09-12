class Rect

  attr_accessor :x
  attr_accessor :y
  attr_accessor :width
  attr_accessor :height

  def initialize(x=0, y=0, width=0, height=0)
    set(x, y, width, height)
  end

  def set(x, y=0, width=0, height=0)

    if x.is_a? Rect
      rect    = x
      @x      = rect.x
      @y      = rect.y
      @width  = rect.width
      @height = rect.height
    else
      @x      = x
      @y      = y
      @width  = width
      @height = height
    end
  end

  def empty
    set(0, 0, 0, 0)
  end

  # Vergleichsmethode
  def == other
    if other.kind_of?(Rect) then
      x == other.x && y == other.y && width == other.width && height == other.height
    else
      raise TypeError.new("Can't convert #{other.class} to Rect")
    end
  end

  # Serialisiert das Objekt
  def _dump limit
    [x, y, width, height].pack("iiii")
  end

  # Deserialisiert das Objekt
  def self._load str
    new(*str.unpack("iiii"))
  end

end