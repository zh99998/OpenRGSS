# The multidimensional array class. Each element is an integer of 2 signed bytes ranging from -32,768 to 32,767.
#
# Ruby's Array class does not run efficiently when handling large amounts of data, hence the inclusion of this class.

class Table
  attr_reader :xsize, :ysize, :zsize

  # Creates a Table object. Specifies the size of each dimension in the multidimensional array. 1-, 2-, and 3-dimensional arrays are possible. Arrays with no parameters are also permitted.

  def initialize(xsize, ysize=1, zsize=1)
    @xsize = xsize
    @ysize = ysize
    @zsize = zsize
    @data  = Array.new(@xsize*@ysize*@zsize, 0)
  end

  # Changes the size of the array. All data from before the size change is retained.

  def resize(xsize, ysize=1, zsize=1)

  end

  # :call-seq:
  # self[x]
  # self[x, y]
  # self[x, y, z]
  #
  # Accesses the array's elements. Pulls the same number of arguments as there are dimensions in the created array. Returns nil if the specified element does not exist.

  def [](x, y=0, z=0)
    return nil if x >= @xsize or y >= @ysize
    @data[x + y * @xsize + z * @xsize * @ysize]
  end

  def []=(x, y=0, z=0, v) #:nodoc:
    @data[x + y * @xsize + z * @xsize * @ysize]=v
  end



  def self._load(s) #:nodoc:
    Table.new(1).instance_eval {
      @size, @xsize, @ysize, @zsize, xx, *@data = s.unpack('LLLLLS*')
      self
    }
  end

  def _dump(d = 0) #:nodoc:
    [@size, @xsize, @ysize, @zsize, @xsize*@ysize*@zsize, *@data].pack('LLLLLS*')
  end
end
