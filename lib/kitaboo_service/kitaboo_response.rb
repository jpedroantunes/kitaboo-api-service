# frozen_string_literal: true

# Encapsulates an HTTP base response
class KitabooResponse
  attr_reader :body, :status_code

  def initialize(http_response)
    @status_code = http_response.code.to_i
    @body = JSON.parse(http_response.read_body)
  end
end
