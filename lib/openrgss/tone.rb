#The color tone class. Each component is handled with a floating-point value (Float).

class Tone

  # The red balance adjustment value (-255 to 255). Out-of-range values are automatically corrected.
  attr_accessor :red

  # The green balance adjustment value (-255 to 255). Out-of-range values are automatically corrected.
  attr_accessor :green

  # The blue balance adjustment value (-255 to 255). Out-of-range values are automatically corrected.
  attr_accessor :blue

  # The grayscale filter strength (0 to 255). Out-of-range values are automatically corrected.
  #
  # When this value is not 0, processing time is significantly longer than when using tone balance adjustment values alone.
  attr_accessor :gray

  # :call-seq:
  # Tone.new(red, green, blue[, gray])
  # Tone.new
  #
  # Creates a Tone object. If gray is omitted, it is assumed to be 0.
  #
  # The default values when no arguments are specified are (0, 0, 0, 0).

  def initialize(red = 0, green = 0, blue = 0, gray = 0)
    self.red, self.green, self.blue, self.gray = red, green, blue, gray
  end

  # :call-seq:
  # set(red, green, blue[, gray])
  # set(tone) (RGSS3)
  #
  # Sets all components at once.
  #
  # The second format copies all the components from a separate Tone object.

  def set(red, green=0, blue=0, gray=0)
    if red.is_a? Tone
      tone   = red
      @red   = tone.red
      @green = tone.green
      @blue  = tone.blue
      @gray  = tone.gray
    else
      @red   = red
      @green = green
      @blue  = blue
      @gray  = gray
    end
  end

  def red=(value) # :nodoc:
    @red = [[-255, value].max, 255].min
  end

  def green=(value) # :nodoc:
    @green = [[-255, value].max, 255].min
  end

  def blue=(value) # :nodoc:
    @blue = [[-255, value].max, 255].min
  end

  def gray=(value) # :nodoc:
    @gray = [[0, value].max, 255].min
  end



  def to_s # :nodoc:
    "(#{red}, #{green}, #{blue}, #{gray})"
  end

  def blend(tone) # :nodoc:
    self.clone.blend!(tone)
  end

  def blend!(tone) # :nodoc:
    self.red   += tone.red
    self.green += tone.green
    self.blue  += tone.blue
    self.gray  += tone.gray
    self
  end

  def _dump(marshal_depth = -1) # :nodoc:
    [@red, @green, @blue, @gray].pack('E4')
  end

  def self._load(data) # :nodoc:
    new(*data.unpack('E4'))
  end
end