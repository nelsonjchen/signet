require 'spec_helper'
require 'signet/active_record_connection'

describe Signet::ActiveRecordConnection do

  def new_class_with_connection
    Class.new { include Signet::ActiveRecordConnection }
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

  context 'when included by many classes simultaneously' do

    it 'uses the same connection for all classes' do
      connection = nil
      in_new_class_with_connection { connection = ActiveRecord::Base.connection }
      10.times {
        in_new_class_with_connection { ActiveRecord::Base.connection.should == connection }
      }
    end
  end
end
