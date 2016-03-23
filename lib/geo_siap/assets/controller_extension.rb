module GeoSiap::Assets::ControllerExtension

  extend ActiveSupport::Concern

  include GeoSiap::Assets::Helpers

  included do
    helper_method :geo_stylesheet_link_tag, :geo_javascript_include_tag, :geo_image_tag
  end

end

ActionController::Base.include(GeoSiap::Assets::ControllerExtension)
