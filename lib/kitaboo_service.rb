# frozen_string_literal: true

require_relative "kitaboo_service/version"

# Implement all Sophia API calls
module KitabooService
  autoload :ApiClient, "kitaboo_service/api_client"
  autoload :KitabooRoutes, "kitaboo_service/kitaboo_routes"
  autoload :KitabooResponse, "kitaboo_service/kitaboo_response"

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  # Implement Kitaboo Service configuration
  class Configuration
    attr_reader :base_url, :is_kitaboo_production, :client_id, :client_secret, :kitaboo_production_token

    def initialize
      @base_url = ""
      @client_id = ""
      @client_secret = ""
      @kitaboo_production_token = ""
      @is_kitaboo_production = true
    end

    def set_configuration(base_url:, is_kitaboo_production:, client_id:, client_secret:, kitaboo_production_token:)
      @base_url = base_url
      @is_kitaboo_production = is_kitaboo_production
      @kitaboo_production_token = kitaboo_production_token
      @client_id = client_id
      @client_secret = client_secret
    end
  end
end
