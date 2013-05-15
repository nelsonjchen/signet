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
require 'openssl'
require 'rack/test'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.include Rack::Test::Methods
end

FactoryGirl.find_definitions

##
# Returns the RSpec subject which will be the middleware or app that is being
# spec-ed when Rack::Test::Methods methods call `app`.
#
def app
  subject # inherited from RSpec::Core::Subject::ExampleMethods
end

def status_code(symbol)
  Rack::Utils.status_code symbol
end

def valid_user
  @valid_user ||= FactoryGirl.build(:user)
end

def authenticated_csr(params={})
  post '/csr', { 'auth' => valid_user.identity_key }.merge(params)
end
