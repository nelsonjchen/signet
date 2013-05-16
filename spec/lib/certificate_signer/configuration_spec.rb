require 'spec_helper'
require 'certificate_signer/configuration'

module CertificateSigner

  describe Configuration do

    def in_new_class(&block)
      Class.new { include Configuration }.new.instance_eval(&block)
    end

    def with_rack_env(env)
      original_env = ENV['RACK_ENV']
      ENV['RACK_ENV'] = env
      yield
      ENV['RACK_ENV'] = original_env
    end

    describe '#environment' do

      it "gets the value of ENV['RACK_ENV'] if available" do
        with_rack_env('derp') do
          in_new_class { environment.should == 'derp' }
        end
      end

      it "defaults to 'test' if ENV['RACK_ENV'] is not defined" do
        with_rack_env(nil) do
          in_new_class { environment.should == 'test' }
        end
      end
    end

    describe '#config' do

      before :each do
        YAML.rspec_reset
        YAML.stub(:load_file).and_return({})
      end

      after :each do
        YAML.rspec_reset
      end

      it 'loads the appropriate YAML file for the environment' do
        with_rack_env('derp') do
          YAML.should_receive(:load_file).with('derp.yml')
          in_new_class { config }
        end
      end

      it 'only loads once' do
        YAML.should_receive(:load_file).once
        10.times { in_new_class { config } }
      end
    end
  end
end
