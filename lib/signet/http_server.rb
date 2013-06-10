require 'signet/authenticator'
require 'signet/certificate_authority'
require 'sinatra/base'

module Signet

  class AuthenticationError < Exception; end

  class HTTPServer < Sinatra::Base

    ERRORS = {
      no_auth:  ArgumentError.new('No auth parameter was supplied'),
      bad_auth: AuthenticationError.new('Authentication failed; check your auth parameter.'),
      no_csr:   ArgumentError.new('No csr parameter was supplied'),
      bad_csr:  ArgumentError.new("Couldn't parse that csr parameter; are you sure it's a CSR in PEM format?"),
    }

    enable :logging

    before do
      halt_with :bad_request, ERRORS[:no_auth]  if params[:auth].nil?
      halt_with :forbidden,   ERRORS[:bad_auth] unless Authenticator.valid_identity_key? params[:auth]
    end

    post '/csr' do
      halt_with :bad_request, ERRORS[:no_csr] if params[:csr].nil?
      CertificateAuthority.sign(csr).to_pem
    end

    private

    def halt_with(status, exception)
      logger.error exception
      halt Rack::Utils.status_code(status), "#{exception.to_s}\n"
    end

    def csr
      OpenSSL::X509::Request.new(params[:csr])
    rescue OpenSSL::X509::RequestError
      halt_with :bad_request, ERRORS[:bad_csr]
    end
  end
end
