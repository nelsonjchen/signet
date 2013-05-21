require 'openssl'

module CertificateSigner
  class CertificateSigner

    def self.certificate_for(csr_string)
      raise ArgumentError if csr_string.nil?
      request                = OpenSSL::X509::Request.new(csr_string)
      certificate            = OpenSSL::X509::Certificate.new
      certificate.subject    = request.subject
      certificate.public_key = request.public_key

      # certificate.sign ca_key.private_key, OpenSSL::Digest::SHA1.new
      certificate.to_pem
    end

    def self.ca_key
      @@ca_key ||= nil
    end
  end
end
