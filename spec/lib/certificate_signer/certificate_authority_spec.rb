require 'spec_helper'
require 'certificate_signer/certificate_authority'
require 'certificate_signer/configuration'
require 'support/openssl_helpers'

describe CertificateSigner::CertificateAuthority do

  include OpenSSLHelpers

  it 'should have access to common configuration' do
    CertificateSigner::CertificateAuthority.ancestors.should include CertificateSigner::Configuration
  end

  describe '::private_key' do
    it 'returns the private key for the certificate authority' do
      private_key = CertificateSigner::CertificateAuthority.private_key
      private_key.class.should be OpenSSL::PKey::RSA
      private_key.to_s.should == ca_private_key.to_s
    end
  end
end
