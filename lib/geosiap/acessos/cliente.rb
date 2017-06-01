class Geosiap::Acessos::Cliente < ActiveRecord::Base

  self.table_name_prefix = 'acessos_'

  has_many :licencas
  has_many :modulos, through: :licencas
  has_many :usuario_perfis

  scope :por_modulo, -> (sigla) { joins(licencas: :modulo).where(acessos_modulos: {sigla: sigla}) }

  scope :por_usuario, -> (usuario) do
    return if usuario.embras?
    joins(:usuario_perfis).where(acessos_usuario_perfis: {usuario_id: usuario.id})
  end

end
