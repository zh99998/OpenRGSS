module Graphics
  class <<self
    attr_reader :width, :height
    attr_accessor :entity

    def resize_screen(width, height)
      @width = width
      @height = height
    end
  end
end