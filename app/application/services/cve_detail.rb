# frozen_string_literal: true

require 'dry/transaction'

module SMS
  module Service
    # Return analysis cve data
    class CVEDetail
      include Dry::Transaction

      step :retreive_cves
      step :return_cves

      private

      SMS_NOT_FOUND_MSG = 'Could not find cves on Secbuzzer'

      # call find_by_id/{cve_id} API
      def retreive_cves(cve_id)
        result = Gateway::Api.new(SMS::App.config)
          .find_cve_detail(cve_id)
        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError
        Failure('Cannot show the cve.')
      end

      def return_cves(result)
        Representer::Detail.new(OpenStruct.new).from_json(result).yield_self { |datas| Success(datas) }
      end
    end
  end
end
