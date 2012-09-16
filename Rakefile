require 'rake'
require 'rubygems'
require 'rubygems/package_task'
require 'rake/clean'

PKG_VERSION = 0.1
PKG_FILES = %w(lib README.txt LICENSE.txt) 

spec = Gem::Specification.new do |s|
  s.name = 'openrgss'
  s.version = PKG_VERSION
  s.summary = "Open-source implementation of the Ruby Game Script System."
  s.description = "Open-source implementation of the Ruby Game Script System."
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9'
  s.requirements << 'SDL'
  s.add_dependency 'rubysdl'

  s.files = PKG_FILES
  s.require_path = ['lib']
  
  #s.rdoc_options
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.txt', 'LICENSE.txt']

  s.author = 'zh99998'
  s.email = 'zh99998@gmail.com'
  s.homepage = 'http://openrgss.org'
end

Gem::PackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end
