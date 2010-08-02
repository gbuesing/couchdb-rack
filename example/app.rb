require 'sinatra/base'
require 'yaml'

class App < Sinatra::Base
  set :app_file, __FILE__
  set :static, true
  
  get '/' do
    @env = YAML.dump request.env
    erb :index
  end
  
  get '/user' do
    content_type :json
    request.env['couchdb.request']['userCtx'].to_json
  end
  
  # Only one Rack process per external, so calls to this action will block the process for 10 seconds!
  # This limitation is inherent in CouchDB's external line protocol; there's nothing we can do here in Ruby to work around this.
  #
  # To run a quick test:
  #
  #   ab -c 2 -n 2 http://127.0.0.1:5984/mydb/_myapp/sleep
  #
  # ...should take 20 seconds to fulfill both requests.
  get '/sleep' do
    sleep 10
    'ZZZZZ'
  end
  
end