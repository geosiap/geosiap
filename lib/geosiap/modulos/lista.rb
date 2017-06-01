class Geosiap::Modulos::Lista

  def initialize(context, contas_usuario)
    @context = context
    @contas_usuario = contas_usuario
  end

  def cliente
    @cliente ||= Geosiap::Acessos::Cliente.find_by_id(cliente_id_cookie) if cliente_id_cookie.present?
  end

  def contas_url
    url.for('contas')
  end

  def acessos_url
    url.for('acessos') if contas_usuario.embras? || usuario_perfil.try(:gestor?) || usuario_perfil.try(:supervisor?)
  end

  def com_acesso
    modulos_com_acesso.map { |modulo| info_com_acesso(modulo) }
  end

  def sem_acesso
    modulos_sem_acesso.map { |modulo| info_sem_acesso(modulo) }
  end

private

  attr_reader :context, :contas_usuario

  def cliente_id_cookie
    @cliente_id_cookie ||= context.send(:cookies)["#{Rails.env}_cliente_id"]
  end

  def url
    @url ||= Geosiap::Modulos::Url.new(context)
  end

  def subdomain
    @subdomain ||= context.request.subdomain.gsub('-beta', '')
  end

  def modulos_com_acesso
    if contas_usuario.embras? || usuario_perfil.try(:gestor?)
      cliente.modulos.order(:nome)
    else
      usuario_perfil.modulos.order(:nome)
    end
  end

  def modulos_sem_acesso
    if contas_usuario.embras? || usuario_perfil.try(:gestor?)
      []
    else
      cliente.modulos.where.not(id: modulos_com_acesso.pluck(:id)).order(:nome)
    end
  end

  def usuario_perfil
    return if cliente.nil? || contas_usuario.nil?
    @usuario_perfil ||= Geosiap::Acessos::UsuarioPerfil.where(cliente_id: cliente.id, usuario_id: contas_usuario.id).take
  end

  def info_com_acesso(modulo)
    {nome: modulo.nome, sigla: modulo.sigla, url: url.for(modulo.url), ativo: (modulo == context.send(:try, :modulo))}
  end

  def info_sem_acesso(modulo)
    {nome: modulo.nome, sigla: modulo.sigla, url: url.for(modulo.url)}
  end

end
