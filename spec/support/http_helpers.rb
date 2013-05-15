require 'support/openssl_helpers'

module HTTPHelpers

  include OpenSSLHelpers

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

  def csr_post(overrides={})
    default_params = {
      'auth' => valid_user.identity_key,
      'csr'  => valid_csr,
    }
    post '/csr', default_params.merge(overrides)
  end
end
