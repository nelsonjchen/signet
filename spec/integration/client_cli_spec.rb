require 'spec_helper'
require 'signet/configuration'
require 'signet/http_server'
require 'support/openssl_helpers'
require 'timeout'

describe 'Client CLI integration' do

  include OpenSSLHelpers
  extend Signet::Configuration

  def uri
    unless @uri
      protocol = config.client.disable_https ? 'http' : 'https'
      @uri = URI.parse "#{protocol}://#{config.client.host}:#{config.client.port}/csr"
    end
    @uri
  end

  def server_up?
    Net::HTTP.start uri.host, uri.port do |http|
      request = Net::HTTP::Post.new(uri.to_s)
      request.set_form_data 'auth' => 'BAD_AUTH'
      response = http.request request
      response.code == '403'
    end
  rescue Errno::ECONNREFUSED
    false
  end

  before :all do
    FileUtils.rm_f CERTIFICATE_PATH
    begin
      original_stdout = $stdout
      pid = fork do
        $stdout = StringIO.new # silence the puma!
        Rack::Server.start \
          app:       Signet::HTTPServer,
          Port:      uri.port,
          AccessLog: [],
          Logger:    SilentLogger.new
      end
      Timeout.timeout(60) { sleep 0.1 until server_up? }
      `bin/signet-client`
    ensure
      Process.kill 'KILL', pid
      $stdout = original_stdout
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
      expect { OpenSSL::X509::Certificate.new File.read(CERTIFICATE_PATH) }.not_to raise_error
    end

    it 'is signed by the certificate authority' do
      OpenSSL::X509::Certificate.new(File.read CERTIFICATE_PATH).verify(ca_private_key).should be true
    end
  end
end
