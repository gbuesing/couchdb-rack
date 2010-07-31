$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'couchdb-rack/server'

CouchdbRack::Server.start ARGV.first