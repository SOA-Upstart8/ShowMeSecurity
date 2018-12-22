# frozen_string_literal: true

require 'dry/transaction'

module SMS
  module Service
    # Return analysis cve data
    class CVEAnalysis
      include Dry::Transaction

      step :retreive_cves
      step :return_cves

      private

      SMS_NOT_FOUND_MSG = 'Could not find datas on /analysis/month API'

      # call analysis_month API
      def retreive_cves
        Gateway::Api.new(SMS::App.config)
          .analysis_month
          .yield_self do |result|
            result.success? ? Success(result.payload) : Failure(result.message)
          end
      rescue StandardError
        Failure('Cannot analyze the cve.')
      end

      def return_cves(result)
        Representer::MonthsList.new(OpenStruct.new).from_json(result).yield_self { |datas| Success(datas) }
      end
    end
  end
end
