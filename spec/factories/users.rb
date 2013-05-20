require 'certificate_signer/user'
require 'digest/md5'

module CertificateSigner
  FactoryGirl.define do
    factory :user, class: User do
      initialize_with do
        User.find_or_create_by_identity_key Digest::MD5.hexdigest('VALID_KEY')
      end
    end
  end
end
