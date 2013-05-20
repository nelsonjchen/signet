$: << 'lib'

require 'certificate_signer/http_server'

ENV['RACK_ENV'] ||= 'development'

run CertificateSigner::HTTPServer.new
