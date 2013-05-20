require 'sinatra/base'
require 'certificate_signer/authenticator'
require 'certificate_signer/certificate_signer'

module CertificateSigner
  class HTTPServer < Sinatra::Base

    before do
      halt_with :bad_request if params[:auth].nil?
      halt_with :forbidden unless Authenticator.valid_identity_key? params[:auth]
    end

    post '/csr' do
      begin
        CertificateSigner.certificate_for params[:csr]
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
