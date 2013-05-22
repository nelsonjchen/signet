require 'active_record'
require 'certificate_signer/configuration'

module CertificateSigner
  module ActiveRecordConnection
    extend Configuration
    ActiveRecord::Base.establish_connection config['database']
  end
end
