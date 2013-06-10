require 'openssl'
require 'signet/configuration'

module OpenSSLHelpers

  include Signet::Configuration

  def valid_csr(name="#{subject.class}-#{Time.now.to_i}")
    @name = name

    csr = OpenSSL::X509::Request.new
    key = OpenSSL::PKey::RSA.new(2048)

    csr.public_key = key.public_key
    csr.subject    = csr_subject
    csr.version    = 0

    csr.sign key, OpenSSL::Digest::SHA1.new
  end

  def ca_private_key
    OpenSSL::PKey::RSA.new(File.read(ca_private_key_path), config['certificate_authority']['passphrase'])
  end

  def ca_certificate
    OpenSSL::X509::Certificate.new(File.read(ca_certificate_path))
  end

  def ca_public_key
    ca_private_key.public_key
  end

  private

  def ca_private_key_path
    "#{ssl_prefix}/#{environment}/ca_private_key.pem"
  end

  def ssl_prefix
    File.expand_path("#{File.dirname(__FILE__)}/../../ssl")
  end

  def ca_certificate_path
    "#{ssl_prefix}/#{environment}/ca_certificate.pem"
  end

  def csr_subject
    OpenSSL::X509::Name.new(
      config['certificate_authority']['subject'].merge({'CN' => @name}).to_a
    )
  end
end
