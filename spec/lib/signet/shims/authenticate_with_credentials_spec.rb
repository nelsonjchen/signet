require 'spec_helper'
require 'signet/authenticator'
require 'signet/user'

require 'signet/shims/authenticate_with_credentials'

describe Signet::Authenticator do
  describe '::valid_credentials?' do

    it 'fails with invalid credentials (bad username or password)' do
      Signet::Authenticator.valid_credentials?('boo', 'urns').should be false
    end

    it 'succeds with valid credentials' do
      Signet::Authenticator.valid_credentials?(
        valid_user.email, config['client']['password'] # password is hashed in database, so pull it from config
      ).should be true
    end
  end
end
