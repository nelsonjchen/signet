$: << 'lib'

require 'active_record'
require 'certificate_signer/configuration'
require 'openssl'
require 'rspec/core/rake_task'

include CertificateSigner::Configuration

ENV['RACK_ENV'] ||= 'development'

task default: :spec

RSpec::Core::RakeTask.new(:spec)

desc 'Run all tasks necessary to test and develop'
task :init do
  %w[
    db:migrate
    ssl:ca
  ].each do |task|
    Rake::Task[task].invoke
  end
end

namespace :db do
  desc 'Migrate the database (optionally to a specific VERSION)'
  task migrate: :environment do
    version = ENV['VERSION'] ? ENV['VERSION'].to_i : nil
    ActiveRecord::Migrator.migrate 'db/migrate', version
  end
end

task :environment do
  ActiveRecord::Base.establish_connection config['database']
end

namespace :ssl do
  desc 'Generate Certificate Authority files in ssl directory'
  task :ca do
    TaskHelper::SSL.ca
  end
end

private

module TaskHelper
  class SSL

    include CertificateSigner::Configuration

    SSL_DIR             = "ssl/#{environment}"
    KEY_FILE            = "#{SSL_DIR}/ca_private_key.pem"
    CA_CERTIFICATE_FILE = "#{SSL_DIR}/ca_certificate.pem"
    KEY_PASSPHRASE      = config['certificate_authority']['passphrase']

    def self.ca
      new.setup
    end

    def setup
      make_private_key
      make_certificate
    end

    def make_private_key
      File.open KEY_FILE, 'w' do |file|
        file.write key.to_pem(OpenSSL::Cipher.new('AES-128-CBC'), KEY_PASSPHRASE)
      end
    end

    def make_certificate
      cert            = OpenSSL::X509::Certificate.new
      subject         = OpenSSL::X509::Name.new(config['certificate_authority']['subject'].to_a)
      cert.subject    = subject
      cert.issuer     = subject
      cert.version    = config['certificate_authority']['version']
      cert.serial     = config['certificate_authority']['serial']
      cert.not_before = Time.now
      cert.not_after  = Time.now + config['certificate_authority']['expiry_seconds']
      cert.public_key = key.public_key

      extension_factory = OpenSSL::X509::ExtensionFactory.new
      extension_factory.subject_certificate = cert
      extension_factory.issuer_certificate  = cert

      [
        [ 'subjectKeyIdentifier', 'hash' ],
        [ 'basicConstraints', 'CA:TRUE', true ],
        [ 'keyUsage', 'cRLSign,keyCertSign', true ],
      ].each do |extension|
        cert.add_extension extension_factory.create_extension(extension)
      end

      cert.sign key, OpenSSL::Digest::SHA1.new

      File.open CA_CERTIFICATE_FILE, 'w' do |file|
        file.write cert.to_pem
      end
    end

    def key
      @key ||= OpenSSL::PKey::RSA.new(2048)
    end
  end
end
