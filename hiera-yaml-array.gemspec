$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'hiera/backend/yaml_array_backend'

Gem::Specification.new do |s|
  s.version = Hiera::Backend::Yaml_array_backend::VERSION
  s.name = 'hiera-yaml-array'
  s.email = 'dev@reliantsecurity.com'
  s.authors = 'Reliant Security, Inc.'
  s.summary = 'Yaml hiera backend with support for array interpolations.'
  s.description = 'Fork of Yaml hiera backend with support for array interpolations.'
  s.has_rdoc = false
  s.homepage = 'https://github.com/reliantsolutions/hiera-yaml-array'
  s.license = 'Apache-2.0'
  s.add_dependency 'hiera', '~> 3.0'
  s.add_development_dependency 'rspec', '~> 3.3'
  s.add_development_dependency 'awesome_print', '~> 1.6'
  s.files = Dir['lib/**/*.rb']
  s.files += ['LICENSE']
  s.required_ruby_version = '>= 1.9'
end
