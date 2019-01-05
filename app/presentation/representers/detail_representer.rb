# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'detail_representer'
require_relative 'tweets_representer'

module SMS
  module Representer
    # Represents list detail of cve for API output
    class Detail < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :CVE_ID
      property :overview
      property :release_date
      property :vultype
      property :affected_product
      property :affected_vendor
      property :zeroday_price
      collection :tweets, extend: Representer::Tweet, class: OpenStruct
    end
  end
end
