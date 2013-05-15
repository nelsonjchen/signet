CertificateSigner
=================

[![Build Status](https://secure.travis-ci.org/SmartReceipt/certificate_signer.png)](https://travis-ci.org/SmartReceipt/certificate_signer)
[![Coverage Status](https://coveralls.io/repos/SmartReceipt/certificate_signer/badge.png?branch=master)](https://coveralls.io/r/SmartReceipt/certificate_signer)
[![Code Climate](https://codeclimate.com/github/SmartReceipt/certificate_signer.png)](https://codeclimate.com/github/SmartReceipt/certificate_signer)
[![Dependency Status](https://gemnasium.com/SmartReceipt/certificate_signer.png)](https://gemnasium.com/SmartReceipt/certificate_signer)

Scratch
-------

This is a handy bit of CSR code that we'll implement in the client later.

```ruby
def csr(name)
  csr = OpenSSL::X509::Request.new
  key = OpenSSL::PKey::RSA.new(2048)

  csr.public_key = key.public_key
  csr.subject    = OpenSSL::X509::Name.parse "CN=#{name.to_s}/DC=features"
  csr.version    = 0

  csr.sign key, OpenSSL::Digest::SHA1.new
end
```
