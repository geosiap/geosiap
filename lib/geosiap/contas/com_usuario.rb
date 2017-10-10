module Geosiap::Contas::ComUsuario

  extend ActiveSupport::Concern

  included do
    belongs_to :contas_usuario, class_name: 'Geosiap::Contas::Usuario'
    scope :ordem_alfabetica, -> { includes(:contas_usuario).order('contas_usuarios.nome') }

    delegate :email, :username, :nome, to: :contas_usuario, allow_nil: true
    delegate :foto_id, to: :contas_usuario, allow_nil: true unless attribute_method?(:foto_id)
  end

  def foto_url
    if defined?(super)
      super
    else
      contas_usuario.foto_url
    end
  end

  def facebook_url
    "https://www.facebook.com/#{contas_usuario.facebook_id}" if contas_usuario.facebook_id?
  end

end
