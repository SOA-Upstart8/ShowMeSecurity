# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module SMS
  module Representer
    # Represent a CVE entity as Json
    class Tweet < Roar::Decorator
      include Roar::JSON

      property :content
      property :favorite_count
      property :retweet_count
      property :owner_name
      property :owner_image
      property :time
    end
  end
end
