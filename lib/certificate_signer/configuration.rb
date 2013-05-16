require 'yaml'

module CertificateSigner
  module Configuration

    def config
      @@config ||= YAML.load_file("#{environment}.yml")
    end

    def environment
      ENV['RACK_ENV'] || 'test'
    end
  end
end
