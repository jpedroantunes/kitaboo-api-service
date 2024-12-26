# frozen_string_literal: true

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
      @kitaboo_auth_token = authenticate
    end

    def remove_kitaboo_user_by_email(email)
      url = URI(@kitaboo_routes.notification_route)
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Authorization"] = "Bearer #{@kitaboo_auth_token}"
      request["Content-Type"] = "application/x-www-form-urlencoded"
      request.body = "userID=#{email}&userDeleted=1"
      KitabooResponse.new(https.request(request))
    end

    def remove_order(order_number)
      url = URI("#{@kitaboo_routes.orders_route}?orderNo=#{order_number}")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Delete.new(url)
      request["Authorization"] = "Bearer #{@kitaboo_auth_token}"
      request["Content-Type"] = "application/x-www-form-urlencoded"
      KitabooResponse.new(https.request(request))
    end

    def create_order(order_number, course_code, student_email, password)
      url = URI(@kitaboo_routes.orders_route)
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url.path)
      request["Authorization"] = "Bearer #{@kitaboo_auth_token}"
      request["Content-Type"] = "application/x-www-form-urlencoded"
      request.body = "orderNo=#{order_number}&bookID=#{course_code}&userID=#{student_email}&firstName=#{student_email}&lastName=#{student_email}&userName=#{student_email}&password=#{password}&email=#{student_email}"
      KitabooResponse.new(https.request(request))
    end

    def is_production_environment
      @is_kitaboo_production
    end

    private

    def authenticate
      url = URI(@kitaboo_routes.authentication_route)
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      if @is_kitaboo_production
        request["Authorization"] = @kitaboo_production_token
        request["Content-Type"] = "application/x-www-form-urlencoded"
      else
        request["Content-Type"] = "application/x-www-form-urlencoded"
        request.body = "grant_type=client_credentials&client_id=#{@kitaboo_client_id}&client_secret=#{@kitaboo_client_secret}"
      end
      KitabooResponse.new(https.request(request)).body[1]["access_token"]
    end
  end
end
