module GeoSiap::Contas::Autenticador

  extend ActiveSupport::Concern

  included do
    before_filter :autenticar!

    helper_method :contas_usuario, :logado?, :edit_registration_url, :logout_url

    rescue_from UsuarioNaoEncontrado do
      render file: "#{File.dirname(__FILE__)}/401", formats: [:html], status: 401, layout: false
    end
  end

  class UsuarioNaoEncontrado < StandardError; end
  class NaoEstaLogado < StandardError; end

private

  def token_payload
    @token_payload ||= if token = cookies["#{Rails.env}_token"]
      GeoSiap::Contas::JWTToken.new.decode(token)
    end
  end

  def contas_url
    @contas_url ||= GeoSiap::Contas::ContasUrl.new(self)
  end

  def contas_usuario
    @contas_usuario ||= GeoSiap::Contas::Usuario.find_by_id(token_payload.try(:[], :id))
  end

  def logado?
    contas_usuario.present?
  end

  def autenticar!
    try_development_login
    validate_session

    if logado?
      raise UsuarioNaoEncontrado.new('Usuário do módulo não encontrado.') if respond_to?(:usuario, true) && usuario.nil?
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
      if _contas_usuario = GeoSiap::Contas::Usuario.find_by_login(params[:login])
        cookies["#{Rails.env}_token"] = {value: GeoSiap::Contas::JWTToken.new.encode(_contas_usuario), domain: :all}
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
