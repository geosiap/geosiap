class Geosiap::Painel::Licenca < ActiveRecord::Base

  self.table_name_prefix = 'painel_'

  belongs_to :cliente
  belongs_to :modulo

  def expirou?
    !valido_ate.tomorrow.future?
  end

end
