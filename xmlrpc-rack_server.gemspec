# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'xmlrpc/rack_server'

Gem::Specification.new do |s|
  s.name        = "xmlrpc-rack_server"
  s.version     = XMLRPC::RackServer::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nikolaos Anastopoulos"]
  s.email       = ["ebababi@ebababi.net"]
  s.homepage    = "https://github.com/ebababi/xmlrpc-rack_server"
  s.summary     = %q{Rack compatible XML-RPC server}
  s.description = %q{Extends the Ruby standard library XMLRPC::BasicServer, providing the Rack compatible XMLRPC::RackServer.}
  s.license     = 'MIT'
  s.has_rdoc    = true
  s.extra_rdoc_files = ['README']

  #s.rubyforge_project = "xmlrpc-rack_server"

  s.add_dependency 'rack'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
