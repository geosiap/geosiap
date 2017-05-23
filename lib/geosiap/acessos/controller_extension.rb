module Geosiap::Acessos::ControllerExtension

  extend ActiveSupport::Concern

  included do
    helper_method :pode_gerenciar_permissao?, :mensagem_aviso_bloqueio

    rescue_from UsuarioNaoTemAcesso do
      render file: "#{File.dirname(__FILE__)}/401", formats: [:html], status: 401, layout: false
    end

    rescue_from LicencaExpirou do
      render file: "#{File.dirname(__FILE__)}/401_expirou", formats: [:html], status: 401, layout: false
    end
  end

  class UsuarioNaoTemAcesso < StandardError; end
  class LicencaExpirou < StandardError; end

private

  def usuario_perfil
    @usuario_perfil ||= Geosiap::Acessos::UsuarioPerfil.where(cliente_id: cliente.id, usuario_id: contas_usuario.id).take
  end

  def pode_gerenciar_permissao?
    return true if contas_usuario.embras?

    if usuario_perfil.present?
      usuario_perfil.perfil.gestor? || (usuario_perfil.perfil.supervisor? && usuario_perfil.modulos.exists?(modulo.id))
    else
      false
    end
  end

  def licenca
    @licenca ||= Geosiap::Acessos::Licenca.where(cliente_id: cliente.id, modulo_id: modulo.id).take
  end

  def tem_licenca?
    licenca.present?
  end

  def licenca_expirou?
    licenca.expirou?
  end

  def usuario_tem_acesso?
    return true if contas_usuario.embras? || usuario_perfil.try(:perfil).try(:gestor?)
    usuario_perfil.present? && usuario_perfil.modulos.exists?(modulo.id)
  end

end

ActionController::Base.include(Geosiap::Acessos::ControllerExtension)
