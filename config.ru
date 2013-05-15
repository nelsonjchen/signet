$: << 'lib'

require 'certificate_signer/http_server'

run CertificateSigner::HTTPServer.new
