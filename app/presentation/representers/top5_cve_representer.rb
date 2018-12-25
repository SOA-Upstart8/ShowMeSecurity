# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'references_representer.rb'

module SMS
  module Representer
    # Represents list of cves for API output
    class Top5CVE < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :CVE_ID
      property :type
      property :release_date
      property :tweet_count
      property :retweet_count
      collection :references, extend: Representer::Reference, class: OpenStruct
    end
  end
end
