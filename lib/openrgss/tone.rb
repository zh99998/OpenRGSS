#from gosu-rgss

class Tone
  attr_reader :red, :green, :blue, :gray

  def initialize(red = 0, green = 0, blue = 0, gray = 0)
    self.red, self.green, self.blue, self.gray = red, green, blue, gray
  end

  def red=(value)
    @red = [[-255, value].max, 255].min
  end

  def green=(value)
    @green = [[-255, value].max, 255].min
  end

  def blue=(value)
    @blue = [[-255, value].max, 255].min
  end

  def gray=(value)
    @gray = [[0, value].max, 255].min
  end

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

  def to_s
    "(#{red}, #{green}, #{blue}, #{gray})"
  end

  def blend(tone)
    self.clone.blend!(tone)
  end

  def blend!(tone)
    self.red   += tone.red
    self.green += tone.green
    self.blue  += tone.blue
    self.gray  += tone.gray
    self
  end

  # Dump to String (compatible with RGSS Tone dump format)
  def _dump(marshal_depth = -1)
    [@red, @green, @blue, @gray].pack('E4')
  end

  # Load from String (compatible with RGSS Tone dump format)
  def self._load(data)
    new(*data.unpack('E4'))
  end
end