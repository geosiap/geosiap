module Geosiap::Assets::ControllerExtension

  extend ActiveSupport::Concern

  include Geosiap::Assets::Helpers

  included do
    helper_method :geo_stylesheet_link_tag, :geo_javascript_include_tag, :geo_image_tag, :geo_image_url, :sprite
  end

end

ActionController::Base.include(Geosiap::Assets::ControllerExtension)
