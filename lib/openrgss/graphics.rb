module Graphics
  FPS_COUNT           = 30
  @frame_rate         = 60
  @frame_count        = 0
  @frame_count_recent = 0
  @skip               = 0
  @ticks              = 0
  @fps_ticks          = 0
  @brightness         = 255
  class <<self
    attr_reader :width, :height
    attr_accessor :entity
    attr_accessor :frame_rate, :frame_count, :brightness

    attr_reader :real_fps

    def resize_screen(width, height)
      @width  = width
      @height = height
    end

    def update
      RGSS.update
      @frame_count += 1

      if @fading
        Graphics.brightness += @fading
        if Graphics.brightness == 0 or Graphics.brightness == 255
          @fading = nil
        end
      end

      if @skip >= 10 or SDL.get_ticks < @ticks + 1000 / frame_rate
        @entity.fill_rect(0, 0, @width, @height, 0x000000)
        RGSS.resources.each { |resource| resource.draw(self) }
        @entity.update_rect(0, 0, 0, 0)

        sleeptime = @ticks + 1000 / frame_rate - SDL.get_ticks
        sleep sleeptime.to_f / 1000 if sleeptime > 0

        @skip  = 0
        @ticks = SDL.get_ticks
      else
        @skip += 1
      end

      @frame_count_recent += 1
      if @frame_count_recent >= FPS_COUNT
        @frame_count_recent = 0
        now                 = SDL.get_ticks
        @real_fps           = FPS_COUNT * 1000 / (now - @fps_ticks)
        @fps_ticks          = now
      end
    end

    def wait(duration)

    end

    def fadeout(duration)
      @fading = 255.to_f / 255 #duration
    end

    def fadein(duration)
      @fading = -255.to_f / 255 ##duration
    end

    def freeze

    end

    def transition(duration=10, filename=nil, vague=40)

    end

    def snap_to_bitmap
      result = Bitmap.new(@width, @height)
      result.entity.put @entity, 0, 0
      result
    end

    def frame_reset

    end

    def play_movie(filename)

    end

    def brightness=(brightness)
      @brightness = brightness < 0 ? 0 : brightness > 255 ? 255 : brightness
      #gamma       = @brightness.to_f / 255
      #SDL::Screen.set_gamma(5,1,1)
      #seems SDL::Screen.set_gamma and SDL::Screen.set_gamma_rmap doesn't work
    end
  end
end