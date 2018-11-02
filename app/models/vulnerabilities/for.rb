# frozen_string_literal: true

module SMS
  module Vulnerability
    class For
      ENTITY_NEWS = {
        Entity::CVE => CVEs,
        Entity::Reference => References,
        Entity::Tweet => Tweets
      }.freeze

      def self.klass(entity_klass)
        ENTITY_NEWS[entity_klass]
      end

      def self.entity(entity_object)
        ENTITY_NEWS[entity_object.class]
      end
    end
  end
end
