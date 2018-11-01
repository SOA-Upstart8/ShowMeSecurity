# frozen_string_literal: true

require 'roda'
require 'slim'

module NewsSentence
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt

    # load css
    route do |routing|
        routing.assets

        # GET /
        routing.root do
            latest_cve = CVE::CVEMapper.new('80f3b0b6099e4df08bb8c8cee57e4c53').latest

            view 'home', locals: { latest: latest_cve }
        end

        routing.on 'cve' do
            routing.is do
                # POST /cve/
                routing.post do
                    query = routing.params['query']

                    routing.redirect "cve/#{query}"
                end
            end

            routing.on String do |query|
                # GET /cve/query
                routing.get do
                    cve_result = CVE::CVEMapper.new('80f3b0b6099e4df08bb8c8cee57e4c53').search(query)
                    
                    view 'cve', locals: { cve: cve_result, search: query }
                end
            end
        end
    end

  end
end