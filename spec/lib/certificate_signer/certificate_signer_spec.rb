require 'spec_helper'
require 'support/openssl_helpers'
require 'certificate_signer/certificate_signer'

describe CertificateSigner::CertificateSigner do

  include OpenSSLHelpers

  describe '::certificate_for(csr_string)' do

    it 'accepts a valid certificate signing request represented as a string' do
      expect { CertificateSigner::CertificateSigner.certificate_for  valid_csr }.to_not raise_error
    end

    it 'raises an ArgumentError if no csr_string is set' do
      expect { CertificateSigner::CertificateSigner.certificate_for }.to raise_error ArgumentError
    end

    it 'raises a RequestError if the csr_string is not a valid string representation of a CSR' do
      expect {
        CertificateSigner::CertificateSigner.certificate_for 'not a csr'
      }.to raise_error OpenSSL::X509::RequestError
    end


    it 'signs a valid certificate request' do
      pending 'implement CertificateSigner'
      cert = CertificateSigner::CertificateSigner.certificate_for(valid_csr)
      expect { OpenSSL::X509::Certificate.new(cert) }.to_not raise_error OpenSSL::X509::CertificateError
    end
  end
end
