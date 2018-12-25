# frozen_string_literal: true

require 'dry/transaction'

module SMS
  module Service
    # Return analysis cve data
    class CVEAnalysis2
      include Dry::Transaction

      step :retreive_cves
      step :return_cves

      private

      SMS_NOT_FOUND_MSG = 'Could not find datas on /top_5 API'

      # call top_5 API
      def retreive_cves
        result = Gateway::Api.new(SMS::App.config)
          .top_5
        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError
        Failure('Cannot analyze the cve.')
      end

      def return_cves(result)
        Representer::TOP5CVEsList.new(OpenStruct.new).from_json(result).yield_self { |datas| Success(datas) }
      end
    end
  end
end
