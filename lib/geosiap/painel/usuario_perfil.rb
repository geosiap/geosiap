class Geosiap::Painel::UsuarioPerfil < ActiveRecord::Base

  self.table_name_prefix = 'painel_'

  attr_readonly :cliente_id, :usuario_id

  belongs_to :cliente
  belongs_to :usuario
  has_and_belongs_to_many :modulos, class_name: 'Geosiap::Painel::Modulo', join_table: 'public.painel_usuarios_acessos'

end
