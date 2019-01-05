# frozen_string_literal: true

require 'http'

module SMS
  module Gateway
    # Infrastructure to call SMS API
    class Api
      def initialize(config)
        @config = config
        @request = Request.new(@config)
      end

      def alive?
        @request.get_root.success?
      end

      def all_cve
        @request.all_cve
      end

      def search_cve(query)
        @request.search_cve(query)
      end

      def latest_cve
        @request.latest_cve
      end

      def owasp_cve(category)
        @request.owasp_cve(category)
      end

      def analysis_month
        @request.analysis_month
      end

      def top_5
        @request.top_5
      end

      def vultype
        @request.vultype
      end

      def find_cve_detail(cve_id)
        @request.find_cve_detail(cve_id)
      end

      # HTTP request transmitter
      class Request
        def initialize(config)
          @api_host = config.API_HOST
          @api_root = config.API_HOST + '/api/v1'
        end

        def get_root # rubocop:disable Naming/AccessorMethodName
          call_api('get')
        end

        def all_cve
          call_api('get', ['cves'])
        end

        def search_cve(query)
          call_api('get', ['search', query])
        end

        def latest_cve
          call_api('get', ['latest'])
        end

        def owasp_cve(category)
          call_api('get', ['cves', category])
        end

        def analysis_month
          call_api('get', %w[analysis month])
        end

        def top_5
          call_api('get', ['top_5'])
        end

        def vultype
          call_api('get', ['vultype'])
        end

        def find_cve_detail(cve_id)
          call_api('get', ['find_by_id', cve_id])
        end

        private

        def params_str(params)
          params.map { |key, value| "#{key}=#{value}" }.join('&')
            .yield_self { |str| str ? '?' + str : '' }
        end

        def call_api(method, resources = [], params = {})
          api_path = resources.empty? ? @api_host : @api_root
          url = [api_path, resources].flatten.join('/') + params_str(params)
          puts url
          HTTP.headers('Accept' => 'application/json').send(method, url)
            .yield_self { |http_response| Response.new(http_response) }
        rescue StandardError
          raise "Invalid URL request: #{url}"
        end
      end

      # Decorates HTTP responses with success/error
      class Response < SimpleDelegator
        NotFound = Class.new(StandardError)

        SUCCESS_STATUS = (200..299).freeze

        def success?
          SUCCESS_STATUS.include? code
        end

        def message
          payload['message']
        end

        def payload
          body.to_s
        end
      end
    end
  end
end
