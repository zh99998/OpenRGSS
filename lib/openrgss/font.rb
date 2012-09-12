##############################################################################
# ╔════════════════════════════════════════════════════════════════════════╗ #
# ║                              ** FONT **                                ║ #
# ╠════════════════════════════════════════════════════════════════════════╣ #
# ║Nachbau der Font-Klasse aus dem Ruby Game Scripting System.             ║ #
# ║Bitte beachten, dass die RGSS-Klassen im Original nur Strukturen aus    ║ #
# ║einer anderen Sprache kapseln, weswegen dieses Script nicht mit den     ║ #
# ║originalen RGSS-Klassen funktioniert.                                   ║ #
# ╠════════════════════════════════════════════════════════════════════════╣ #
# ║                                                                        ║ #
# ║                                                          REX, März 2011║ #
# ╚════════════════════════════════════════════════════════════════════════╝ #
##############################################################################
class Font
  @@cache = {}
  #------------------------------------------------------------------------
  # * Objekt Initialisierung
  #------------------------------------------------------------------------
  def initialize(arg_name=@@default_name, arg_size=@@default_size)
    @name  = arg_name
    @size  = arg_size
    @bold  = @@default_bold
    @italic= @@default_italic
    @color = @@default_color
  end

  #------------------------------------------------------------------------
  # * Prüfe ob eine Schriftart installiert ist.
  #   Dafür wird der gesammte Fontbestand im System ausgelesen und getestet
  #   ob der Parameter dabei ist.
  #------------------------------------------------------------------------
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

  def entity
    result       = @@cache[[@name, @size]] ||= SDL::TTF.open('wqy-microhei.ttc', @size)
    result.style = (@bold ? SDL::TTF::STYLE_BOLD : 0) | (@italic ? SDL::TTF::STYLE_ITALIC : 0)
    result
  end

  #------------------------------------------------------------------------
  # * Öffentliche Variablen
  #------------------------------------------------------------------------
  attr_accessor :name, :size, :bold, :italic, :color, :outline, :shadow, :out_color

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