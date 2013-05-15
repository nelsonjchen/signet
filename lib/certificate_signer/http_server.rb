require 'sinatra/base'
require 'certificate_signer/authenticator'

module CertificateSigner
  class HTTPServer < Sinatra::Base

    before do
      forbid unless Authenticator.authenticates? params[:auth]
    end

    post '/csr' do
    end

    private

    def forbid
      halt Rack::Utils.status_code(:forbidden)
    end
  end
end
