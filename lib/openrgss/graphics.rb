module Graphics
  @frame_rate = 60
  class <<self
    attr_reader :width, :height
    attr_accessor :entity
    attr_accessor :frame_rate, :frame_count, :brightness

    def resize_screen(width, height)
      @width  = width
      @height = height
    end

    def update
      RGSS.update
      @entity.fill_rect(0, 0, @width, @height, 0x000000)
      RGSS.resources.each { |resource| resource.draw(self) }
      @entity.update_rect(0, 0, 0, 0)
    end

    def wait(duration)

    end

    def fadeout(duration)

    end

    def fadein(duration)

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
  end
end