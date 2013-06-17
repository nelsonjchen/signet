require 'spec_helper'
require 'net/http'
require 'signet/client'
require 'signet/configuration'
require 'support/openssl_helpers'

describe Signet::Client do

  include OpenSSLHelpers
  include Signet::Configuration

  describe '::run' do

    context 'success' do

      before :each do
        FileUtils.rm_f CERTIFICATE_PATH
        Net::HTTP.stub(:post_form) { OpenStruct.new({body: valid_certificate.to_pem }) }
        Signet::Client.run
      end

      it 'creates the certificate file for the given environment' do
        File.exist?(CERTIFICATE_PATH).should be true
      end

      describe 'the certificate file' do

        it 'is a file' do
          File.file?(CERTIFICATE_PATH).should be true
        end

        it 'is a certificate' do
          expect {
            OpenSSL::X509::Certificate.new File.read(CERTIFICATE_PATH)
          }.to_not raise_error OpenSSL::X509::CertificateError
        end

        it 'is signed by the certificate authority' do
          OpenSSL::X509::Certificate.new(File.read CERTIFICATE_PATH).verify(ca_private_key).should be true
        end
      end
    end
  end
end
