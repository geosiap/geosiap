$:.push File.expand_path('../lib', __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'geosiap'
  s.version     = ''
  s.authors     = ['Fábio Rodrigues']
  s.email       = ['fabio.info@gmail.com']
  s.homepage    = 'http://geosiap.net/'
  s.summary     = 'Funcionalidades comuns dos módulos Geosiap.'
  s.license     = 'MIT'

  s.files         = Dir['lib/**/*']

  s.add_dependency 'rails', '>= 4.1.0'
  s.add_dependency 'search_cop'
  s.add_dependency 'jwt'
  s.add_dependency 'aws-sdk', '2.10.91'
end
