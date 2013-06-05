require 'yaml'

module CertificateSigner
  module Configuration

    def config
      @@config ||= YAML.load_file(config_path)
    end

    def environment
      ENV['RACK_ENV'] or raise ArgumentError.new("ENV['RACK_ENV'] must be defined")
    end

    private

    def config_path
      @@config_path ||= File.expand_path("#{File.dirname(__FILE__)}../../../config/#{environment}.yml")
    end
  end
end
