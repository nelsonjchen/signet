require 'openssl'
require 'certificate_signer/configuration'

module CertificateSigner
  class CertificateAuthority

    include Configuration

    def self.private_key
    end
  end
end
