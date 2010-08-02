$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'couchdb-rack/server'

ENV['RACK_ENV'] = ENV['RACK_ENV'] || $RACK_ENV || 'development'

CouchdbRack::Server.start ARGV.first