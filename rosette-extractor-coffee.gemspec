$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'rosette/extractors/coffeescript-extractor/version'

Gem::Specification.new do |s|
  s.name     = "rosette-extractor-coffee"
  s.version  = ::Rosette::Extractors::COFFEESCRIPT_EXTRACTOR_VERSION
  s.authors  = ["Cameron Dutro"]
  s.email    = ["camertron@gmail.com"]
  s.homepage = "http://github.com/camertron"

  s.description = s.summary = "Extracts translatable strings from CoffeeScript source code for the Rosette internationalization platform."

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true

  s.add_dependency 'json_pure', '~> 1.8.0'
  s.add_dependency 'commonjs-rhino', '~> 1.0.0'

  s.require_path = 'lib'
  s.files = Dir["{lib,spec}/**/*", "Gemfile", "History.txt", "README.md", "Rakefile", "rosette-extractor-coffee.gemspec"]
end
