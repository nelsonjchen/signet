require 'spec_helper'
require 'certificate_signer/certificate_authority'

describe CertificateSigner::CertificateAuthority do

  describe '::private_key' do
    it 'returns the OpenSSL private key of this certificate authority'
  end
end
