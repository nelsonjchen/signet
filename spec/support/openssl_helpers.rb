require 'openssl'
require 'signet/configuration'

module OpenSSLHelpers

  include Signet::Configuration

  def valid_csr(name=default_name)
    @name = name

    csr = OpenSSL::X509::Request.new
    key = OpenSSL::PKey::RSA.new(2048)

    csr.public_key = key.public_key
    csr.subject    = csr_subject
    csr.version    = config['certificate_authority']['version']

    csr.sign key, OpenSSL::Digest::SHA1.new
  end

  def valid_certificate(name=default_name)
    csr = valid_csr(name)
    OpenSSL::X509::Certificate.new.tap do |cert|
      now             = Time.now
      cert.subject    = csr.subject
      cert.public_key = csr.public_key
      cert.serial     = cert_serial
      cert.version    = config['certificate_authority']['version']
      cert.not_before = now
      cert.not_after  = now + config['certificate_authority']['expiry_seconds']
      cert.sign ca_private_key, OpenSSL::Digest::SHA1.new
    end
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

  ##
  # Returns a self-signed certificate NOT signed by this CA
  #
  def some_other_cert
    private_key     = OpenSSL::PKey::RSA.new 2048
    public_key      = private_key.public_key
    cert            = OpenSSL::X509::Certificate.new
    subject         = OpenSSL::X509::Name.parse '/DC=org/DC=example/CN=other cert'
    cert.subject    = subject
    cert.issuer     = subject
    cert.version    = 2
    cert.serial     = 1
    cert.not_before = Time.now
    cert.not_after  = Time.now + 10e7
    cert.public_key = public_key
    cert.sign private_key, OpenSSL::Digest::SHA1.new
  end

  private

  def default_name
    "#{subject.class}-#{Time.now.to_i}"
  end

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

  ##
  # Returns a reasonably unique integer for use as a serial number
  #
  def cert_serial
    SecureRandom.uuid.gsub(/-/, '').hex
  end
end
