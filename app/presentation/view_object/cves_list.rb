# frozen_string_literal: true

require_relative 'cve'

module Views
  # View for a a list of project entities
  class CVEsList
    def initialize(cves)
      @cves = cves.map.with_index { |cve, i| CVE.new(cve, i) }
    end

    def each
      @cves.each do |cve|
        yield cve
      end
    end

    def any?
      @cves.any?
    end
  end
end