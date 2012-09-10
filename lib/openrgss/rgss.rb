require 'sdl'

module RGSS
  Autoload_Extname = ['.png', '.jpg', '.gif', '.bmp', '.ogg', '.wma', '.mp3', '.wav', '.mid']
  class <<self
    attr_reader :title
    attr_accessor :load_path
    attr_accessor :rgss_version

    def title=(title)

    end

    def get_file(filename)
      ([nil] + RGSS.load_path).each do |directory|
        ([''] + Autoload_Extname).each do |extname|
          path = File.expand_path filename + extname, directory
          if File.exist? path
            return path
          end
        end
      end
      filename
    end

    def init
      SDL.init SDL::INIT_EVERYTHING
      Graphics.entity = SDL::Screen.open(Graphics.width, Graphics.height, 0, SDL::HWSURFACE)
    end
  end
  @load_path = []

  def rgss_main
    RGSS.init
    yield
  end

  def rgss_stop

  end

  def load_data(filename)
    File.open(filename, "rb") { |f|
      obj = Marshal.load(f)
    }
  end

  def save_data(obj, filename)
    File.open(filename, "wb") { |f|
      Marshal.dump(obj, f)
    }
  end

  def msgbox(*args)

  end

  def msgbox_p(*args)

  end


  require_relative 'bitmap'
  require_relative 'color'
  require_relative 'font'
  require_relative 'plane'
  require_relative 'rect'
  require_relative 'sprite'
  require_relative 'table'
  require_relative 'tilemap'
  require_relative 'tone'
  require_relative 'viewport'
  require_relative 'window'
  require_relative 'rgsserror'
  require_relative 'rgssreset'

  require_relative 'audio'
  require_relative 'graphics'
  require_relative 'input'
  require_relative 'rpg'
end