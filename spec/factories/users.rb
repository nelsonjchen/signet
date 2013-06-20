require 'signet/user'
require 'signet/configuration'

include Signet::Configuration

FactoryGirl.define do
  factory :valid_user, class: Signet::User do
    initialize_with do
      Signet::User.find_or_create_by_identity_key config['client']['identity_key']
    end
  end
end

FactoryGirl.create :valid_user
