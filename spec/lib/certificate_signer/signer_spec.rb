require 'spec_helper'
require 'support/openssl_helpers'
require 'certificate_signer/signer'

describe CertificateSigner::Signer do

  include OpenSSLHelpers

  it 'requires a valid certificate signing request parameter' do
    expect { CertificateSigner::Signer.certificate_for             }.to     raise_error ArgumentError
    expect { CertificateSigner::Signer.certificate_for 'not a csr' }.to     raise_error OpenSSL::X509::RequestError
    expect { CertificateSigner::Signer.certificate_for  valid_csr  }.to_not raise_error
  end

  it 'signs a valid certificate request' do

  end
end
