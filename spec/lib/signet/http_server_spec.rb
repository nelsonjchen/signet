require 'spec_helper'
require 'support/http_helpers'
require 'support/openssl_helpers'
require 'signet/http_server'

describe Signet::HTTPServer do

  include HTTPHelpers

  describe 'authentication' do

    it 'forbids access without authentication' do
      csr_post 'auth' => nil
      last_response.status.should == status_code(:bad_request)
    end

    it 'forbids access with invalid authentication' do
      csr_post 'auth' => 'invalid auth'
      last_response.status.should == status_code(:forbidden)
    end

    it 'allows access with valid authentication' do
      csr_post
      last_response.status.should_not == status_code(:forbidden)
    end
  end

  it 'accepts POSTs to /csr' do
    csr_post
    last_response.status.should_not == status_code(:not_found)
  end

  it 'does not accept GETs to /csr' do
    get "/csr?auth=#{valid_user.identity_key}"
    last_response.status.should == status_code(:not_found)
  end

  it 'requires the csr parameter' do
    csr_post 'csr' => nil
    last_response.status.should == status_code(:bad_request)
  end

  it 'generates a certificate for a valid certificate signing request' do
    pending
    csr_post
    expect {
      OpenSSL::X509::Certificate.new(last_response.body)
    }.to_not raise_error OpenSSL::X509::CertificateError
  end
end
