# The RGBA color class. Each component is handled with a floating-point value (Float).
class Color

  # :call-seq:
  # Color.new(red, green, blue[, alpha])
  # Color.new
  #
  # Creates a Color object. If alpha is omitted, it is assumed to be 255.
  #
  # The default values when no arguments are specified are (0, 0, 0, 0).

  def initialize(red=0, green=0, blue=0, alpha = 255)
    @red   = red
    @blue  = blue
    @green = green
    @alpha = alpha
  end

  # :call-seq:
  # set(red, green, blue[, alpha])
  # set(color)
  #
  # Sets all components at once.
  #
  # The second format copies all the components from a separate Color object.

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

  # The red value (0-255). Out-of-range values are automatically corrected.
  attr_accessor :red

  # The green value (0-255). Out-of-range values are automatically corrected.
  attr_accessor :blue

  # The blue value (0-255). Out-of-range values are automatically corrected.
  attr_accessor :green

  # The alpha value (0-255). Out-of-range values are automatically corrected.
  attr_accessor :alpha

  def to_s() # :nodoc:
    "(#{@red}, #{@blue}, #{@green}, #{@alpha})"
  end

  def _dump(depth = 0) # :nodoc:
    [@red, @green, @blue, @alpha].pack('D*')
  end

  def self._load(string) # :nodoc:
    self.new(*string.unpack('D*')) #fix by zh99998
  end

  def red=(val) # :nodoc:
    @red = [[0, val].max, 255].min
  end

  def blue=(val) # :nodoc:
    @blue = [[0, val].max, 255].min
  end

  def green=(val) # :nodoc:
    @green = [[0, val].max, 255].min
  end

  def alpha=(val) # :nodoc:
    @alpha = [[0, val].max, 255].min
  end

  def ==(other) # :nodoc:
    raise TypeError.new("can't convert #{other.class} into Color") unless self.class == other.class
    return @red == other.red &&
        @green == other.green &&
        @blue == other.blue &&
        @alpha == other.alpha
  end

  def ===(other) # :nodoc:
    raise TypeError.new("can't convert #{other.class} into Color") unless self.class == other.class
    return @red == other.red &&
        @green == other.green &&
        @blue == other.blue &&
        @alpha == other.alpha
  end

  def egl?(other) # :nodoc:
    raise TypeError.new("can't convert #{other.class} into Color") unless self.class == other.class
    return @red == other.red &&
        @green == other.green &&
        @blue == other.blue &&
        @alpha == other.alpha
  end
end