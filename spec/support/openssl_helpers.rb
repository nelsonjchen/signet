module OpenSSLHelpers

  def valid_csr(name="#{subject}#{Time.now.to_i.to_s}")
    csr = OpenSSL::X509::Request.new
    key = OpenSSL::PKey::RSA.new(2048)

    csr.public_key = key.public_key
    csr.subject    = OpenSSL::X509::Name.parse "CN=#{name}/DC=features"
    csr.version    = 0

    csr.sign key, OpenSSL::Digest::SHA1.new
  end

  def ca_private_key
  end
end
