module Geosiap::Contas::Autenticador

  extend ActiveSupport::Concern

  included do
    prepend_before_filter :autenticar!

    helper_method :contas_usuario, :logado?, :edit_registration_url, :logout_url
  end

  class NaoEstaLogado < StandardError; end

private

  def token_payload
    @token_payload ||= if token = cookies["#{Rails.env}_token"]
      Geosiap::Contas::JWTToken.new.decode(token)
    end
  end

  def obj_contas_url
    @obj_contas_url ||= Geosiap::Contas::ContasUrl.new(self)
  end

  def contas_usuario
    @contas_usuario ||= Geosiap::Contas::Usuario.find_by_id(token_payload.try(:[], :id))
  end

  def logado?
    contas_usuario.present?
  end

  def autenticar!
    try_development_login
    validate_session

    if logado?
      raise ActionController::RoutingError.new('Cliente não tem linceça ao módulo.') if !tem_licenca?
      raise Geosiap::Acessos::ControllerExtension::LicencaExpirou.new('Licença expirou.') if licenca_expirou?
      raise Geosiap::Acessos::ControllerExtension::UsuarioNaoTemAcesso.new('Usuário não tem acesso ao módulo.') if !usuario_tem_acesso?
    else
      raise NaoEstaLogado.new('Nenhum usuário logado.') if request.format.json?
      redirect_to obj_contas_url.login_url
    end
  end

  def edit_registration_url
    obj_contas_url.edit_registration_url
  end

  def logout_url
    obj_contas_url.logout_url
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
