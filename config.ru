$: << 'lib'

require 'signet/http_server'

ENV['RACK_ENV'] ||= 'development'

run Signet::HTTPServer.new
