class Geosiap::Acessos::Cliente < ActiveRecord::Base

  self.table_name_prefix = 'acessos_'

  has_many :licencas

  scope :por_modulo, -> (sigla) { joins(licencas: :modulo).where(acessos_modulos: {sigla: sigla}) }

end
