require 'spec_helper'
require 'openssl'
require 'signet/certificate_authority'
require 'signet/client'

INSTALL_PRODUCTION_FILES = <<-PENDING

    Install production CA certificate,  private key, and config to
      - #{PRODUCTION_CA_CERT_PATH}
      - #{PRODUCTION_PRIVATE_KEY_PATH}
      - #{PRODUCTION_CONFIG_PATH}
    to run these tests
PENDING

describe 'Production certificate authority integration' do

  before :all do
    unset_configuration
    unset_certificate_authority
    @original_env = ENV['RACK_ENV']
    ENV['RACK_ENV'] = 'production'
  end

  after :all do
    ENV['RACK_ENV'] = @original_env
    unset_configuration
    unset_certificate_authority
  end

  pending INSTALL_PRODUCTION_FILES unless production_files_exist?

  describe 'production CA private key'  do

    it 'decrypts with the production passphrase' do
      expect { Signet::CertificateAuthority.private_key }.not_to raise_error
    end
  end

  describe 'production CA certificate' do

    it 'is signed by the production private key' do
      Signet::CertificateAuthority.verify?(Signet::CertificateAuthority.certificate).should be true
    end

    it 'can sign new certificates for us' do
      csr  = Signet::Client.new.send(:certificate_signing_request)
      cert = Signet::CertificateAuthority.sign(csr)
      Signet::CertificateAuthority.verify?(cert).should be true
      cert.issuer.should == Signet::CertificateAuthority.certificate.subject
    end
  end
end
