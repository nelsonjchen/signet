require 'net/http'
require 'net/https'
require 'openssl'
require 'signet/configuration'

module Signet
  class Client

    include Signet::Configuration

    def self.run
      new.send :run
    end

    private

    def initialize
      @name = config['client']['name']
    end

    def run
      save_certificate_to_file
    end

    def save_certificate_to_file
      File.open(certificate_path, 'w') {|file| file.write certificate }
    end

    def uri
      @uri ||= URI.parse "https://#{config['client']['server']}:#{config['client']['port']}/csr"
    end

    def request
      Net::HTTP::Post.new(uri.to_s).tap do |request|
        request.set_form_data post_parameters
      end
    end

    def http
      Net::HTTP.new(uri.hostname, uri.port).tap do |http|
        http.use_ssl = true if ENV['RACK_ENV'] == 'production'
      end
    end

    def certificate
      response = http.request request
      # TODO handle non-200 response codes. D'doy!
      response.body
    end

    def post_parameters
      @post_parameters ||= {
        'auth' => config['client']['identity_key'],
        'csr'  => certificate_signing_request.to_pem,
      }
    end

    def certificate_signing_request
      @certificate_signing_request ||= OpenSSL::X509::Request.new.tap do |csr|
        csr.public_key = private_key.public_key
        csr.subject    = csr_subject
        csr.version    = config['certificate_authority']['version']
      end.sign private_key, OpenSSL::Digest::SHA1.new
    end

    def ssl_path
      @ssl_path ||= File.expand_path("#{__FILE__}../../../../ssl/#{environment}")
    end

    def private_key_path
      @private_key_path ||= "#{ssl_path}/client_private_key.pem"
    end

    def certificate_path
      @certificate_path ||= "#{ssl_path}/client_certificate.pem"
    end

    def csr_subject
      OpenSSL::X509::Name.new(
        config['certificate_authority']['subject'].merge({'CN' => @name}).to_a
      )
    end

    def private_key
      OpenSSL::PKey.read File.read(private_key_path)
    rescue Errno::ENOENT
      key = OpenSSL::PKey::RSA.new(2048)
      File.write private_key_path, key.to_pem
      key
    end
  end
end
