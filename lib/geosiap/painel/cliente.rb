class Geosiap::Painel::Cliente < ActiveRecord::Base

  self.table_name_prefix = 'painel_'

  has_many :licencas

  scope :por_modulo, -> (sigla) { joins(licencas: :modulo).where(painel_modulos: {sigla: sigla}) }

end
