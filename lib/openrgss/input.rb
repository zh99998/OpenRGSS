# A module that handles input data from a gamepad or keyboard.
#
# Managed by symbols rather than button numbers in RGSS3. (RGSS3)
module Input
  Keys = {
      DOWN:     [SDL::Key::DOWN, SDL::Key::S],
      LEFT:     [SDL::Key::LEFT, SDL::Key::A],
      RIGHT:    [SDL::Key::RIGHT, SDL::Key::D],
      UP:       [SDL::Key::UP, SDL::Key::W],
      A:        [SDL::Key::LSHIFT],
      B:        [SDL::Key::X, SDL::Key::ESCAPE],
      C:        [SDL::Key::Z, SDL::Key::RETURN],
      L:        [SDL::Key::PAGEUP],
      R:        [SDL::Key::PAGEDOWN],
      SHIFT:    [SDL::Key::LSHIFT, SDL::Key::RSHIFT],
      CTRL:     [SDL::Key::LSHIFT, SDL::Key::RSHIFT],
      ALT:      [SDL::Key::LSHIFT, SDL::Key::RSHIFT],
      F5:       [SDL::Key::F5],
      F6:       [SDL::Key::F6],
      F7:       [SDL::Key::F7],
      F8:       [SDL::Key::F8],
      F9:       [SDL::Key::F9],
      SHOW_FPS: [SDL::Key::F2],
      RESET:    [SDL::Key::F12]
  }

  Entities = {}

  Keys.each { |key, value|
    const_set(key, key)
    value.each { |entity| Entities[entity] = key }

  }
  @status = {}
  @events = []
  class <<self
    attr_accessor :events

    # Updates input data. As a general rule, this method is called once per frame.

    def update
      RGSS.update
      @status.each { |key, value| @status[key] = value.next }
      while event = events.shift
        key = Entities[event.sym]
        Log.debug('key') { event }
        if event.press
          case key
          when :SHOW_FPS
            RGSS.show_fps = !RGSS.show_fps
          when :RESET
            raise RGSSReset
          else
            @status[key] = 0
          end
        else
          @status.delete key
        end
      end
    end

    # Determines whether the button corresponding to the symbol sym is currently being pressed.
    #
    # If the button is being pressed, returns TRUE. If not, returns FALSE.
    #
    #  if Input.press?(:C)
    #    do_something
    #  end

    def press?(sym)
      @status[sym]
    end

    # Determines whether the button corresponding to the symbol sym is currently being pressed again.
    #
    # "Pressed again" is seen as time having passed between the button being not pressed and being pressed.
    #
    # If the button is being pressed, returns TRUE. If not, returns FALSE.

    def trigger?(sym)
      @status[sym] and @status[sym].zero?
    end

    # Determines whether the button corresponding to the symbol sym is currently being pressed again.
    #
    # Unlike trigger?, takes into account the repeated input of a button being held down continuously.
    #
    # If the button is being pressed, returns TRUE. If not, returns FALSE.

    def repeat?(sym)
      @status[sym] and (@status[sym].zero? or (@status[sym] > 10 and (@status[sym] % 4).zero?))
    end

    # Checks the status of the directional buttons, translates the data into a specialized 4-direction input format, and returns the number pad equivalent (2, 4, 6, 8).
    #
    # If no directional buttons are being pressed (or the equivalent), returns 0.

    def dir4
      case
      when @status[:DOWN]
        2
      when @status[:LEFT]
        4
      when @status[:RIGHT]
        6
      when @status[:UP]
        8
      else
        0
      end
    end

    # Checks the status of the directional buttons, translates the data into a specialized 8-direction input format, and returns the number pad equivalent (1, 2, 3, 4, 6, 7, 8, 9).
    #
    # If no directional buttons are being pressed (or the equivalent), returns 0.

    def dir8
      case
      when @status[:DOWN] && @status[:LEFT]
        1
      when @status[:DOWN] && @status[:RIGHT]
        3
      when @status[:DOWN]
        2
      when @status[:UP] && @status[:LEFT]
        7
      when @status[:UP] && @status[:RIGHT]
        9
      when @status[:UP]
        8
      when @status[:LEFT]
        4
      when @status[:RIGHT]
        6
      else
        0
      end
    end
  end

end