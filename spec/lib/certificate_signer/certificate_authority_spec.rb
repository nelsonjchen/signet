require 'spec_helper'
require 'certificate_signer/certificate_authority'
require 'certificate_signer/configuration'
require 'support/openssl_helpers'

describe CertificateSigner::CertificateAuthority do

  include OpenSSLHelpers

  it 'should have access to common configuration' do
    CertificateSigner::CertificateAuthority.ancestors.should include CertificateSigner::Configuration
  end

  it 'should be able to verify its certificate with its public key' do
    CertificateSigner::CertificateAuthority.certificate.verify(
      CertificateSigner::CertificateAuthority.public_key
    ).should be true
  end

  %w[ certificate private_key public_key ].each do |method|

    describe "::#{method}" do # e.g. ::public_key

      it 'only loads data once for all instances of all classes' do
        File.should_receive(:read).once.and_return(instance_variable_get("@#{method}")) # e.g. ...and_return(@public_key)
        3.times do
          Class.new do
            3.times { CertificateSigner::CertificateAuthority.send(method) } # e.g. CertificateSigner::CertificateAuthority.public_key
          end
        end
        File.rspec_reset
      end

      it "returns the #{method} for the certificate authority" do
        result    = CertificateSigner::CertificateAuthority.send(method) # e.g. CertificateSigner::CertificateAuthority.public_key
        reference = send("ca_#{method}")                                 # e.g. ca_public_key (defined in OpenSSLHelpers)
        result.should be_a reference.class
        result.to_s.should == reference.to_s
      end
    end
  end

  describe '::sign' do

    it 'accepts a valid certificate signing request' do
      expect { CertificateSigner::CertificateAuthority.sign valid_csr }.to_not raise_error
    end

    it 'raises an ArgumentError if no csr_string is set' do
      expect { CertificateSigner::CertificateAuthority.sign }.to raise_error ArgumentError
    end

    it 'raises a RequestError if the csr_string is not a CSR' do
      expect {
        CertificateSigner::CertificateAuthority.sign 'not a csr'
      }.to raise_error ArgumentError
    end

    it 'signs a valid certificate request' do
      cert = CertificateSigner::CertificateAuthority.sign valid_csr
      pending
      expect { OpenSSL::X509::Certificate.new(cert) }.to_not raise_error OpenSSL::X509::CertificateError
    end
  end
end
