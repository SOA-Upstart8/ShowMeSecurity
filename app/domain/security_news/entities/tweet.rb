# frozen_string_literal: true

require 'dry-struct'
require_relative 'expert.rb'
module SMS
  module Entity
    # Model for tweet
    class Tweet < Dry::Struct
      include Dry::Types.module

      attribute :id, Integer.optional
      attribute :content, Strict::String
      attribute :reply_count, Strict::Integer
      attribute :favorite_count, Strict::Integer
      attribute :retweet_count, Strict::Integer
      attribute :owner_id, Coercible::String
      attribute :owner_image, Strict::String
      attribute :owner_name, Strict::String
      attribute :owner_page, Strict::String
      attribute :time, Params::DateTime

      def to_attr_hash
        to_hash.reject { |key, _| %i[id].include? key }
      end
    end
  end
end
