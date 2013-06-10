require 'signet/user'
require 'digest/md5'

FactoryGirl.define do
  factory :user, class: Signet::User do
    initialize_with do
      Signet::User.find_or_create_by_identity_key Digest::MD5.hexdigest('VALID_KEY')
    end
  end
end
