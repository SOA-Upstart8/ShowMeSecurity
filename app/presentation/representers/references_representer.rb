# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module SMS
  module Representer
    # Represent a CVE entity as Json
    class Reference < Roar::Decorator
      include Roar::JSON

      property :link
    end
  end
end
