require 'signet/authenticator'
require 'signet/certificate_authority'
require 'signet/http_server_errors'
require 'sinatra/base'

module Signet

  class HTTPServer < Sinatra::Base

    include HTTPServerErrors

    before { authenticate }

    post '/csr' do
      halt_with :no_csr if params[:csr].nil?
      CertificateAuthority.sign(csr).to_pem
    end

    private

    def authenticate
      halt_with :no_auth  if params[:auth].nil?
      halt_with :bad_auth unless Authenticator.valid_identity_key? params[:auth]
    end

    def halt_with(error)
      status, message = ERRORS[error][:status], ERRORS[error][:message]
      logger.error message
      halt Rack::Utils.status_code(status), "#{message}\n"
    end

    def csr
      OpenSSL::X509::Request.new(params[:csr])
    rescue OpenSSL::X509::RequestError
      halt_with :bad_csr
    end
  end
end
