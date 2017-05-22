class Geosiap::Acessos::Licenca < ActiveRecord::Base

  self.table_name_prefix = 'acessos_'

  belongs_to :cliente
  belongs_to :modulo

  def expirou?
    !valido_ate.tomorrow.future?
  end

end
