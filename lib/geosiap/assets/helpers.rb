module Geosiap::Assets::Helpers

  include ActionView::Helpers::AssetTagHelper

  GEO_ASSETS_HOST = '//assets.geosiap.net'

  def geo_stylesheet_link_tag
    stylesheet_link_tag "#{GEO_ASSETS_HOST}/dist/1.2/css/geo-framework.min.css", media: 'all'
  end

  def geo_javascript_include_tag
    javascript_include_tag("#{GEO_ASSETS_HOST}/dist/1.2/js/geo-framework.min.js")
  end

  def geo_image_tag(name, options={})
    image_tag("#{GEO_ASSETS_HOST}/images/#{name}", options)
  end

  def geo_image_url(name, options={})
    image_url("#{GEO_ASSETS_HOST}/images/#{name}", options)
  end

  def sprite(id, classe=nil)
    sprite = "#{GEO_ASSETS_HOST}/images/icons.svg##{id}"
    "<svg class='#{classe}'><use xlink:href='#{image_url(sprite)}'/></svg>".html_safe
  end

end
