class Geosiap::Contas::Usuario < ActiveRecord::Base

  include SearchCop

  self.table_name_prefix = 'contas_'

  def self.find_by_login(login)
    where('lower(username) = :value OR lower(email) = :value', value: login.downcase).take
  end

  def foto_url
    Geosiap::Contas::S3.new.open(foto_id).url
  end

  search_scope :search do
    attributes :nome, :email, :username
  end

end
