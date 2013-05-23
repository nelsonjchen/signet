require 'certificate_signer/configuration'

module CertificateSigner
  class CertificateAuthority
    include CertificateSigner::Configuration

    def self.private_key
    end
  end
end
