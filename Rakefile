require 'rake'
require 'rubygems'
require 'rubygems/package_task'
require 'rake/clean'
require 'rdoc/task'

PKG_VERSION = '0.1.4'
PKG_FILES = %w(README.txt LICENSE.txt) + Dir.glob('lib/**/*.rb')

spec = Gem::Specification.new do |s|
  s.name = 'openrgss'
  s.version = PKG_VERSION
  s.summary = "Open-source implementation of the Ruby Game Script System."
  s.description = "Open-source implementation of the Ruby Game Script System."
  s.required_ruby_version = '>= 1.9'
  s.requirements << 'SDL'

  if RUBY_PLATFORM['mingw'] or RUBY_PLATFORM['mswin']
    s.platform = Gem::Platform::CURRENT
    s.add_dependency 'rubysdl-mswin32-1.9'
  else
    s.platform = Gem::Platform::RUBY
    s.add_dependency 'rubysdl'
  end

  s.files = PKG_FILES

  s.has_rdoc = true
  s.extra_rdoc_files = ['README.txt', 'LICENSE.txt']
  s.rdoc_options << "--main" << "README.txt"
  s.rdoc_options << "--encoding" << "UTF-8"

  s.author = 'zh99998'
  s.email = 'zh99998@gmail.com'
  s.homepage = 'http://openrgss.org'
end

Gem::PackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.zip_command = '7z a -tzip' if RUBY_PLATFORM['mingw'] or RUBY_PLATFORM['mswin']
end