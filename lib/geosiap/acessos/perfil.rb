class Geosiap::Acessos::Perfil < ActiveRecord::Base

  self.table_name_prefix = 'acessos_'

  def gestor?
    codigo == 3
  end

end
