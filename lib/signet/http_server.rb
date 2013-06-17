require 'signet/authenticator'
require 'signet/certificate_authority'
require 'signet/http_server_errors'
require 'sinatra/base'
require 'logger'

module Signet

  class HTTPServer < Sinatra::Base

    include HTTPServerErrors

    configure do
      enable :logging
    end

    before do
      halt_with :no_auth  if params[:auth].nil?
      halt_with :bad_auth unless Authenticator.valid_identity_key? params[:auth]
    end

    post '/csr' do
      halt_with :no_csr if params[:csr].nil?
      CertificateAuthority.sign(csr).to_pem
    end

    private

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
