require 'sinatra/base'

class Onefile < Sinatra::Base
  set :app_file, __FILE__
  
  get '/' do
    content_type :json
    request.env.to_json
  end
end
