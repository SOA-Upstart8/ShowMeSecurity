# frozen_string_literal: true

require 'dry/transaction'

module SMS
  module Service
    # Return OWASP TOP10 category CVE
    class CVEOwasp
      include Dry::Transaction

      step :retrieve_cves
      step :return_cves

      private

      SMS_NOT_FOUND_MSG = 'Could not find cves on Secbuzzer'

      # call owasp_cve API
      def retrieve_cves(input)
        result = Gateway::Api.new(SMS::App.config)
          .owasp_cve(input)
        if result.code == 202
          Failure(result.parse['message'])
        else
          result.success? ? Success(result.payload) : Failure(result.message)
        end
      rescue StandardError => e
        Failure(e.to_s)
      end

      def return_cves(input)
        Representer::OwaspsList.new(OpenStruct.new).from_json(input)
          .yield_self { |cves| Success(cves) }
      end
    end
  end
end
