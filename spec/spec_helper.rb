require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter 'spec'
end

require 'factory_girl'
require 'find'
require 'openssl'
require 'rack/test'
require 'signet/configuration'
require 'signet/certificate_authority'

ENV['RACK_ENV'] = 'test'

include Signet::Configuration

BASE_SSL_PATH               = File.expand_path("#{__FILE__}../../../ssl/")
CERTIFICATE_PATH            = "#{BASE_SSL_PATH}/#{environment}/signed_certificate.pem"
PRODUCTION_CA_CERT_PATH     = "#{BASE_SSL_PATH}/production/ca_certificate.pem"
PRODUCTION_PRIVATE_KEY_PATH = "#{BASE_SSL_PATH}/production/ca_private_key.pem"
PRODUCTION_CONFIG_PATH      = File.expand_path("#{__FILE__}../../../config/production.yml")

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.include Rack::Test::Methods
end

FactoryGirl.find_definitions

def valid_user
  @valid_user ||= FactoryGirl.build(:user)
end

def production_files_exist?
  [
    PRODUCTION_CA_CERT_PATH,
    PRODUCTION_PRIVATE_KEY_PATH,
    PRODUCTION_CONFIG_PATH
  ].each do |path|
    return false unless File.exist? path
  end
end

def production_private_key_passphrase
  @@production_private_key_passphrase ||= \
    YAML.load_file(PRODUCTION_CONFIG_PATH)['certificate_authority']['passphrase']
end

def production_ca_private_key
  @@production_ca_private_key ||= \
    OpenSSL::PKey::RSA.new File.read(PRODUCTION_PRIVATE_KEY_PATH), production_private_key_passphrase
end

def production_ca_public_key
  @production_ca_public_key ||= production_ca_private_key.public_key
end

def production_ca_certificate
  @production_ca_certificate ||= OpenSSL::X509::Certificate.new File.read(PRODUCTION_CA_CERT_PATH)
end

def unset_configuration
  Signet::Configuration.class_variables.each do |var|
    Signet::Configuration.class_variable_set var, nil
  end
end

def unset_certificate_authority
  Signet::CertificateAuthority.class_variables.each do |var|
    Signet::CertificateAuthority.class_variable_set var, nil
  end
end
