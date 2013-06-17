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

ENV['RACK_ENV'] = 'test'

include Signet::Configuration

CERTIFICATE_PATH = File.expand_path("#{__FILE__}../../../ssl/#{environment}/signed_certificate.pem")

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
