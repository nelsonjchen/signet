require 'spec_helper'
require 'certificate_signer/http_server'

module CertificateSigner

  describe HTTPServer do

    describe 'authentication' do

      it 'forbids access without authentication' do
        post '/csr'
        last_response.status.should == status_code(:forbidden)
      end

      it 'forbids access with invalid authentication' do
        post '/csr', params: { 'auth' => 'invalid auth' }
        last_response.status.should == status_code(:forbidden)
      end

      it 'allows access with valid authentication' do
        authenticated_csr
        last_response.status.should_not == status_code(:forbidden)
      end
    end

    it 'accepts POSTs to /csr' do
      post '/csr'
      last_response.status.should_not == status_code(:not_found)
    end

    it 'does not accept GETs to /csr' do
      get "/csr?auth=#{valid_user.identity_key}"
      last_response.status.should == status_code(:not_found)
    end

    it 'generates a certificate for a valid certificate signing request' do
      pending 'write client'
    end
  end
end
