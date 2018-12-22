# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'owasp_representer'

module SMS
  module Representer
    # Represents list of cves for API output
    class OwaspsList < Roar::Decorator
      include Roar::JSON

      collection :owasps, extend: Representer::Owasp, class: OpenStruct
    end
  end
end
