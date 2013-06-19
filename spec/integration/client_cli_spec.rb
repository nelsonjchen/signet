require 'spec_helper'
require 'signet/configuration'
require 'signet/http_server'
require 'support/openssl_helpers'
require 'timeout'

include Signet::Configuration

describe 'Client CLI integration' do

  include OpenSSLHelpers

  let :uri do
    URI(config['client']['server'])
  end

  def server_up?
    begin
      Net::HTTP.start(uri.host, uri.port) do |http|
        http.get '/'
      end
    rescue Errno::ECONNREFUSED
      return false
    end
    true
  end

  before :all do
    FileUtils.rm_f CERTIFICATE_PATH
    begin
      $stderr = StringIO.new # suppress logging from HTTPServer
      thread = Thread.new do
        Signet::HTTPServer.run!
      end
      Timeout.timeout(60) do
        thread.join(0.1) until server_up?
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
