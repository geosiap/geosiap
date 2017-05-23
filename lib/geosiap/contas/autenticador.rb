module Geosiap::Contas::Autenticador

  extend ActiveSupport::Concern

  included do
    before_filter :autenticar!

    helper_method :contas_usuario, :logado?, :pode_gerenciar_permissao?, :edit_registration_url, :logout_url

    rescue_from UsuarioNaoTemAcesso do
      render file: "#{File.dirname(__FILE__)}/401", formats: [:html], status: 401, layout: false
    end

    rescue_from LicencaExpirou do
      render file: "#{File.dirname(__FILE__)}/401_expirou", formats: [:html], status: 401, layout: false
    end
  end

  class UsuarioNaoTemAcesso < StandardError; end
  class LicencaExpirou < StandardError; end
  class NaoEstaLogado < StandardError; end

private

  def token_payload
    @token_payload ||= if token = cookies["#{Rails.env}_token"]
      Geosiap::Contas::JWTToken.new.decode(token)
    end
  end

  def contas_url
    @contas_url ||= Geosiap::Contas::ContasUrl.new(self)
  end

  def contas_usuario
    @contas_usuario ||= Geosiap::Contas::Usuario.find_by_id(token_payload.try(:[], :id))
  end

  def logado?
    contas_usuario.present?
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

  def usuario_tem_acesso?
    return true if contas_usuario.embras? || usuario_perfil.try(:perfil).try(:gestor?)
    usuario_perfil.present? && usuario_perfil.modulos.exists?(modulo.id)
  end

  def autenticar!
    try_development_login
    validate_session

    if logado?
      raise ActionController::RoutingError.new('Cliente não tem linceça ao módulo.') if !tem_licenca?
      raise LicencaExpirou.new('Licença expirou.') if licenca_expirou?
      raise UsuarioNaoTemAcesso.new('Usuário não tem acesso ao módulo.') if !usuario_tem_acesso?
    else
      raise NaoEstaLogado.new('Nenhum usuário logado.') if request.format.json?
      redirect_to contas_url.login_url
    end
  end

  def edit_registration_url
    contas_url.edit_registration_url
  end

  def logout_url
    contas_url.logout_url
  end

  def try_development_login
    if Rails.env.development? && params[:login].present?
      cookies.delete("#{Rails.env}_token", domain: :all)
      if _contas_usuario = Geosiap::Contas::Usuario.find_by_login(params[:login])
        cookies["#{Rails.env}_token"] = {value: Geosiap::Contas::JWTToken.new.encode(_contas_usuario), domain: :all}
      end
    end
  end

  def validate_session
    if session[:contas_usuario_id] && session[:contas_usuario_id] != contas_usuario.try(:id)
      reset_session
    end
    session[:contas_usuario_id] = contas_usuario.id if logado?
  end

end
