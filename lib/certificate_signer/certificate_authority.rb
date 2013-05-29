require 'certificate_signer/configuration'
require 'openssl'

module CertificateSigner

  ##
  # As far as this app is concerned, there is only one CertificateAuthority in
  # the whole world so it makes sense for it to have one and only one state and
  # to call the methods as class methods like you would with Time.now or
  # Math.log. Therefore, we pass calls to missing class methods on to a
  # class-wide instance so we can use this like a library, i.e.
  # CertificateAuthority.private_key instead of
  # CertificateAuthority.new.private_key. Both usages are valid, so use
  # whichever one makes sense in your context. All methods are implemented as
  # instance methods because state helps us cache and what-not, and it's much
  # easier to test.
  #
  # While the implementation does maintain state, any method can be called in
  # any order, and will ensure that the proper state is set up as needed.
  #
  class CertificateAuthority

    include CertificateSigner::Configuration

    def self.method_missing(meth, *args, &block)
      @@ca ||= new
      @@ca.send(meth, *args, &block)
    end

    def private_key
      @@private_key ||= OpenSSL::PKey::RSA.new(File.read(private_key_path), config['certificate_authority']['passphrase'])
    end

    def certificate
      @@certificate ||= OpenSSL::X509::Certificate.new(File.read(certificate_path))
    end

    def public_key
      @@public_key  ||= private_key.public_key
    end

    private

    def private_key_path
      "#{ssl_prefix}/#{environment}/ca_private_key.pem"
    end

    def ssl_prefix
      File.expand_path("#{File.dirname(__FILE__)}/../../ssl")
    end

    def certificate_path
      "#{ssl_prefix}/#{environment}/ca_certificate.pem"
    end
  end
end
