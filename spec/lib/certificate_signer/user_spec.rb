require 'spec_helper'
require 'certificate_signer/user'
require 'certificate_signer/active_record_connection'

describe CertificateSigner::User do
  context 'class ancestors' do
    subject { CertificateSigner::User.ancestors }
    it { should include ActiveRecord::Base }
    it { should include CertificateSigner::ActiveRecordConnection }
  end
end
