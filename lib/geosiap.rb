require 'refile'
require 'refile/attachment/active_record'
require 'search_cop'
require 'jwt'

module Geosiap
  require 'geosiap/assets'
  require 'geosiap/assets/helpers'
  require 'geosiap/assets/controller_extension'

  require 'geosiap/contas'
  require 'geosiap/contas/autenticador'
  require 'geosiap/contas/com_usuario'
  require 'geosiap/contas/usuario'
  require 'geosiap/contas/contas_url'
  require 'geosiap/contas/jwt_token'
end
