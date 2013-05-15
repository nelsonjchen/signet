require 'openssl'

module CertificateSigner
  class Signer

    def self.certificate_for(csr_string)
      raise ArgumentError if csr_string.nil?
      csr = OpenSSL::X509::Request.new(csr_string)
    end
  end
end
