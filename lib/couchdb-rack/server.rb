require 'rack/builder'
require 'rack/server'
require 'rack/handler/couchdb'

module CouchdbRack
  class Server
    
    def self.start(config)
      new(config).start
    end
    
    def initialize(config)
      @config = config
    end
    
    def app
      @app ||= begin
        if !::File.exist? @config
          abort "configuration #{@config} not found"
        end

        app, options = Rack::Builder.parse_file(@config)
        app
      end
    end
    
    def start
      Rack::Handler::Couchdb.run app
    end
    
  end
end

CouchdbRack::Server.start ARGV.first