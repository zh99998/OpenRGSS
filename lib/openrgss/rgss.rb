require 'sdl'
require 'logger'

# The following built-in functions are defined in RGSS.

module RGSS

  Log        = Logger.new(STDOUT)
  @resources = []
  @load_path = []

  class << self
    # 标题
    attr_accessor :title

    # get_file的读取路径，目录字符串的数组
    attr_accessor :load_path

    # get_file的自动补全扩展名，以点开头的扩展名字符串的数组
    attr_accessor :load_ext

    # 屏幕上显示的资源，Drawable的数组
    attr_accessor :resources

    # 显示帧率
    attr_accessor :show_fps

    def title=(title) # :NODOC:
      @title = title
      SDL::WM.set_caption(title, title)
    end

    # 在load_path指定的目录中查找文件，会自动补全Autoload_Extname里指定的扩展面给，默认为 .png, .jpg, .gif, .bmp, .ogg, .wma, .mp3, .wav, .mid
    #
    # 在Audio和Bitmap的内部自动调用
    #
    # 如果找不到文件，将返回filename本身

    def get_file(filename)
      ([nil] + RGSS.load_path).each do |directory|
        ([''] + load_ext).each do |extname|
          path = File.expand_path filename + extname, directory
          if File.exist? path
            return path
          end
        end
      end
      filename
    end

    # 初始化RGSS引擎，将会在rgss_main内部自动调用

    def init
      SDL.init SDL::INIT_EVERYTHING
      Graphics.entity = SDL::Screen.open(Graphics.width, Graphics.height, 0, SDL::HWSURFACE|SDL::HWPALETTE)
      SDL::Mixer.open(SDL::Mixer::DEFAULT_FREQUENCY, SDL::Mixer::DEFAULT_FORMAT, SDL::Mixer::DEFAULT_CHANNELS, 1536)
      SDL::TTF.init
      self.title = @title
    end

    # 指定是否显示帧率

    def show_fps=(show_fps)
      if show_fps
        SDL::WM.set_caption("#{title} - #{Graphics.real_fps}fps", title)
      else
        SDL::WM.set_caption(title, title)
      end

      @show_fps = show_fps
    end

    # 引擎的更新，将在Graphics.update和Input.update的内部自动调用

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
  self.load_ext  = ['.png', '.jpg', '.gif', '.bmp', '.ogg', '.wma', '.mp3', '.wav', '.mid']
  self.load_path = []
  # Evaluates the provided block one time only.
  #
  # Detects a reset within a block with a press of the F12 key and returns to the beginning if reset.
  #  rgss_main { SceneManager.run }

  def rgss_main
    RGSS.init
    begin
      yield
    rescue RGSSReset
      RGSS.resources.clear
      retry
    end
  end

  # Stops script execution and only repeats screen refreshing. Defined for use in script introduction.
  #
  # Equivalent to the following.
  #
  #  loop { Graphics.update }

  def rgss_stop

  end

  # Loads the data file indicated by filename and restores the object.
  #
  #  $data_actors = load_data("Data/Actors.rvdata2")
  #
  # This function is essentially the same as:
  #
  #  File.open(filename, "rb") { |f|
  #    obj = Marshal.load(f)
  #  }
  #
  # However, it differs in that it can load files from within encrypted archives.

  def load_data(filename)
    File.open(filename, "rb") { |f|
      obj = Marshal.load(f)
    }
  end

  # Saves the object obj to the data file indicated by filename.
  #
  #  save_data($data_actors, "Data/Actors.rvdata2")
  #
  # This function is the same as:
  #  File.open(filename, "wb") { |f|
  #    Marshal.dump(obj, f)
  #  }

  def save_data(obj, filename)
    File.open(filename, "wb") { |f|
      Marshal.dump(obj, f)
    }
  end

  # Outputs the arguments to the message box. If a non-string object has been supplied as an argument, it will be converted into a string with to_s and output.
  #
  # Returns nil.
  #
  # <b>(Not Implemented in OpenRGSS)</b>
  def msgbox(*args)

  end

  # Outputs obj to the message box in a human-readable format. Identical to the following code (see Object#inspect):
  #
  #  msgbox obj.inspect, "\n", obj2.inspect, "\n", ...
  #
  # Returns nil.
  #
  # <b>(Not Implemented in OpenRGSS)</b>
  def msgbox_p(*args)

  end

  module Drawable
    attr_accessor :x, :y, :viewport, :created_at
    attr_reader :z, :visible

    def initialize(viewport=nil)
      @created_at  = Time.now
      @viewport    = viewport
      self.visible = @visible
    end

    def viewport=(viewport)
      @viewport    = viewport
      self.visible = @visible
    end

    def >(v)
      return false if self.viewport.nil?&&v.viewport
      unless (v.viewport.nil?)
        return false if self.viewport.z<v.viewport.z
        return false if self.viewport.z==v.viewport.z and self.viewport.created_at<v.viewport.created_at
      end
      return false if self.z<v.z
      return false if self.z==v.z and self.y<v.y
      return false if self.z==v.z and self.y==v.y and self.created_at<v.created_at
      return true
    end

    #$a=0
    def <=>(v)
      #print $a+=1
      return 1 if (self>v)
      return -1
    end

    def z=(z)
      return if z==@z
      @z = z

      self.visible = true if @visible and !@disposed
    end

    def y=(y)
      return if y==@y
      @y = y
      # RGSS.resources.sort
      self.visible = true if @visible and !@disposed
    end

    def disposed?
      @disposed
    end

    def dispose
      @disposed = true
      RGSS.resources.delete self
    end

    def visible=(visible)
      #if @visible
      #  RGSS.resources.delete self
      #end
      @visible = visible
      RGSS.resources.delete self unless @visible
      if @visible
        RGSS.resources.delete self
        RGSS.resources<< self
        #   RGSS.resources.sort
      end
=begin
      if @visible
        RGSS.resources.each_with_index { |resource, index|

          #TODO: 简化逻辑
          if resource.viewport
            resource_viewport_z = resource.viewport.z
            resource_viewport_y = resource.viewport.y
          else
            resource_viewport_z = 0
            resource_viewport_y = 0
          end
          if self.viewport
            self_viewport_z = self.viewport.z
            self_viewport_y = self.viewport.y
          else
            self_viewport_z = 0
            self_viewport_y = 0
          end

          return RGSS.resources.insert(index-1, self) if (
          if self_viewport_z == resource_viewport_z
            if self_viewport_y == resource_viewport_y
              if (self.viewport.nil? and resource.viewport) or (self.viewport and resource.viewport and self.viewport.created_at < resource.viewport.created_at)
                true
              elsif (self.viewport and resource.viewport.nil?) or (self.viewport and resource.viewport and self.viewport.created_at > resource.viewport.created_at)
                false
              elsif self.z == resource.z
                if self.y == resource.y
                  self.created_at < resource.created_at
                else
                  self.y < resource.y
                end
              else
                self.y < resource.y
              end
            else
              self_viewport_y < resource_viewport_y
            end
          else
            self_viewport_z < resource_viewport_z
          end
          )

        }
        RGSS.resources += [self]
      end
=end
    end

    def draw(destination=Graphics)
      raise NotImplementedError
    end

  end
end
