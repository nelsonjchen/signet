require 'active_record'

module CertificateSigner
  module ActiveRecordConnection
    environment = ENV['RACK_ENV'] || defined?(RSpec) ? 'test' : 'development'
    ActiveRecord::Base.establish_connection YAML.load_file('config/database.yml')[environment]
  end
end
