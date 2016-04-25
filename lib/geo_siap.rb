require 'refile'
require 'refile/attachment/active_record'
require 'search_cop'
require 'jwt'

module GeoSiap
  require 'geo_siap/version'

  require 'geo_siap/assets'
  require 'geo_siap/assets/helpers'
  require 'geo_siap/assets/controller_extension'

  require 'geo_siap/contas'
  require 'geo_siap/contas/autenticador'
  require 'geo_siap/contas/com_usuario'
  require 'geo_siap/contas/usuario'
  require 'geo_siap/contas/contas_url'
  require 'geo_siap/contas/jwt_token'
end
