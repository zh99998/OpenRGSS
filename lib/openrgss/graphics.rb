module Graphics
  class <<self
    attr_reader :width, :height
    attr_accessor :entity

    def resize_screen(width, height)
      @width = width
      @height = height
    end

    def update

    end

    def wait(duration)

    end

    def fadeout(duration)

    end

    def fadein(duration)

    end

    def freeze

    end

    def Graphics.transition(duration=10, filename=nil, vague=40)

    end

    def snap_to_bitmap

    end

    def frame_reset

    end

    def play_movie(filename)

    end
  end
end