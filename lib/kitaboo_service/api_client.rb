module KitabooService
  # Implement all Kitaboo API calls
  class ApiClient
    def initialize
      # Initialize base configuration to retrieve information from Kitaboo's API
      @kitaboo_routes = KitabooRoutes.new(base_url: KitabooService.configuration.base_url)
      @is_kitaboo_production = KitabooService.configuration.is_kitaboo_production
      @kitaboo_client_id = KitabooService.configuration.client_id
      @kitaboo_client_secret = KitabooService.configuration.client_secret
      @kitaboo_production_token = KitabooService.configuration.kitaboo_production_token
      # The authentication method is different according to the Kitaboo environment to use, this why
      # we have 2 different methods to authenticate and get the token to be used on following requests
      if @is_kitaboo_production
        @kitaboo_auth_token = self.authenticate_production_environment.body[1]['access_token']
      else
        @kitaboo_auth_token = self.authenticate_test_environment.body[1]['access_token']
      end
    end
  end

  private

  def authenticate_production_environment
    url = URI(@kitaboo_routes.authentication_route)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["Authorization"] = @kitaboo_production_token
    request["Content-Type"] = "application/x-www-form-urlencoded"

    KitabooResponse.new(https.request(request))
  end

  def authenticate_test_environment
    url = URI(@kitaboo_routes.authentication_route)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/x-www-form-urlencoded"
    request.body = "grant_type=client_credentials&client_id=#{@kitaboo_client_id}&client_secret=#{@kitaboo_client_secret}"

    KitabooResponse.new(https.request(request))
  end
end