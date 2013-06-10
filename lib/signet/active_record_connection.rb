require 'active_record'
require 'signet/configuration'

module Signet
  module ActiveRecordConnection
    extend Configuration
    ActiveRecord::Base.establish_connection config['database']
  end
end
