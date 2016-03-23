class GeoSiap::Contas::ContasSession

  def initialize(context)
    @context = context
    @redis = ActiveSupport::Cache::RedisStore.new('redis://localhost:6379/0/session:contas')
  end

  def usuario_id
    usuario_data.try(:first)
  end

private

  attr_reader :context, :redis

  def usuario_data
    session_data['warden.user.usuario.key']
  end

  def session_data
    @session_data ||= redis.data.get(cookies['_contas_session'].to_s) || {}
  end

  def cookies
    context.send(:cookies)
  end

end
