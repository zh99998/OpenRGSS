module Input
  Keys = {
      DOWN:  [SDL::Key::DOWN, SDL::Key::S],
      LEFT:  [SDL::Key::LEFT, SDL::Key::A],
      RIGHT: [SDL::Key::RIGHT, SDL::Key::D],
      UP:    [SDL::Key::UP, SDL::Key::W],
      A:     [SDL::Key::LSHIFT],
      B:     [SDL::Key::X, SDL::Key::ESCAPE],
      C:     [SDL::Key::Z, SDL::Key::RETURN],
      L:     [SDL::Key::PAGEUP],
      R:     [SDL::Key::PAGEDOWN],
      SHIFT: [SDL::Key::LSHIFT, SDL::Key::RSHIFT],
      CTRL:  [SDL::Key::LSHIFT, SDL::Key::RSHIFT],
      ALT:   [SDL::Key::LSHIFT, SDL::Key::RSHIFT],
      F5:    [SDL::Key::F5],
      F6:    [SDL::Key::F6],
      F7:    [SDL::Key::F7],
      F8:    [SDL::Key::F8],
      F9:    [SDL::Key::F9]
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

    def update
      RGSS.update
      @status.each { |key, value| @status[key] = value.next }
      events.each do |event|
        key = Entities[event.sym]
        Log.debug('key') { event }
        if event.press
          @status[key] = 0
        else
          @status.delete key
        end
      end
      events.clear
    end

    def press?(sym)
      @status[sym]
    end

    def trigger?(sym)
      @status[sym] and @status[sym].zero?
    end

    def repeat?(sym)
      @status[sym] and (@status[sym].zero? or (@status[sym] > 10 and (@status[sym] % 4).zero?))
    end

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
        5
      end
    end

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
        5
      end
    end
  end

end