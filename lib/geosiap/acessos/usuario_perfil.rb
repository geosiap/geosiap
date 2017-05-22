class Geosiap::Acessos::UsuarioPerfil < ActiveRecord::Base

  self.table_name_prefix = 'acessos_'

  attr_readonly :cliente_id, :usuario_id

  belongs_to :cliente
  belongs_to :usuario
  belongs_to :perfil
  has_and_belongs_to_many :modulos, class_name: 'Geosiap::Acessos::Modulo', join_table: 'public.acessos_usuarios_acessos'

end
