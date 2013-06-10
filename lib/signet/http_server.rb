require 'sinatra/base'
require 'signet/authenticator'
require 'signet/certificate_authority'

module Signet
  class HTTPServer < Sinatra::Base

    before do
      halt_with :bad_request if params[:auth].nil?
      halt_with :forbidden unless Authenticator.valid_identity_key? params[:auth]
    end

    post '/csr' do
      begin
        CertificateAuthority.sign(params[:csr]).to_pem
      rescue ArgumentError
        halt_with :bad_request
      end
    end

    private

    def halt_with(status)
      halt Rack::Utils.status_code(status)
    end
  end
end
