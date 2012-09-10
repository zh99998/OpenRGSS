module RGSS
  module_function
  attr_reader :title
  attr_accessor :load_path

  def title=(title)

  end

  def rgss_main
    yield
  end

  def rgss_stop

  end

  def load_data(filename)
    File.open(filename, "rb") { |f|
      obj = Marshal.load(f)
    }
  end

  def save_data(obj, filename)
    File.open(filename, "wb") { |f|
      Marshal.dump(obj, f)
    }
  end

  def msgbox(*args)

  end

  def msgbox_p(*args)

  end
end

require_relative 'bitmap'
require_relative 'color'
require_relative 'font'
require_relative 'plane'
require_relative 'rect'
require_relative 'sprite'
require_relative 'table'
require_relative 'tilemap'
require_relative 'tone'
require_relative 'viewport'
require_relative 'window'
require_relative 'rgsserror'
require_relative 'rgssreset'

require_relative 'audio'
require_relative 'graphics'
require_relative 'input'