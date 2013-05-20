require 'certificate_signer/user'

module CertificateSigner
  class Authenticator

    def self.valid_identity_key?(identity_key)
      !!User.find_by_identity_key(identity_key)
    end
  end
end
