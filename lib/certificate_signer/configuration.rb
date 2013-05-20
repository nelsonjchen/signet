require 'yaml'

module CertificateSigner
  module Configuration

    def config
      @@config ||= YAML.load_file("config/#{environment}.yml")
    end

    def environment
      ENV['RACK_ENV'] or raise ArgumentError.new("ENV['RACK_ENV'] must be defined")
    end
  end
end
