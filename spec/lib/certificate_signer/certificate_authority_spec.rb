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
      CertificateSigner::CertificateAuthority.private_key.should == ca_private_key
    end
  end
end
