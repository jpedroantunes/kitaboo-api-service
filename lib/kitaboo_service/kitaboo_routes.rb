# frozen_string_literal: true

# Class encapsulating all available Kitaboo Routes
class KitabooRoutes
  def initialize(base_url:)
    @kitaboo_base_url = base_url
    return unless @kitaboo_base_url.nil?

    raise "The Kitaboo Base URL 'KITABOO_URL' may be defined as an environment variable"
  end

  def notification_route
    "#{@kitaboo_base_url}/DistributionServices/ext/api/UpdateNotification"
  end

  def authentication_route
    "#{@kitaboo_base_url}/DistributionServices/oauth2/authToken?grant_type=client_credentials"
  end

  def orders_route
    "#{@kitaboo_base_url}/DistributionServices/ext/api/v3/order"
  end
end
