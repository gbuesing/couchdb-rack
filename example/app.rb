require 'sinatra/base'
require 'yaml'

class App < Sinatra::Base
  set :app_file, __FILE__
  
  get '/' do
    @env = YAML.dump request.env
    erb :index
  end
  
  get '/user' do
    content_type :json
    request.env['couchdb.request']['userCtx'].to_json
  end
  
  get '/boom' do
    raise 'boom!'
  end
  
end