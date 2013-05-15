require 'spec_helper'
require 'certificate_signer/user'

module CertificateSigner
  describe User do
    it 'is an ActiveRecord::Base instance' do
      User.ancestors.include? ActiveRecord::Base
    end
  end
end
