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

private

  def contas_session
    @contas_session ||= GeoSiap::Contas::ContasSession.new(self)
  end

  def contas_url
    @contas_url ||= ContasUrl.new(self)
  end

  def contas_usuario
    if Rails.env.development?
      session[:login] = params[:login] if params[:login].present?
      @contas_usuario = GeoSiap::Contas::Usuario.find_by_login(session[:login]) if session[:login].present?
    end

    @contas_usuario ||= GeoSiap::Contas::Usuario.find_by_id(contas_session.usuario_id)
  end

  def logado?
    contas_usuario.present?
  end

  def autenticar!
    if logado?
      raise UsuarioNaoEncontrado.new('Usuário do módulo não encontrado.') if respond_to?(:usuario, true) && usuario.nil?
    else
      redirect_to contas_url.login_url
    end
  end

  def edit_registration_url
    contas_url.edit_registration_url
  end

  def logout_url
    contas_url.logout_url
  end

end
