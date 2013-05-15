require 'active_record'
require 'certificate_signer/active_record_connection'

module CertificateSigner
  class User < ActiveRecord::Base
    include ActiveRecordConnection
  end
end
