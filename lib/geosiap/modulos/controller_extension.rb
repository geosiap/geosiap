module Geosiap::Modulos::ControllerExtension

  extend ActiveSupport::Concern

  included do
    before_filter :atualizar_cliente
    helper_method :alterar_cliente, :cliente_selecionado, :clientes_disponiveis, :unico_cliente?, :contas_url, :acessos_url, :modulos_com_acesso, :modulos_sem_acesso
  end

private

  def cliente
  end

  def atualizar_cliente
    if contas_usuario.nil?
      cookies.delete("#{Rails.env}_cliente_id", domain: :all)
    elsif cliente.present? && cliente.id.to_s != cliente_cookie
      alterar_cliente(cliente.id)
    elsif unico_cliente?
      alterar_cliente(clientes_disponiveis.first.id)
    end
  end

  def alterar_cliente(novo_cliente_id)
    cookies["#{Rails.env}_cliente_id"] = {value: novo_cliente_id, domain: :all}
  end

  def cliente_selecionado
    @cliente_selecionado ||= Geosiap::Acessos::Cliente.find_by_id(cliente_cookie) if cliente_cookie
  end

  def unico_cliente?
    @unico_cliente ||= clientes_disponiveis.count == 1
  end

  def clientes_disponiveis
    @clientes_disponiveis ||= Geosiap::Acessos::Cliente.por_usuario(contas_usuario).order(:nome_fantasia)
  end

  def contas_url
    @contas_url ||= lista_modulos.contas_url
  end

  def acessos_url
    @acessos_url ||= lista_modulos.acessos_url
  end

  def modulos_com_acesso
    @modulos_com_acesso ||= lista_modulos.com_acesso
  end

  def modulos_sem_acesso
    @modulos_sem_acesso ||= lista_modulos.sem_acesso
  end

  def lista_modulos
    @lista_modulos ||= Geosiap::Modulos::Lista.new(self, contas_usuario)
  end

  def cliente_cookie
    cookies["#{Rails.env}_cliente_id"]
  end

end

ActionController::Base.include(Geosiap::Modulos::ControllerExtension)
