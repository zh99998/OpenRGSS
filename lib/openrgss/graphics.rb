module Graphics
  class <<self
    attr_reader :width, :height
    attr_accessor :entity
    attr_accessor :frame_rate, :frame_count, :brightness

    def resize_screen(width, height)
      @width = width
      @height = height
    end

    def update
      while event = SDL::Event.poll
        case event
        when SDL::Event::Quit
          exit
        else #when
          Log.debug "unhandled event: #{event}"
        end
      end
      @entity.fill_rect(0, 0, @width, @height, 0x000000)
      Sprite.all.each do |sprite|
        SDL::Surface.blit(sprite.bitmap.entity, sprite.src_rect.x, sprite.src_rect.y, sprite.src_rect.width, sprite.src_rect.height, @entity, sprite.x-sprite.ox, sprite.y-sprite.oy)
      end
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

    end

    def frame_reset

    end

    def play_movie(filename)

    end
  end
end