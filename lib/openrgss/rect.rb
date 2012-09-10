class Rect

  attr_accessor :x
  attr_accessor :y
  attr_accessor :width
  attr_accessor :height

  def initialize(x, y, width, height)
    set(x, y, width, height)
  end

  def set(x, y, width, height)
    @x = x
    @y = y
    @width = width
    @height = height
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