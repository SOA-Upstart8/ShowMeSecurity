# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'top5_cve_representer'

module SMS
  module Representer
    # Represents list of cves for API output
    class TOP5CVEsList < Roar::Decorator
      include Roar::JSON

      collection :cves, extend: Representer::Top5CVE, class: OpenStruct
    end
  end
end
