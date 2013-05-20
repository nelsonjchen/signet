require 'spec_helper'
require 'certificate_signer/authenticator'
require 'certificate_signer/user'

module CertificateSigner
  describe Authenticator do
    describe '::valid_identity_key?' do

      it 'fails with an invalid authentication token' do
        Authenticator.valid_identity_key?('invalid_token').should be false
      end

      it 'succeeds with valid authentication token' do
        Authenticator.valid_identity_key?(valid_user.identity_key).should be true
      end
    end
  end
end
