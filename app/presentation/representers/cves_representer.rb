# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'cve_representer'

module SMS
  module Representer
    # Represents list of cves for API output
    class CVEsList < Roar::Decorator
      include Roar::JSON

      collection :cves, extend: Representer::CVE, class: OpenStruct
    end
  end
end
