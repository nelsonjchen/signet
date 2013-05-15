require 'spec_helper'
require 'certificate_signer/active_record_connection'

module CertificateSigner
  describe ActiveRecordConnection do

    it 'establishes an ActiveRecord::Base connection' do
      expect {
        Class.new { include ActiveRecordConnection }
        ActiveRecord::Base.connection
      }.to_not raise_error ActiveRecord::ConnectionNotEstablished
    end
  end
end
