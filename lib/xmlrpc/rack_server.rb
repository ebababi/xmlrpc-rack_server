require "xmlrpc/server"
require "rack/request"
require "rack/response"

module XMLRPC
  # Implements a Rack based XML-RPC server.
  #
  # Extends the XMLRPC::BasicServer by implementing the Rack callback
  # requirement, creating a Rack compatible XML-RPC server. It is used as a
  # normal XML-RPC server:
  # 
  #   server = XMLRPC::RackServer.new
  #   server.add_introspection
  #   server.add_handler("weblogUpdates", Ping)
  # 
  # The XMLRPC::RackServer instance may be mounted to a Rack chain.
  class RackServer < BasicServer
    VERSION = "0.0.1".freeze

    # Creates a new XMLRPC::RackServer instance.
    #
    # All parameters given are by-passed to XMLRPC::BasicServer initializer.
    def initialize(*args)
      super(*args)
    end

    # Implements the Rack callback requirement.
    #
    # Responds to any bad requests with HTTP errors, parses the input and
    # process it, responding with the output.
    def call(env)
      request = Rack::Request.new(env)

      return [405, {}, ["Method Not Allowed"]] unless request.post?

      return [400, {}, ["Bad Request"]] unless not request.content_type.nil? and
          ["application/xml", "text/xml"].include? parse_content_type(request.content_type).first

      length = request.content_length.to_i
      return [411, {}, ["Length Required"]] unless length > 0

      data = request.body
      return [400, {}, ["Bad Request"]] if data.nil? or data.size != length

      input = data.read(length)
      output = nil
      begin
        output = process(input)
      rescue RuntimeError => e
        return [400, {}, ["Bad Request"]] if e.message =~ /No valid method call/
      end
      return [500, {}, ["Internal Server Error"]] if output.nil? or output.size <= 0

      response = Rack::Response.new
      response.write output
      response["Content-Type"] = "text/xml; charset=utf-8"
      response.finish
    end
  end
end
