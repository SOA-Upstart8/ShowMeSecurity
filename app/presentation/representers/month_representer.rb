# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'


module SMS
  module Representer
    # Represents list of cves for API output
    class Month < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :date
      property :number
    end
  end
end
