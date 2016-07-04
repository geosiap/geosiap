class Geosiap::Contas::Usuario < ActiveRecord::Base

  include SearchCop

  self.table_name_prefix = 'contas_'

  attachment :foto, type: :image

  def self.find_by_login(login)
    where('lower(username) = :value OR lower(email) = :value', value: login.downcase).take
  end

  def contas_foto_url
    foto_url.try(:concat, '?prefix=contas')
  end

  search_scope :search do
    attributes :nome, :email, :username
  end

end
