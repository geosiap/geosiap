class Geosiap::Contas::ContasUrl

  def initialize(context)
    @context = context
  end

  def login_url
    "#{contas_base_url}/login?return_to=#{return_to}"
  end

  def edit_registration_url
    "#{contas_base_url}/registro/alterar?return_to=#{return_to}"
  end

  def logout_url
    "#{contas_base_url}/logout?return_to=#{return_to}"
  end

private

  attr_reader :context

  def return_to
    context.request.original_url
  end

  def contas_base_url
    @contas_base_url ||= Geosiap::Modulos::Url.new(context).for('contas')
  end

end
