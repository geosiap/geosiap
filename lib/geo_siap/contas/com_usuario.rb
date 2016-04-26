module GeoSiap::Contas::ComUsuario

  extend ActiveSupport::Concern

  included do
    belongs_to :contas_usuario, class_name: 'GeoSiap::Contas::Usuario'
    delegate :email, :username, :nome, :foto_id, to: :contas_usuario, allow_nil: true
    scope :ordem_alfabetica, -> { includes(:contas_usuario).order('contas_usuarios.nome') }
  end

  def foto_url
    contas_usuario.contas_foto_url
  end

  def facebook_url
    "https://www.facebook.com/#{contas_usuario.facebook_id}" if contas_usuario.facebook_id?
  end

end
