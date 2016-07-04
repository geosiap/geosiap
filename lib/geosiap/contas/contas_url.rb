class Geosiap::Contas::ContasUrl

  def initialize(context)
    @context = context
  end

  def login_url
    "#{base_url}/login?return_to=#{return_to}"
  end

  def edit_registration_url
    "#{base_url}/registro/alterar?return_to=#{return_to}"
  end

  def logout_url
    "#{base_url}/logout?return_to=#{return_to}"
  end

private

  attr_reader :context

  def base_url
    _base_url = context.request.base_url
    _base_url.gsub!(context.request.subdomain, base_subdomain) if context.request.subdomain.present?
    _base_url.gsub!('com.br', 'geosiap.net')
    _base_url
  end

  def base_subdomain
    _base_subdomain = 'contas'
    _base_subdomain << '-beta' if context.request.subdomain.end_with?('-beta')
    _base_subdomain
  end

  def return_to
    context.request.original_url
  end

end
