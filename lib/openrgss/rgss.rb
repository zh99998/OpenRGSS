require 'sdl'
require 'logger'
require 'pp'

module RGSS

  Autoload_Extname = ['.png', '.jpg', '.gif', '.bmp', '.ogg', '.wma', '.mp3', '.wav', '.mid']
  Log              = Logger.new(STDOUT)
  @resources       = []
  @load_path       = []

  class <<self
    attr_reader :title
    attr_accessor :load_path
    attr_accessor :rgss_version
    attr_accessor :resources
    attr_accessor :log
    attr_accessor :show_fps

    def title=(title)
      @title = title
      SDL::WM.set_caption(title, title)
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
      SDL::Mixer.open(SDL::Mixer::DEFAULT_FREQUENCY, SDL::Mixer::DEFAULT_FORMAT, SDL::Mixer::DEFAULT_CHANNELS, 1536)
      SDL::TTF.init
      self.title = @title
    end

    def show_fps=(show_fps)
      if show_fps
        SDL::WM.set_caption("#{title} - #{Graphics.real_fps}fps", title)
      else
        SDL::WM.set_caption(title, title)
      end

      @show_fps = show_fps
    end

    def update
      if @show_fps and @fps != Graphics.real_fps
        SDL::WM.set_caption("#{title} - #{Graphics.real_fps}fps", title)
        @fps = Graphics.real_fps
      end

      while event = SDL::Event.poll
        case event
        when SDL::Event::Quit
          exit
        when SDL::Event::KeyDown, SDL::Event::KeyUp
          Input.events << event
        else #when
             #Log.debug "unhandled event: #{event}"
        end
      end
    end
  end

  def rgss_main
    RGSS.init
    begin
      yield
    rescue RGSSReset
      RGSS.resources.clear
      retry
    end
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

  module Drawable
    attr_accessor :x, :y
    attr_reader :z, :visible
    include Comparable

    def z=(z)
      @z = z
      self.visible = true if @visible and !@disposed
    end

    def y=(y)
      @y = y
      self.visible = true if @visible and !@disposed
    end

    def <=>(other)
      result = if @z == other.z
        @y <=> other.y
      else
        @z <=> other.z
      end
      result
    end

    def ==(other)
      eql?(other)
    end

    def disposed?
      @disposed
    end

    def dispose
      @disposed = true
      RGSS.resources.delete self
    end

    def visible=(visible)
      if @visible
        RGSS.resources.delete self
      end
      @visible = visible
      if @visible
        RGSS.resources.each_with_index { |resource, index|
          return RGSS.resources.insert(index, self) if resource > self
        }
        RGSS.resources << self
      end
    end

    def draw(destination=Graphics)
      raise NotImplementedError
    end
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