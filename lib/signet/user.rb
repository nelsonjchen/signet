require 'active_record'
require 'signet/active_record_connection'

module Signet
  class User < ActiveRecord::Base
    include ActiveRecordConnection
  end
end
