# The module that carries out graphics processing.

module Graphics
  FPS_COUNT                    = 30
  @frame_rate                  = 60
  @frame_count                 = 0
  @frame_count_recent          = 0
  @skip                        = 0
  @ticks                       = 0
  @fps_ticks                   = 0
  @brightness                  = 255
  @width                       = 640
  @height                      = 480
  @graphics_render_target      = Bitmap.new(544,416)  # need rebuild when resize.
  @freeze                      = false # or true?
  class <<self
    attr_reader :width, :height
    attr_accessor :entity
    attr_reader :real_fps

    # The number of times the screen is refreshed per second. The larger the value, the more CPU power is required. Normally set at 60.
    #
    # Changing this property is not recommended, but it can be set anywhere from 10 to 120. Out-of-range values are automatically corrected.
    attr_accessor :frame_rate

    # The screen's refresh rate count. Set this property to 0 at game start and the game play time (in seconds) can be calculated by dividing this value by the frame_rate property value.
    attr_accessor :frame_count

    # The brightness of the screen. Takes a value from 0 to 255. The fadeout, fadein, and transition methods change this value internally, as required.
    attr_accessor :brightness

    # Refreshes the game screen and advances time by 1 frame. This method must be called at set intervals.
    #
    #  loop do
    #    Graphics.update
    #    Input.update
    #    do_something
    #  end

    def update
      RGSS.update
      @frame_count += 1
      if @skip >= 10 or SDL.get_ticks < @ticks + 1000 / frame_rate
        @entity.fill_rect(0, 0, @width, @height, 0x000000)
        if (@old_resources!=RGSS.resources)            # Maybe here can make a dirty mark
          RGSS.resources.sort!
          @old_resources=RGSS.resources.clone
        end

        unless @freezed                  # redraw only when !freezed
          @graphics_render_target.entity.fill_rect(0, 0, @width, @height, @graphics_render_target.entity.map_rgba(0,0,0,255))
          @graphics_render_target.entity.set_alpha(SDL::RLEACCEL, 0)
          RGSS.resources.each { |resource| resource.draw(@graphics_render_target) }
        end
        @entity.put @graphics_render_target.entity,0,0
        @entity.drawRect(0,0, @width, @height,@entity.map_rgb(0,0,0),true,255-@brightness) # ���ƻ�ɫ���ǡ�
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

    # Waits for the specified number of frames. Equivalent to the following:
    #
    #  duration.times do
    #    Graphics.update
    #  end

    def wait(duration)
      duration.times{update}
    end

    # Performs a fade-out of the screen.
    #
    # duration is the number of frames to spend on the fade-out.

    def fadeout(duration)
      step=255/duration
      duration.times{|i| @brightness=255-i*step;update}
      @brightness=0
    end

    # Performs a fade-in of the screen.
    #
    # duration is the number of frames to spend on the fade-in.

    def fadein(duration)
      step=255/duration
      duration.times{|i| @brightness=i*step;update}
      @brightness=255
    end

    # Freezes the current screen in preparation for transitions.
    #
    # Screen rewrites are prohibited until the transition method is called.

    def freeze
      @freezed=true
    end

    # Carries out a transition from the screen frozen by Graphics.freeze to the current screen.
    #
    # duration is the number of frames the transition will last. The default is 10.
    #
    # filename specifies the file name of the transition graphic. When not specified, a standard fade will be used. Also automatically searches files included in RGSS-RTP and encrypted archives. File extensions may be omitted.
    #
    # vague sets the ambiguity of the borderline between the graphic's starting and ending points. The larger the value, the greater the ambiguity. The default is 40.

    def transition(duration=10, filename=nil, vague=40)
      if (duration==0)
        @freezed=false;return ;
      end
      if (filename.nil?) # û�н���ͼ����ȫ0
        imgmap=Array.new(@width){Array.new(@height){255}} 
      else               # Ԥ���?��ͼ����ɸõ�����ȼ�͸���ȣ�ԽСԽ��
        b=Bitmap.new(filename);pfb =  b.entity.format
        imgmap=Array.new(@width){|x|Array.new(@height){|y|[pfb.get_rgb(b.entity[x,y])[0],1].max}}
        #TODO :����b
      end
      step=255/duration
      new_frame = Bitmap.new(@width,@height)
      RGSS.resources.sort!
      @old_resources=RGSS.resources.clone
      new_frame.entity.fill_rect(0, 0, @width, @height, new_frame.entity.map_rgba(0,0,0,255))
      new_frame.entity.set_alpha(SDL::SRCALPHA, 255)
      RGSS.resources.each { |resource| resource.draw(new_frame) }
      # �����֡��bitmap

      pf  =  new_frame.entity.format
      new_frame.entity.lock
      picmap=Array.new(@width){|x| Array.new(@height){|y| pf.getRGBA(new_frame.entity[x,y])}}   # ���������λ������ٶ������ȡ��
      new_frame.entity.unlock
      maker = Bitmap.new(@width,@height) 
      # ����Ԥ�ϳɲ�
      maker.entity.fill_rect(0, 0, @width, @height, new_frame.entity.map_rgba(0,0,0,255))
      maker.entity.put @graphics_render_target.entity,0,0             # ����ͼ�ϸ��Ǿ���һ��͸���ȵ�ͼ��
      # ��Ͻ����
      new_frame.entity.lock
      @width.times{|x|@height.times{|y| 
        if (imgmap[x][y]!=0)
          new_frame.entity[x,y]=pf.map_rgba(picmap[x][y][0],picmap[x][y][1],picmap[x][y][2],[255/(duration/(255.0/imgmap[x][y])),255].min) 
          #TODO : �����alpha�����һ�������ﵽ255��ע�⣬�Ⲣ����RM�Ĵ��?ʽ��
        else
          new_frame.entity[x,y]=pf.map_rgba(picmap[x][y][0],picmap[x][y][1],picmap[x][y][2],255)
        end
      }}
      new_frame.entity.unlock
      duration.times{|i|
        @entity.fill_rect(0, 0, @width, @height, 0x000000)
        maker.entity.put new_frame.entity,0,0 # alpha �ϳ�
        @entity.put maker.entity,0,0 
        @entity.update_rect(0, 0, 0, 0)
      }
      # TODO: ���ա���
      @graphics_render_target.entity.set_alpha(0,255);@freezed=false;@brightness=255;update # �ָ����ԡ�
    end

    # Gets the current game screen image as a bitmap object.
    #
    # This reflects the graphics that should be displayed at that point in time, without relation to the use of the freeze method.
    #
    # The created bitmap must be freed when it is no longer needed.

    def snap_to_bitmap
      return @graphics_render_target.clone # clone������ʵ�֣�ע�����
    end

    # Resets the screen refresh timing. Call this method after a time-consuming process to prevent excessive frame skipping.

    def frame_reset

    end

    # Changes the size of the game screen.
    #
    # Specify a value up to 640 × 480 for width and height.

    def resize_screen(width, height)
      @width  = width
      @height = height
    end

    #Plays the movie specified by filename.
    #
    #Returns process after waiting for playback to end.

    def play_movie(filename)

    end

    def brightness=(brightness) # :nodoc:
      @brightness = brightness < 0 ? 0 : brightness > 255 ? 255 : brightness
      #gamma       = @brightness.to_f / 255
      #SDL::Screen.set_gamma(5,1,1)
      #seems SDL::Screen.set_gamma and SDL::Screen.set_gamma_rmap doesn't work
    end
  end
end