# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

module SMS
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/presentation/views'
    plugin :assets, css: 'style.css', path: 'app/presentation/assets'
    plugin :halt
    plugin :flash

    # load css
    route do |routing|
      routing.assets

      # GET /
      routing.root do
        session[:favorite] ||= []

        latest_cve = CVE::CVEMapper.new(App.config.SEC_API_KEY).latest
        latest_cve.each do |cve|
          Repository::For.entity(cve).create(cve)
        end

        viewable_cves = Views::CVEsList.new(latest_cve)

        view 'home', locals: { latest: viewable_cves }
      end

      routing.on 'cve' do
        routing.is do
          # POST /cve/
          routing.post do
            query = routing.params['query']
            unless (query.include? '/') ||
                   (query.include? '"') ||
                   (query.include? '\'') ||
                   (query.include? ';') ||
                   (query.include? '<') ||
                   (query.include? '>') ||
                   (query.include? '=')
              routing.redirect "cve/#{query}"
            end

            flash[:error] = 'Invalid Input'
            response.status = 400
            routing.redirect '/'
          end
        end

        routing.on String do |query|
          # GET /cve/query
          routing.get do
            cve_result = CVE::CVEMapper.new(App.config.SEC_API_KEY).search(query)
            cve_result.each do |cve|
              Repository::For.entity(cve).create(cve)
            end

            viewable_cves = Views::CVEsList.new(cve_result)

            view 'cve', locals: { cve: viewable_cves, search: query }
          end
        end
      end

      routing.on 'cve_category' do
        routing.is do
          # POST /cve_category/
          routing.post do
            query = routing.params['category']

            routing.redirect "cve_category/#{query}"
          end
        end

        routing.on String do |query|
          # GET /cve_category/query
          routing.get do
            cve_result = Mapper::CVEMapper.new(query).filter
            cve_result.each do |cve|
              Repository::For.entity(cve).create(cve)
            end

            viewable_cves = Views::CVEsList.new(cve_result)

            view 'cve_category', locals: { cve: viewable_cves, category: query }
          end
        end
      end

      routing.on 'cve_favorite' do
        routing.is do
          # POST /cve_favorite/
          routing.post do
            cve_id = routing.params['favorite']
            session[:favorite].insert(0, cve_id).uniq!

            routing.redirect "cve_favorite/#{cve_id}"
          end
        end

        routing.on String do |cve_id|
          # GET /cve_favorite/cve_id
          routing.get do
            # Get cve from database instead of Secbuzzer
            begin
              cve = Repository::For.klass(Entity::CVE)
                .find_cve_id(cve_id)
              # Add new cve to watched set in cookies
              session[:favorite].insert(0, cve.CVE_ID).uniq!
              # session[:favorite].delete_at(0)

              if cve.nil?
                flash[:error] = 'CVE not found'
                routing.redirect '/'
              end
            rescue StandardError
              flash[:error] = 'Having trouble accessing the database'
              routing.redirect '/'
            end

            view 'cve_favorite', locals: { cve: session[:favorite] }
          end
        end
      end

    end
  end
end
