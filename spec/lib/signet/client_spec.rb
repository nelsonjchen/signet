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
          expect { OpenSSL::X509::Certificate.new File.read(CERTIFICATE_PATH) }.not_to raise_error
        end

        it 'is signed by the certificate authority' do
          OpenSSL::X509::Certificate.new(File.read CERTIFICATE_PATH).verify(ca_private_key).should be true
        end
      end
    end
  end

  describe 'private key behavior' do

    it 'if no private key exists it creates and uses a new key and saves it to disk' do
      FileUtils.rm_f CLIENT_PRIVATE_KEY_PATH
      Signet::Client.new.send(:private_key)
      reference = OpenSSL::PKey.read File.read(CLIENT_PRIVATE_KEY_PATH)
      Signet::Client.new.send(:private_key).to_pem.should == reference.to_pem
    end
  end
end
