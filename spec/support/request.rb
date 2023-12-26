# frozen_string_literal: true

require 'json'

module Request
  module JsonHelper
    def json_response
      @json_response ||= JSON.parse(response.body)
    end
  end
end
