class Geosiap::Painel::Modulo < ActiveRecord::Base

  self.table_name_prefix = 'painel_'

  has_many :licencas

end
