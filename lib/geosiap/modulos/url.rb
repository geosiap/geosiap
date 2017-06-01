class Geosiap::Modulos::Url

  def initialize(context)
    @context = context
  end

  def for(modulo_url)
    base_url = context.request.base_url
    domain = context.request.domain
    subdomain = context.request.subdomain

    modulo_url << '-beta' if subdomain.end_with?('-beta')

    if subdomain.present?
      base_url.gsub(subdomain, modulo_url)
    else
      base_url.gsub(domain, "#{modulo_url}.#{domain}")
    end
  end

private

  attr_reader :context

end
