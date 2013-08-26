require 'guillotine'
require 'redis'

module UrlShortener
  class App < Guillotine::App
    set :root, 'lib/app'

    uri = URI.parse(ENV["REDISTOGO_URL"] || "http://localhost:6379")

    REDIS = Redis.new(:host => uri.host,
                      :port => uri.port,
                      :password => uri.password)

    adapter = Guillotine::Adapters::RedisAdapter.new REDIS
    set :service => Guillotine::Service.new(adapter, :strip_query => false,
                                            :strip_anchor => false)

    get '/' do
      erb :index
    end

    post "/" do
      params[:code] = nil if params[:code] == ""

      status, head, body = settings.service.create(params[:url], params[:code])

      if loc = head['Location']
        head['Location'] = File.join(request.url, loc)
      end

      @new_url = head["Location"]
      @error = simple_escape(body)

      erb :link
    end
  end
end
