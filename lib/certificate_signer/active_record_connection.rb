require 'active_record'
require 'certificate_signer/configuration'

module CertificateSigner
  module ActiveRecordConnection
    extend Configuration
    ActiveRecord::Base.establish_connection YAML.load_file('config/database.yml')[environment]
  end
end
