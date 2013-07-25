require 'sinatra/base'

module Signet
  module Shims
    class CertificateSignerV1 < Sinatra::Base

      before { cache_identity_key if authenticating_with_credentials? }

      private

      def cache_identity_key
        identity_key = User.find_by(email: params[:user], password: params[:pass]).identity_key
        p identity_key
      end

      def authenticating_with_credentials?
        params[:user] and params[:pass]
      end
    end
  end
end
