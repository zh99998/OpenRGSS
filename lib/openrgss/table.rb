class Table
  attr_accessor :xsize, :ysize, :zsize, :size

  def initialize(*args)
    @size                 = args.length
    @xsize, @ysize, @zsize=args
    @xsize                ||=1
    @ysize                ||=1
    @zsize                ||=1
    @data                 = Array.new(@xsize*@ysize*@zsize, 0)
  end

  def []=(x, y=0, z=0, v)
    @data[x + y * @xsize + z * @xsize * @ysize]=v
  end

  def [](x, y=0, z=0)
    return nil if x >= @xsize or y >= @ysize
    @data[x + y * @xsize + z * @xsize * @ysize]
  end

  def self._load(s)
    Table.new(1).instance_eval {
      @size, @xsize, @ysize, @zsize, xx, *@data = s.unpack('LLLLLS*')
      self
    }
  end

  def _dump(d = 0)
    [@size, @xsize, @ysize, @zsize, @xsize*@ysize*@zsize, *@data].pack('LLLLLS*')
  end
end
