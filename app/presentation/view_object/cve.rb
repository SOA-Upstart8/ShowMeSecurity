# frozen_string_literal: true

module Views
  class CVE
    def initialize(cve, index = nil)
      @cve = cve
      @index = index
    end

    def entity
      @cve
    end

    def praise_search
      "cve/#{query}"
    end

    def index_str
      "cve[#{@index}]"
    end

    def cve_id
      @cve.CVE_ID
    end

    def overview
      @cve.overview
    end

    def link
      @cve.references[0].link
    end

    def date
      @cve.release_date
    end
  end
end
