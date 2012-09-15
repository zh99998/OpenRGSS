module Graphics
  FPS_COUNT           = 30
  @frame_rate         = 60
  @frame_count        = 0
  @frame_count_recent = 0
  @skip               = 0
  @ticks              = 0
  @fps_ticks          = 0
  @brightness         = 0
  @width              = 640
  @height             = 480
  @g                  = Bitmap.new(544,416)
  @freeze = true
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

      if @skip >= 10 or SDL.get_ticks < @ticks + 1000 / frame_rate
        @entity.fill_rect(0, 0, @width, @height, 0x000000)
        if (@ors!=RGSS.resources)
          RGSS.resources.sort
          @ors=RGSS.resources
        end
       # RGSS.resources.each { |resource| resource.draw(self)}
       # @entity.update_rect(0, 0, 0, 0)
        unless @freezed
          @g.entity.fill_rect(0, 0, @width, @height, @g.entity.map_rgba(0,0,0,255))
          @g.entity.set_alpha(SDL::RLEACCEL, 0)
          RGSS.resources.each { |resource| resource.draw(@g) }
        end
       # @entity.fill_rect(0, 0, @width, @height, 0x000000)
        #@brier.entity.fill_rect(0, 0, @width, @height, @g.entity.map_rgba(0,0,0,255-@brightness))
        @entity.put @g.entity,0,0
        @entity.drawRect(0,0, @width, @height,@entity.map_rgb(0,0,0),true,255-@brightness)#put @brier.entity,0,0
        @entity.update_rect(0, 0, 0, 0)
        sleeptime = @ticks + 1000.0 / frame_rate - SDL.get_ticks
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
      duration.times{update}
    end

    def fadeout(duration)
      step=255/duration
      duration.times{|i| @brightness=255-i*step;update}
      @brightness=0
    end

    def fadein(duration)
      step=255/duration
      duration.times{|i| @brightness=i*step;update}
      @brightness=255
    end

    def freeze
      @freezed=true
    end

    def transition(duration=10, filename=nil, vague=40)
      if (duration==0)
        @freezed=false;return ;
      end
      step=255/duration
      new_frame = Bitmap.new(@width,@height)
      RGSS.resources.sort
      @ors=RGSS.resources   
      new_frame.entity.fill_rect(0, 0, @width, @height, new_frame.entity.map_rgba(0,0,0,255))
      new_frame.entity.set_alpha(SDL::SRCALPHA, 255)
      RGSS.resources.each { |resource| resource.draw(new_frame) }     
      maker = Bitmap.new(@width,@height)
      duration.times{|i|
        #new_frame.entity.set_alpha(SDL::SRCALPHA|SDL::RLEACCEL,step*i)
        #@g.entity.set_alpha(SDL::SRCALPHA|SDL::RLEACCEL,255-step*i)
        @entity.fill_rect(0, 0, @width, @height, 0x000000)
        maker.entity.fill_rect(0, 0, @width, @height, new_frame.entity.map_rgba(0,0,0,255))
        maker.entity.put @g.entity,0,0
        new_frame.entity.fill_rect(0, 0, @width, @height, new_frame.entity.map_rgba(0,0,0,i*step))
        new_frame.entity.set_alpha(SDL::SRCALPHA, i*step)
        RGSS.resources.each { |resource| resource.draw(new_frame) }   
        maker.entity.put new_frame.entity,0,0
        
        @entity.put maker.entity,0,0
        @entity.update_rect(0, 0, 0, 0)
        #sleep 1/60.0
      }
      # ◊¢“‚ªÿ ’°≠°≠
      @g.entity.set_alpha(0,255);@freezed=false;@brightness=255;update
    end

    def snap_to_bitmap
      #result = Bitmap.new(@width, @height)
      #result.entity.set_alpha(SDL::RLEACCEL, 0)
      #RGSS.resources.each { |resource| resource.draw(result) }
      #result
      return @g.clone
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