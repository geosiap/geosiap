class Geosiap::Acessos::Perfil < ActiveRecord::Base

  self.table_name_prefix = 'acessos_'

  def usuario?
    codigo == 1
  end

  def supervisor?
    codigo == 2
  end

  def gestor?
    codigo == 3
  end

end
