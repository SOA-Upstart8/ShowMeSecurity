# frozen_string_literal: false

require 'http'
module NewsSentence
  module CVE
    # The NewsAPI class is responsible for get news detail.
    class Api
      def initialize(key)
        @api_key = key
      end

      def latest_cve
        Request.new(@api_key).latest.parse
      end

      def search_cve(query)
        Request.new(@api_key).search(query).parse
      end

      # The Request class is responsible for send a http request.
      class Request
        LATEST_PATH = 'https://api.sb.cyber00rn.org/api/vulnerability/?fields=tweet&X-API-KEY='.freeze
        SEARCH_PATH = 'https://api.sb.cyber00rn.org/api/vulnerability/search?'.freeze

        def initialize(key)
          @api_key = key
        end

        def latest
          get(LATEST_PATH + @api_key)
        end

        def search(query)
          get(SEARCH_PATH + "q=#{query}&fields=tweet&X-API-KEY=" + @api_key)
        end

        def get(url)
          result = HTTP.get(url)
          Response.new(result).tap do |response|
            raise(response.raise_error) unless response.successful?
          end
        end
      end

      # The Response class is responsible for error requests.
      class Response < SimpleDelegator
        NotFound = Class.new(StandardError)
        Unauthorized = Class.new(StandardError)
        InvalidCredential = Class.new(StandardError)
        LimitExceeded = Class.new(StandardError)

        HTTP_ERROR = {
          401 => Unauthorized,
          403 => InvalidCredential,
          404 => NotFound,
          429 => LimitExceeded
        }.freeze

        def successful?
          HTTP_ERROR.key?(code) ? false : true
        end

        def raise_error
          HTTP_ERROR[code]
        end
      end
    end
  end
end
