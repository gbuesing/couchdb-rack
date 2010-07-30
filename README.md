CouchDB-Rack
============

Note: This is still a proof-of-concept.

A Rack handler for CouchDB external processes.

This allows you to mount a Rack app as a CouchDB external, and use CouchDB as the web server.

For example, given a basic Sinatra app:

    require 'sinatra/base'
    
    class App < Sinatra::Base
      get '/' do
        'Home page'
      end
      
      get '/foo' do
        'Foo page'
      end
      
      get '/usrctx' do
        request.env['couchdb.request']['usrCtx'].inspect
      end
    end


a request to:

    http://localhost:5984/mydb/_rack

    
would route to '/' and render 'Home page'. A request to:

   http://localhost:5984/mydb/_rack/foo

   
would route to '/foo' and render 'Foo page', etc.

(The initial part of the path, /mydb/_rack , is stored as SCRIPT_NAME the Rack env hash.)

The JSON request object passed by CouchDB to the external process is available in the Rack env hash under the 'couchdb.request' key. For more information on the CouchDB external request object, see the [CouchDB Wiki](http://wiki.apache.org/couchdb/ExternalProcesses#JSON_Requests)

Example CouchDB local.ini setup:

    [external]
    rack = /path/to/ruby -rubygems -I/path/to/couchdb-rack/lib:/path/to/myapp /path/to/couchdb-rack/lib/couchdb-rack/server.rb  /path/to/myapp/config.ru

    [httpd_db_handlers]
    _rack = {couch_httpd_external, handle_external_req, <<"rack">>}
    
