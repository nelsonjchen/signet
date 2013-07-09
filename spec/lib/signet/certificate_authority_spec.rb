require 'spec_helper'
require 'signet/certificate_authority'
require 'signet/configuration'
require 'support/openssl_helpers'

describe Signet::CertificateAuthority do

  include OpenSSLHelpers

  it 'should have access to common configuration' do
    Signet::CertificateAuthority.ancestors.should include Signet::Configuration
  end

  it 'should be able to verify its certificate with its public key' do
    Signet::CertificateAuthority.certificate.verify(
      Signet::CertificateAuthority.public_key
    ).should be true
  end

  %w[ certificate private_key public_key ].each do |method|

    describe "::#{method}" do # e.g. ::public_key

      it 'only loads data once for all instances of all classes' do
        File.should_receive(:read).once.and_return(instance_variable_get("@#{method}")) # e.g. ...and_return(@public_key)
        3.times do
          Class.new do
            3.times { Signet::CertificateAuthority.send(method) } # e.g. Signet::CertificateAuthority.public_key
          end
        end
        File.rspec_reset
      end

      it "returns the #{method} for the certificate authority" do
        result    = Signet::CertificateAuthority.send(method) # e.g. Signet::CertificateAuthority.public_key
        reference = send("ca_#{method}")                      # e.g. ca_public_key (defined in OpenSSLHelpers)
        result.should be_a reference.class
        result.to_s.should == reference.to_s
      end
    end
  end

  describe '::sign' do

    it 'accepts a valid certificate signing request' do
      expect { Signet::CertificateAuthority.sign valid_csr }.not_to raise_error
    end

    it 'raises an ArgumentError if no csr is set' do
      expect { Signet::CertificateAuthority.sign }.to raise_error ArgumentError
    end

    it 'raises a RequestError if the csr is not a CSR' do
      expect {
        Signet::CertificateAuthority.sign 'not a csr'
      }.to raise_error ArgumentError
    end

    it 'signs a valid certificate request' do
      cert = Signet::CertificateAuthority.sign valid_csr
      expect { OpenSSL::X509::Certificate.new(cert) }.not_to raise_error
    end

    it 'creates certificates with the version from the configuration file' do
      Signet::CertificateAuthority.sign(valid_csr).version.should == config['certificate_authority']['version']
    end
  end

  describe '::verify?' do

    it "verifies that certificates signed by this CA have been signed by this CA" do
      valid_cert = Signet::CertificateAuthority.sign valid_csr
      Signet::CertificateAuthority.verify?(valid_cert).should be true
    end

    it "verifies that other certificates were not signed by this CA" do
      Signet::CertificateAuthority.verify?(some_other_cert).should be false
    end
  end
end
