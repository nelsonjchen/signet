require 'net/http'
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

    def certificate
      response = Net::HTTP.post_form(post_uri, {
        'auth' => config['client']['identity_key'],
        'csr'  => certificate_signing_request.to_pem,
      })
      response.body
    end

    def certificate_signing_request
      @@certificate_signing_request ||= -> do
        csr = OpenSSL::X509::Request.new

        csr = OpenSSL::X509::Request.new
        key = OpenSSL::PKey::RSA.new(2048)

        csr.public_key = key.public_key
        csr.subject    = csr_subject
        csr.version    = config['certificate_authority']['version']
        csr.sign key, OpenSSL::Digest::SHA1.new
      end.call
    end

    def post_uri
      @@post_uri ||= URI.parse "#{config['client']['server']}/csr"
    end

    def certificate_path
      @@certificate_path ||= File.expand_path("#{__FILE__}../../../../ssl/#{environment}/signed_certificate.pem")
    end

    def csr_subject
      OpenSSL::X509::Name.new(
        config['certificate_authority']['subject'].merge({'CN' => @name}).to_a
      )
    end
  end
end
