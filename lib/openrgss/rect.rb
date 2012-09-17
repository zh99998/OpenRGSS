class Rect

  # The x-coordinate of the rectangle's upper left corner.
  attr_accessor :x

  # The y-coordinate of the rectangle's upper left corner.
  attr_accessor :y

  # The rectangle's width.
  attr_accessor :width

  # The rectangle's height.
  attr_accessor :height

  # :call-seq:
  # Rect.new(x, y, width, height)
  # Rect.new
  #
  # Creates a new Rect object.
  #
  # The default values when no arguments are specified are (0, 0, 0, 0).

  def initialize(x=0, y=0, width=0, height=0)
    set(x, y, width, height)
  end

  # :call-seq:
  # set(x, y, width, height)
  # set(rect)
  #
  # Sets all parameters at once.
  #
  # The second format copies all the components from a separate Rect object.

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

  def to_s
    "(#{x}, #{y}, #{width}, #{height})"
  end

  # Sets all components to 0.
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