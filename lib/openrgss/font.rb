# The font class. Font is a property of the Bitmap class.
#
# If there is a "Fonts" folder directly under the game folder, the font files in it can be used even if they are not installed on the system.
#
# You can change the default values set for each component when a new Font object is created.
#
#  Font.default_name = ["Myriad", "Verdana"]
#  Font.default_size = 22
#  Font.default_bold = true

class Font
  @@cache = {}
  # Creates a Font object.

  def initialize(arg_name=@@default_name, arg_size=@@default_size)
    @name  = arg_name
    @size  = arg_size
    @bold  = @@default_bold
    @italic= @@default_italic
    @color = @@default_color
  end

  # Returns true if the specified font exists on the system.

  def Font.exist?(arg_font_name)
    font_key       = 'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Fonts'
    reg_open_keyex = Win32API.new('Advapi32', 'RegOpenKeyEx', 'lpllp', 'l')
    reg_enum_value = Win32API.new('Advapi32', 'RegEnumValue', 'llppiiii', 'l')
    reg_close_key  = Win32API.new('Advapi32', 'RegCloseKey', 'l', 'l')
    open_key       = [0].pack('V')
    # get key
    reg_open_keyex.call(0x80000002, font_key, 0, 0x20019, open_key)
    open_key  = (open_key + [0].pack('V')).unpack('V').first
    # enumerate
    buffer    = "\0"*256
    buff_size = [255].pack('l')
    key_i     = 0
    font_names= []
    while (reg_enum_value.call(open_key, key_i, buffer, buff_size, 0, 0, 0, 0).zero?)
      # get name
      font_names << buffer[0, buff_size.unpack('l').first].sub(/\s\(.*\)/, '')
      # reset
      buff_size = [255].pack('l')
      # increment
      key_i     += 1
    end
    reg_close_key.call(open_key)
    # test
    return font_names.include?(arg_font_name)
  end

  # SDL::TTF对象

  def entity
    result       = @@cache[[@name, @size]] ||= SDL::TTF.open('wqy-microhei.ttc', @size)
    result.style = (@bold ? SDL::TTF::STYLE_BOLD : 0) | (@italic ? SDL::TTF::STYLE_ITALIC : 0)
    result
  end

  # The font name. Include an array of strings to specify multiple fonts to be used in a desired order.
  #
  #  font.name = ["Myriad", "Verdana"]
  # In this example, if the higher priority font Myriad does not exist on the system, the second choice Verdana will be used instead.
  #
  # The default is ["Verdana", "Arial", "Courier New"].
  attr_accessor :name

  # The font size. The default is 24.
  attr_accessor :size

  # The bold flag. The default is FALSE.
  attr_accessor :bold

  # The italic flag. The default is FALSE.
  attr_accessor :italic

  # The flag for outline text. The default is TRUE.
  attr_accessor :outline

  # The flag for shadow text. The default is false (RGSS3). When enabled, a black shadow will be drawn to the bottom right of the character.
  attr_accessor :shadow

  # The font color (Color). Alpha values may also be used. The default is (255,255,255,255).
  #
  # Alpha values are also used when drawing outline (RGSS3) and shadow text.
  attr_accessor :color

  # The outline color (Color). The default is (0,0,0,128).
  attr_accessor :out_color

  class <<self
    [:name, :size, :bold, :italic, :color, :outline, :shadow, :out_color].each { |attribute|
      name = 'default_' + attribute.to_s
      define_method(name) { class_variable_get('@@'+name) }
      define_method(name+'=') { |value| class_variable_set('@@'+name, value) }
    }
  end
  #------------------------------------------------------------------------
  # * Standard Einstellungen aus der RGSS102E.dll.
  #------------------------------------------------------------------------
  @@default_name  = "Arial"
  @@default_size  = 22
  @@default_bold  = false
  @@default_italic= false
  @@default_color = Color.new(255, 255, 255, 255)
end