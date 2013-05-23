require 'spec_helper'
require 'certificate_signer/configuration'

describe CertificateSigner::Configuration do

  def in_new_class(&block)
    Class.new { include CertificateSigner::Configuration }.new.instance_eval(&block)
  end

  def with_rack_env(temporary_env)
    original_env = ENV['RACK_ENV']
    ENV['RACK_ENV'] = temporary_env
    yield
    ENV['RACK_ENV'] = original_env
  end

  def expected_config_path(env)
    File.expand_path("#{File.dirname(__FILE__)}../../../../config/#{env}.yml")
  end

  describe '#environment' do

    it "gets the value of ENV['RACK_ENV']" do
      with_rack_env('derp') do
        in_new_class { environment.should == 'derp' }
      end
    end

    it "raises an error if ENV['RACK_ENV'] is not defined" do
      with_rack_env(nil) do
        expect {
          in_new_class { environment }
        }.to raise_error ArgumentError, "ENV['RACK_ENV'] must be defined"
      end
    end
  end

  describe '#config_path' do

    before(:each) do
      CertificateSigner::Configuration.class_variable_set :@@config_path, nil
    end

    it 'returns the path to the configuration file' do
      env = 'derp'
      expected_config_path = expected_config_path(env)
      with_rack_env(env) do
        in_new_class { config_path.should == expected_config_path }
      end
    end
  end

  describe '#config' do

    before(:each) do
      CertificateSigner::Configuration.class_variable_set :@@config, nil
      CertificateSigner::Configuration.class_variable_set :@@config_path, nil
      YAML.rspec_reset
    end

    after(:all) { YAML.rspec_reset }

    it 'loads the appropriate YAML file for the environment' do
      env = 'derp'
      expected_config_path = expected_config_path(env)
      with_rack_env(env) do
        YAML.should_receive(:load_file).with expected_config_path
        in_new_class { config }
      end
    end

    it 'only loads once' do
      YAML.stub(:load_file).and_return({})
      YAML.should_receive(:load_file).once
      10.times { in_new_class { config } }
    end
  end
end
