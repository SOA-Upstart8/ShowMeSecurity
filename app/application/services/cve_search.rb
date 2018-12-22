# frozen_string_literal: true

require 'dry/transaction'

module SMS
  module Service
    # Return OWASP TOP10 category CVE
    class CVESearch
      include Dry::Transaction

      step :get_cves
      step :return_cves

      private

      SMS_NOT_FOUND_MSG = 'Could not find cves on Secbuzzer'

      # call search_cve(query) API
      def get_cves(input)
        Gateway::Api.new(SMS::App.config)
          .search_cve(input)
          .yield_self do |result|
            result.success? ? Success(result.payload) : Failure(result.message)
          end
      rescue StandardError
        Failure('Cannot search the cve categories.')
      end

      def return_cves(input)
        Representer::CVEsList.new(OpenStruct.new).from_json(input)
          .yield_self { |cves| Success(cves) }
      end
    end
  end
end
