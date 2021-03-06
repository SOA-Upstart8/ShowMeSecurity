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

        result = Service::CVEList.new.call

        if result.failure?
          flash[:error] = result.failure
        else
          cves = result.value!.cves
        end

        viewable_cves = Views::CVEsList.new(cves)

        view 'home', locals: { latest: viewable_cves }
      end

      routing.on 'test' do
        view 'index'
      end

      routing.on 'cve' do
        routing.is do
          # POST /cve/
          routing.post do
            query = routing.params['query']
            result = SMS::Forms::Query.call(routing.params)
            routing.redirect "cve/#{query}" unless result.success?

            flash[:error] = 'Invalid Input'
            response.status = 400
            routing.redirect '/'
          end
        end

        routing.on String do |query|
          # GET /cve/query
          routing.get do
            result = Service::CVESearch.new.call(query)

            if result.failure?
              flash[:error] = 'We can\'t find any content :<'
              routing.redirect '/'
            else
              cves = result.value!.cves
            end

            viewable_cves = Views::CVEsList.new(cves)

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
            result = Service::CVEOwasp.new.call(query)
            if result.failure
              flash[:error] = result.failure
              routing.redirect('/')
            end

            check_class = result.value!.class.to_s
            if check_class == 'Hash'
              result = OpenStruct.new(result.value!)
              flash.now[:notic] = 'We are filtering datas, pleas wait' if result.status == 'processing'
              processing = Views::Processing.new(
                App.config, result
              )
              view 'cve_processing', locals: { processing: processing }
            else
              cves = result.value!.owasps
              viewable_cves = Views::CVEsList.new(cves)
              view 'cve_category', locals: { cve: viewable_cves, category: query }
            end
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

        routing.on String do |_cve_id|
          # GET /cve_favorite/cve_id
          routing.get do
            # Get cve from database instead of Secbuzzer
            result = Service::CVEList.new.call(session[:favorite])

            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            end

            view 'cve_favorite', locals: { cve: session[:favorite] }
          end
        end
      end

      routing.on 'cve_analysis' do
        routing.get do
          # Get cve analysis by month from  analysis/month API
          result = Service::CVEAnalysis.new.call

          if result.failure?
            flash[:error] = result.failure
            routing.redirect '/'
          end
          datas = result.value!.months

          date_arr = []
          num_arr = []
          datas.each do |data|
            date_arr << data.date
          end
          datas.each do |data|
            num_arr << data.number
          end

          result2 = Service::CVEAnalysis2.new.call
          topPrice = result2.value!.cves[0..4]
          topPopular = result2.value!.cves[5..9]
          topSeverity = result2.value!.cves[10..14]

          result3 = Service::CVEAnalysis3.new.call
          types = result3.value!.vultypes[1..10]
          type_arr = []
          type_num_arr = []
          types.each do |vul|
            type_arr << vul.type
          end
          types.each do |vul|
            type_num_arr << vul.number
          end

          view 'cve_analysis', locals: {type_arr: type_arr, type_num_arr: type_num_arr, date_arr: date_arr, num_arr: num_arr, topPrice: topPrice, topPopular: topPopular, topSeverity: topSeverity }
        end
      end

      routing.on 'cve_detail' do
        routing.is do
          # POST /cve_detail/
          routing.post do
            cve_id = routing.params['cve_id']

            routing.redirect "cve_detail/#{cve_id}"
          end
        end

        routing.on String do |cve_id|
          # GET /cve_detail/cve_id
          routing.get do
            result = Service::CVEDetail.new.call(cve_id)
            tweets = result.value!.tweets

            view 'cve_detail', locals: { cve_detail: result.value!, tweets: tweets }
          end
        end
      end
    end
  end
end