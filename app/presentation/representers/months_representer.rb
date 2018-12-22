# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'month_representer'

module SMS
  module Representer
    # Represents list of months for API output
    class MonthsList < Roar::Decorator
      include Roar::JSON

      collection :months, extend: Representer::Month, class: OpenStruct
    end
  end
end
