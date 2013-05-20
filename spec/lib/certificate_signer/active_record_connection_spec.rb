require 'spec_helper'
require 'certificate_signer/active_record_connection'

describe CertificateSigner::ActiveRecordConnection do

  def new_class_with_connection
    Class.new { include CertificateSigner::ActiveRecordConnection }
  end

  def in_new_class_with_connection(&block)
    new_class_with_connection.new.instance_eval(&block)
  end

  it 'establishes an ActiveRecord::Base connection' do
    expect {
      new_class_with_connection
      ActiveRecord::Base.connection
    }.to_not raise_error ActiveRecord::ConnectionNotEstablished
  end
end
