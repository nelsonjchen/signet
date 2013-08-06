require 'signet/configuration'
require 'signet/user'

include Signet::Configuration

FactoryGirl.define do
  factory :valid_user, class: Signet::User do
    initialize_with do
      Signet::User.find_or_create_by identity_key: config.client.identity_key
    end
  end
end

FactoryGirl.create :valid_user
