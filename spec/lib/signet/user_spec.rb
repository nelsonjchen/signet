require 'spec_helper'
require 'signet/active_record_connection'
require 'signet/user'

describe Signet::User do
  context 'class ancestors' do
    subject { Signet::User.ancestors }
    it { should include ActiveRecord::Base }
    it { should include Signet::ActiveRecordConnection }
  end
end
