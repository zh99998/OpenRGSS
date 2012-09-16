##############################################################################
# ╔════════════════════════════════════════════════════════════════════════╗ #
# ║                             ** Plane **                                ║ #
# ╠════════════════════════════════════════════════════════════════════════╣ #
# ║Nachbau der Plane-Klasse aus dem Ruby Game Scripting System 2           ║ #
# ║von REX                                                                 ║ #
# ║Diese Klasse funktioniert wie das Original, kann es aber nicht ersetzen.║ #
# ╠════════════════════════════════════════════════════════════════════════╣ #
# ║                                                                        ║ #
# ║                                                          REX, März 2011║ #
# ╚════════════════════════════════════════════════════════════════════════╝ #
##############################################################################
class Plane
  #------------------------------------------------------------------------
  # * Objekt Initialisierung
  #------------------------------------------------------------------------
  def initialize(arg_viewport=nil)
    @sprite = Sprite.new(arg_viewport)
    @src_bitmap = nil
  end

  #------------------------------------------------------------------------
  # * Auslenkung auf der X Achse setzen
  #------------------------------------------------------------------------
  def ox=(val)
    @sprite.ox= (val % (@src_bitmap.nil? ? 1 : @src_bitmap.width))
  end

  #------------------------------------------------------------------------
  # * Auslenkung auf der Y Achse setzen
  #------------------------------------------------------------------------
  def oy=(val)
    @sprite.oy= (val % (@src_bitmap.nil? ? 1 : @src_bitmap.height))
  end

  #------------------------------------------------------------------------
  # * Mach das Bitmap öffentlich
  #------------------------------------------------------------------------
  def bitmap
    @src_bitmap
  end

  #------------------------------------------------------------------------
  # * Lege ein Bitmap fest
  #------------------------------------------------------------------------
  def bitmap=(arg_bmp)
    vp_width = @sprite.viewport.nil? ? \
                            Graphics.width : @sprite.viewport.rect.width
    vp_height = @sprite.viewport.nil? ? \
                            Graphics.height : @sprite.viewport.rect.height
    x_steps = [(vp_width / arg_bmp.width).ceil, 1].max * 2
    y_steps = [(vp_height / arg_bmp.height).ceil, 1].max * 2

    bmp_width = x_steps * arg_bmp.width
    bmp_height = y_steps * arg_bmp.height

    @src_bitmap = arg_bmp
    @sprite.bitmap.dispose unless @sprite.bitmap.nil? or @sprite.bitmap.disposed?
    @sprite.bitmap = Bitmap.new(bmp_width, bmp_height)

    x_steps.times { |ix| y_steps.times { |iy|
      @sprite.bitmap.blt(ix * arg_bmp.width, iy * arg_bmp.height,
                         @src_bitmap, @src_bitmap.rect)
    } }
  end

  #------------------------------------------------------------------------
  # * Ressourcen freigeben
  #------------------------------------------------------------------------
  def dispose
    @sprite.bitmap.dispose unless @sprite.bitmap.nil? or @sprite.bitmap.disposed?
    @sprite.dispose unless @sprite.nil? or @sprite.disposed?
  end

  #------------------------------------------------------------------------
  # * Leite alle nicht definierten Methoden, wie +opacity+ oder +tone+
  #   an den gekapselten Sprite weiter
  #------------------------------------------------------------------------
  def method_missing(symbol, *args)
    @sprite.method(symbol).call(*args)
  end

  #------------------------------------------------------------------------
  # * Öffentliche Instanzvariablen
  #------------------------------------------------------------------------
  attr_reader(:ox, :oy)
end