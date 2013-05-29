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
end
