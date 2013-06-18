require 'spec_helper'
require 'signet/configuration'
require 'signet/http_server'
require 'support/openssl_helpers'

include Signet::Configuration

describe 'Client CLI integration' do

  include OpenSSLHelpers

  before :all do
    FileUtils.rm_f CERTIFICATE_PATH
    begin
      $stderr = StringIO.new # suppress logging from HTTPServer
      thread = Thread.new do
        Signet::HTTPServer.run!
      end
      `bin/signet-client`
    ensure
      thread.exit
      $stderr = STDERR
    end
  end

  it 'gets a certificate file' do
    File.exist?(CERTIFICATE_PATH).should be true
  end

  describe 'the certificate file' do

    it 'is a file' do
      File.file?(CERTIFICATE_PATH).should be true
    end

    it 'is a certificate' do
      expect {
        OpenSSL::X509::Certificate.new File.read(CERTIFICATE_PATH)
      }.not_to raise_error OpenSSL::X509::CertificateError
    end

    it 'is signed by the certificate authority' do
      OpenSSL::X509::Certificate.new(File.read CERTIFICATE_PATH).verify(ca_private_key).should be true
    end
  end
end
