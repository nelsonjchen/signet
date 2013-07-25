require 'signet/authenticator'

module Signet

  module Shims

    class ::Signet::Authenticator

      # Authenticating with credentials should be handled by an authentication
      # endpoint that gives you an auth token (like OAuth or something) which is
      # used to perform authenticated actions. You should only have to give your
      # credentials to that one API, so this should be removed when that beautiful
      # dream is achieved.
      #
      # When this is removed, the associated email and password columns should be
      # removed from the migrations and schema. And the FactoryGirl factories.
      #
      def self.valid_credentials?(email, password)
        !!User.find_by(email: email, password: password_hash(password))
      end

      private

      def self.password_hash(password)
        Digest::SHA1.hexdigest password
      end
    end
  end
end
