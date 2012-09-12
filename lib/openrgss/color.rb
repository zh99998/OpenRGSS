class Color

  def initialize(red=0, blue=0, green=0, alpha = 255)
    @red   = red
    @blue  = blue
    @green = green
    @alpha = alpha
  end

  def set(red, blue=0, green=0, alpha = 255)
    if red.is_a? Color
      color  = red
      @red   = color.red
      @blue  = color.blue
      @green = color.green
      @alpha = color.alpha
    else
      @red   = red
      @blue  = blue
      @green = green
      @alpha = alpha
    end
    return self
  end

  def to_s()
    "(#{@red}, #{@blue}, #{@green}, #{@alpha})"
  end

  def _dump(depth = 0)
    [@red, @green, @blue, @alpha].pack('D*')
  end

  def self._load(string)
    self.new(*string.unpack('D*')) #fix by zh99998
  end

  def red=(val)
    @red = [[0, val].max, 255].min
  end

  def blue=(val)
    @blue = [[0, val].max, 255].min
  end

  def green=(val)
    @green = [[0, val].max, 255].min
  end

  def alpha=(val)
    @alpha = [[0, val].max, 255].min
  end

  def ==(other)
    raise TypeError.new("can't convert #{other.class} into Color") unless self.class == other.class
    return @red == other.red &&
        @green == other.green &&
        @blue == other.blue &&
        @alpha == other.alpha
  end

  def ===(other)
    raise TypeError.new("can't convert #{other.class} into Color") unless self.class == other.class
    return @red == other.red &&
        @green == other.green &&
        @blue == other.blue &&
        @alpha == other.alpha
  end

  def egl?(other)
    raise TypeError.new("can't convert #{other.class} into Color") unless self.class == other.class
    return @red == other.red &&
        @green == other.green &&
        @blue == other.blue &&
        @alpha == other.alpha
  end

  attr_reader(:red, :blue, :green, :alpha)

  def inspect
    to_s
  end

end