# frozen_string_literal: true

require 'dry/monads/result'

module SMS
  module Service
    # Return all database cves
    class CVEList
      include Dry::Transaction
      include Dry::Monads::Result::Mixin

      step :retrieve_cves
      step :return_cves

      def retrieve_cves
        Gateway::Api.new(SMS::App.config)
          .latest_cve
          .yield_self do |result|
            result.success? ? Success(result.payload) : Failure(result.message)
          end
      rescue StandardError
        Failure('Cannot receive all cves from database.')
      end

      def return_cves(result)
        Representer::CVEsList.new(OpenStruct.new).from_json(result).yield_self { |cves| Success(cves) }
      end

    end
  end
end

