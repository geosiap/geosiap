$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'geo_siap/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'geo_siap'
  s.version     = GeoSiap::VERSION
  s.authors     = ['Fábio Rodrigues']
  s.email       = ['fabio.info@gmail.com']
  s.homepage    = 'http://geosiap.net/'
  s.summary     = 'Funcionalidades comuns dos módulos GeoSiap.'
  s.license     = 'MIT'

  s.files         = Dir['lib/**/*']

  s.add_dependency 'rails', '~> 4.2.3'
  s.add_dependency 'refile'
  s.add_dependency 'search_cop'
  s.add_dependency 'redis-activesupport'
  s.add_dependency 'redis-namespace'
end
