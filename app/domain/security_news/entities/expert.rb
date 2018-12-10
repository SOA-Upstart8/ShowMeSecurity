# frozen_string_literal: true

require 'dry-struct'

module SMS
  module Entity
    # Model for expert
    class Expert < Dry::Struct
      include Dry::Types.module
      attribute :id, Integer.optional
      attribute :user_id, Strict::Integer
      attribute :image, Strict::String
      attribute :follower_count, Strict::Integer
      attribute :name, Strict::String
      attribute :user_page, Strict::String

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
