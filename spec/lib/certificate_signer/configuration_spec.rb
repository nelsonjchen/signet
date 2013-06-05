require 'spec_helper'
require 'certificate_signer/configuration'

FAKE_CONFIG = {}

describe CertificateSigner::Configuration do

  def new_class
    Class.new { include CertificateSigner::Configuration }
  end

  def in_new_class(&block)
    new_class.new.instance_eval(&block)
  end

  def unset_config
    CertificateSigner::Configuration.class_variable_set :@@config, nil
  end

  def expected_config_path(env)
    File.expand_path("#{File.dirname(__FILE__)}../../../../config/#{env}.yml")
  end

  def with_env(env, &block)
    original_env = ENV['RACK_ENV']
    ENV['RACK_ENV'] = env
    yield
    ENV['RACK_ENV'] = original_env
  end

  around :each do |example|
    reset = -> do
      unset_config
      begin
        YAML.rspec_reset
      rescue NoMethodError
        # FIXME Ignore that! It can happen with random test ordering. Still, I'd
        # rather write the specs so this stops happening than hack around it.
      end
    end
    reset.call
    example.run
    reset.call
  end

  describe '#config' do

    it 'returns the configuration as a Hash' do
      new_class.new.config.should be_a Hash
    end

    it 'loads the configuration for the current environment' do
      object      = new_class.new
      environment = object.environment
      config_path = object.send(:config_path)

      config_path.should match "config/#{environment}.yml"
      YAML.should_receive(:load_file).with(config_path)

      object.config
    end

    it 'only loads the config once for all instances of all classes' do
      YAML.should_receive(:load_file).once.and_return FAKE_CONFIG
      3.times do
        in_new_class do
          3.times { config }
        end
      end
    end

  end

  describe '#environment' do

    it 'returns the environment (e.g. test, development, production)' do
      %w[ test development production ].each do |env|
        with_env env do
          new_class.new.environment.should == env
        end
      end
    end
  end

  describe '#config_path' do

    it 'matches the current environment' do
      object = new_class.new
      object.send(:config_path).should match "config/#{object.environment}.yml"
    end
  end
end
