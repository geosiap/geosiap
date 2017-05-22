class Geosiap::Acessos::Modulo < ActiveRecord::Base

  self.table_name_prefix = 'acessos_'

  has_many :licencas

end
