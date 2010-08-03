CouchDB-Rack
============

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
    end


When mounted as the external _myapp, a request to:

    http://localhost:5984/mydb/_myapp

    
would route to '/' and render 'Home page'. A request to:

    http://localhost:5984/mydb/_myapp/foo

   
would route to '/foo' and render 'Foo page', etc.

(The initial part of the path, /mydb/_myapp , is stored as SCRIPT_NAME the Rack env hash.)

The JSON request object passed from CouchDB to the external process is available in the Rack env hash under the 'couchdb.request' key. For more information on the CouchDB external request object, see the [CouchDB Wiki](http://wiki.apache.org/couchdb/ExternalProcesses#JSON_Requests)

Example CouchDB local.ini setup:

    [external]
    myapp = /path/to/ruby -rubygems -s /path/to/couchdb-rack/tools/couchdb-external-hook.rb -RACK_ENV=development /path/to/myapp/config.ru

    [httpd_db_handlers]
    _myapp = {couch_httpd_external, handle_external_req, <<"myapp">>}
    
    
You can point to the config.ru under /example to quickly see this in action.


Reloading the app
-----------------

Check the example app for a url-accessible way to reload the app without restarting the CouchDB server.


Caveats
-------

The main limitation with using CouchDB's external line protocol is that each request blocks the process. So, in the example app, the /sleep action blocks for 10 seconds, and additional requests will queue up. If three requests come in to this action at the same time, the first request is served in 10 seconds, the second in 20, and the third in 30.

Nothing we can do about this here on the Ruby side. The solution would be for CouchDB to implement a nonblocking external protocol (there's been some discussion about this on the CouchDB dev mailing list.)

I wouldn't use an external for high-traffic applications, or IO-intensive applications. But should be fine enough to mount simple services.

Another CouchDB external limitation: no streaming of response bodies. Could be an issue if you need to return extremely large responses.

