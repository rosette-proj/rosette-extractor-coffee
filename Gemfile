source "https://rubygems.org"

gemspec

ruby '1.9.3', engine: 'jruby', engine_version: '1.7.12'

# eventually turn these into dependencies in the gemspec
gem 'rosette-core', path: '~/workspace/rosette-core'
gem 'commonjs-rhino', path: '~/workspace/commonjs-rhino'

group :development, :test do
  gem 'jbundler'
  gem 'pry-nav'
  gem 'rake'
end

group :test do
  gem 'rspec'
  gem 'rr'
end
